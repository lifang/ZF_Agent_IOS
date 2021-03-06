//
//  WholesaleOrderController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "WholesaleOrderController.h"
#import "RegularFormat.h"

@interface WholesaleOrderController ()<UITextFieldDelegate>

@property (nonatomic, assign) int count;

@property (nonatomic, strong) UITextField *numberField;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *minusButton;

@end

@implementation WholesaleOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"批购订单确认";
    _count = _goodDetail.minWholesaleNumber;
    [self updatPrice];
    [self initSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubView {
    _numberField = [[UITextField alloc] init];
    _numberField.delegate = self;
    _numberField.layer.borderWidth = 1;
    _numberField.layer.borderColor = kColor(193, 192, 192, 1).CGColor;
    _numberField.borderStyle = UITextBorderStyleNone;
    _numberField.font = [UIFont systemFontOfSize:12.f];
    _numberField.textAlignment = NSTextAlignmentCenter;
    _numberField.leftViewMode = UITextFieldViewModeAlways;
    _numberField.rightViewMode = UITextFieldViewModeAlways;
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _minusButton.frame = CGRectMake(0, 0, 25, 25);
    [_minusButton setBackgroundImage:kImageName(@"numberback.png") forState:UIControlStateNormal];
    [_minusButton setTitle:@"-" forState:UIControlStateNormal];
    [_minusButton addTarget:self action:@selector(countMinus:) forControlEvents:UIControlEventTouchUpInside];
    [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _numberField.leftView = _minusButton;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(0, 0, 25, 25);
    [_addButton setBackgroundImage:kImageName(@"numberback.png") forState:UIControlStateNormal];
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(countAdd:) forControlEvents:UIControlEventTouchUpInside];
    _numberField.rightView = _addButton;
}

#pragma mark - Request

- (void)createOrderForWholesale {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    //是否需要发票
    int needInvoice = 0;
    if (self.billBtn.isSelected) {
        needInvoice = 1;
    }
    NSString *userID = delegate.agentUserID;
    if (self.defaultUser) {
        userID = self.defaultUser.userID;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface createOrderFromGoodBuyWithAgentID:delegate.agentID token:delegate.token userID:userID createUserID:delegate.userID belongID:delegate.agentUserID confirmType:self.confirmType goodID:_goodDetail.goodID channelID:_goodDetail.defaultChannel.channelID count:_count addressID:self.defaultAddress.addressID comment:self.reviewField.text needInvoice:needInvoice invoiceType:self.billType invoiceInfo:self.billField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail || [errorCode intValue] == RequestShortInventory) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    NSString *orderID = [NSString stringWithFormat:@"%@",[object objectForKey:@"result"]];
                    PayWayViewController *payC = [[PayWayViewController alloc] init];
                    payC.orderID = orderID;
                    payC.goodID = _goodDetail.goodID;
                    payC.goodName = _goodDetail.goodName;
                    payC.totalPrice = [self getSummaryPrice];
                    payC.fromType = PayWayFromGoodWholesale;
                    [self.navigationController pushViewController:payC animated:YES];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (CGFloat)getSummaryPrice {
    return (_goodDetail.wholesalePrice + _goodDetail.defaultChannel.openCost) * _count;
}

- (void)updatPrice {
    self.payLabel.text = [NSString stringWithFormat:@"实付：￥%.2f",[self getSummaryPrice]];
    self.deliveryLabel.text = [NSString stringWithFormat:@"(含配送费：￥%@)",@"0"];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderDetailCell *cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil supplyType:self.supplyType];
        cell.nameLabel.text = _goodDetail.goodName;
        cell.openPriceLabel.text = [NSString stringWithFormat:@"(含开通费￥%.2f)",_goodDetail.defaultChannel.openCost];
        [cell setPrimaryPriceWithString:[NSString stringWithFormat:@"原价 ￥%.2f",(_goodDetail.primaryPrice + _goodDetail.defaultChannel.openCost)]];
        cell.actualPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",(_goodDetail.wholesalePrice + _goodDetail.defaultChannel.openCost)];
        cell.numberLabel.text = [NSString stringWithFormat:@"X %d",_count];
        cell.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@%@",_goodDetail.goodBrand,_goodDetail.goodModel];
        cell.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",_goodDetail.defaultChannel.channelName];
        if ([_goodDetail.goodImageList count] > 0) {
            [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:[_goodDetail.goodImageList objectAtIndex:0]]
                                placeholderImage:nil];
        }
        return cell;
        
    }
    else if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.text = @"购买数量";

        CGFloat labelWidth = 120.f;
        _numberField.frame = CGRectMake(kScreenWidth - 100, 10, 90, 24);
        [cell.contentView addSubview:_numberField];
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
        UILabel *minWSLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100 - labelWidth - 5, 12, labelWidth, 20)];
        minWSLabel.backgroundColor = [UIColor clearColor];
        minWSLabel.font = [UIFont systemFontOfSize:10.f];
        minWSLabel.textAlignment = NSTextAlignmentRight;
        minWSLabel.text = [NSString stringWithFormat:@"最低起批量：%d件",_goodDetail.minWholesaleNumber];
        [cell.contentView addSubview:minWSLabel];
        return cell;
    }
    else if (indexPath.row == 2) {
        //最后一行
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        CGFloat price = [self getSummaryPrice];
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.font = [UIFont systemFontOfSize:11.f];
        totalLabel.adjustsFontSizeToFitWidth = YES;
        totalLabel.text = [NSString stringWithFormat:@"共计：%d件商品",_count];
        [cell.contentView addSubview:totalLabel];
        
        UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 100, 20)];
        deliveryLabel.backgroundColor = [UIColor clearColor];
        deliveryLabel.font = [UIFont systemFontOfSize:11.f];
        deliveryLabel.adjustsFontSizeToFitWidth = YES;
        deliveryLabel.text = [NSString stringWithFormat:@"配送费：￥%@",@"0"];
        [cell.contentView addSubview:deliveryLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, kScreenWidth - 220, 20)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont boldSystemFontOfSize:12.f];
        priceLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",price];
        [cell.contentView addSubview:priceLabel];
        
        self.reviewField.frame = CGRectMake(10, 40, kScreenWidth - 20, 32);
        [cell.contentView addSubview:self.reviewField];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.f;
    switch (indexPath.row) {
        case 0:
            rowHeight = kOrderDetailCellHeight;
            break;
        case 1:
            rowHeight = 44.f;
            break;
        case 2:
            rowHeight = 90.f;
            break;
        default:
            break;
    }
    return rowHeight;
}

#pragma mark - Action

- (IBAction)ensureOrder:(id)sender {
    if (!self.defaultAddress) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择收件地址";
        return;
    }
    [self createOrderForWholesale];
}

- (IBAction)countMinus:(id)sender {
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber) {
        int currentCount = [_numberField.text intValue];
        if (currentCount > _goodDetail.minWholesaleNumber) {
            currentCount--;
            _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
            _count = currentCount;
            [self updatPrice];
            [self.tableView reloadData];
        }
        else {
            
        }
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
    }
}

- (IBAction)countAdd:(id)sender {
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber) {
        int currentCount = [_numberField.text intValue];
        currentCount++;
        _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
        _count = currentCount;
        [self updatPrice];
        [self.tableView reloadData];
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
    }
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber && [_numberField.text intValue] >= _goodDetail.minWholesaleNumber) {
        int currentCount = [_numberField.text intValue];
        _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
        _count = currentCount;
        [self updatPrice];
        [self.tableView reloadData];
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height + kOffsetKeyboard - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    self.primaryPoint = self.tableView.contentOffset;
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y + self.offset) animated:YES];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y) animated:YES];
        self.offset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.editingField) {
        self.offset = 0;
        [self.editingField resignFirstResponder];
    }
}

@end
