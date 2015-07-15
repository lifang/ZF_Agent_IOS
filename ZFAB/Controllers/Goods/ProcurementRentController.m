//
//  ProcurementRentController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ProcurementRentController.h"
#import "RegularFormat.h"
#import "RentDescriptionController.h"

@interface ProcurementRentController ()<UITextFieldDelegate>

@property (nonatomic, assign) int count;

@property (nonatomic, strong) UITextField *numberField;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *minusButton;

@property (nonatomic, strong) UIButton *rentButton;

@property (nonatomic, strong) UIButton *agreeBtn;

@end

@implementation ProcurementRentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"租赁订单确认";
    _count = 1;
    [self updatPrice];
    [self initSubView];
    [self setTableFooterView];
    self.userLabel.text = @"选择用户";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setTableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80.f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake(20, 20, 18, 18);
    [_agreeBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_agreeBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_agreeBtn addTarget:self action:@selector(agreeRent:) forControlEvents:UIControlEventTouchUpInside];
    _agreeBtn.selected = YES;
    [self setSelectedStatus];
    [footerView addSubview:_agreeBtn];
    
    UILabel *rentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, kScreenWidth - 40, 20)];
    rentLabel.backgroundColor = [UIColor clearColor];
    rentLabel.font = [UIFont systemFontOfSize:13.f];
    rentLabel.userInteractionEnabled = YES;
    NSString *rentInfo = @"我同意《租赁协议》";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:rentInfo];
    NSDictionary *rentAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:13.f],NSFontAttributeName,
                              kMainColor,NSForegroundColorAttributeName,
                              nil];
    [attrString addAttributes:rentAttr range:NSMakeRange(3, [rentInfo length] - 3)];
    rentLabel.attributedText = attrString;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanProtocol:)];
    [rentLabel addGestureRecognizer:tap];
    [footerView addSubview:rentLabel];
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
    _minusButton.backgroundColor = [UIColor redColor];
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
    
    _rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rentButton.layer.cornerRadius = 4;
    _rentButton.layer.masksToBounds = YES;
    _rentButton.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
    _rentButton.layer.borderWidth = 1.f;
    [_rentButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
    [_rentButton setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
    _rentButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [_rentButton setTitle:@"查看租赁说明" forState:UIControlStateNormal];
    [_rentButton addTarget:self action:@selector(scanRentInfo:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Request

- (void)createOrderForProcurementRent {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSString *userID = delegate.agentUserID;
    if (self.defaultUser) {
        userID = self.defaultUser.userID;
    }
    [NetworkInterface createOrderFromGoodBuyWithAgentID:delegate.agentID
                                                  token:delegate.token
                                                 userID:userID
                                           createUserID:delegate.userID
                                               belongID:delegate.agentUserID
                                            confirmType:self.confirmType
                                                 goodID:_goodDetail.goodID
                                              channelID:_goodDetail.defaultChannel.channelID
                                                  count:_count
                                              addressID:self.defaultAddress.addressID
                                                comment:self.reviewField.text
                                            needInvoice:0
                                            invoiceType:0
                                            invoiceInfo:nil
                                               finished:^(BOOL success, NSData *response) {
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
                    payC.fromType = PayWayFromGoodProcurementRent;
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
    return (_goodDetail.defaultChannel.openCost + _goodDetail.deposit) * _count;
}

- (void)updatPrice {
    self.payLabel.text = [NSString stringWithFormat:@"实付：￥%.2f",[self getSummaryPrice]];
    self.deliveryLabel.text = [NSString stringWithFormat:@"(含配送费：￥%@)",@"0"];
}

- (void)setSelectedStatus {
    if (_agreeBtn.isSelected) {
        [_agreeBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
    }
    else {
        [_agreeBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    }
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderDetailCell *cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil supplyType:self.supplyType];
        cell.nameLabel.text = _goodDetail.goodName;
        cell.numberLabel.text = [NSString stringWithFormat:@"X %d",_count];
        cell.openPriceLabel.text = [NSString stringWithFormat:@"开通费￥%.2f",_goodDetail.defaultChannel.openCost];
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
        cell.textLabel.text = @"租赁数量（件）";
        _numberField.frame = CGRectMake(kScreenWidth - 100, 10, 90, 24);
        [cell.contentView addSubview:_numberField];
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
        return cell;
    }
    else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.text = @"押金";
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:16.f];
        cell.detailTextLabel.textColor = kColor(255, 102, 36, 1);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",_goodDetail.deposit * _count];
        return cell;
    }
    else if (indexPath.row == 3) {
        //最后一行
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        maxLabel.backgroundColor = [UIColor clearColor];
        maxLabel.font = [UIFont systemFontOfSize:11.f];
        maxLabel.adjustsFontSizeToFitWidth = YES;
        maxLabel.text = [NSString stringWithFormat:@"最长租赁时间：%d月",_goodDetail.maxTime];
        [cell.contentView addSubview:maxLabel];
        
        UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 20)];
        minLabel.backgroundColor = [UIColor clearColor];
        minLabel.font = [UIFont systemFontOfSize:11.f];
        minLabel.adjustsFontSizeToFitWidth = YES;
        minLabel.text = [NSString stringWithFormat:@"最短租赁时间：%d月",_goodDetail.minTime];
        [cell.contentView addSubview:minLabel];
        
        CGFloat price = [self getSummaryPrice];
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 20)];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.font = [UIFont systemFontOfSize:11.f];
        totalLabel.adjustsFontSizeToFitWidth = YES;
        totalLabel.text = [NSString stringWithFormat:@"共计：%d件商品",_count];
        [cell.contentView addSubview:totalLabel];
        
        UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, 100, 20)];
        deliveryLabel.backgroundColor = [UIColor clearColor];
        deliveryLabel.font = [UIFont systemFontOfSize:11.f];
        deliveryLabel.adjustsFontSizeToFitWidth = YES;
        deliveryLabel.text = [NSString stringWithFormat:@"配送费：￥%@",@"0"];
        [cell.contentView addSubview:deliveryLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, kScreenWidth - 220, 20)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = [UIFont boldSystemFontOfSize:12.f];
        priceLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",price];
        [cell.contentView addSubview:priceLabel];
        
        self.reviewField.frame = CGRectMake(10, 80, kScreenWidth - 20, 32);
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
            rowHeight = 44.f;
            break;
        case 3:
            rowHeight = 120.f;
            break;
        default:
            break;
    }
    return rowHeight;
}

#pragma mark - Action

- (IBAction)scanRentInfo:(id)sender {
    
}

- (IBAction)scanProtocol:(id)sender {
    RentDescriptionController *descC = [[RentDescriptionController alloc] init];
    descC.goodDetail = _goodDetail;
    [self.navigationController pushViewController:descC animated:YES];
}

- (IBAction)agreeRent:(id)sender {
    _agreeBtn.selected = !_agreeBtn.selected;
    [self setSelectedStatus];
}

- (IBAction)ensureOrder:(id)sender {
    NSLog(@"!!");
    if (!_agreeBtn.isSelected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请同意租赁协议";
        return;
    }
    if (!self.defaultAddress) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择收件地址";
        return;
    }
    if (!self.defaultUser) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择用户";
        return;
    }
    [self createOrderForProcurementRent];
}

- (IBAction)countMinus:(id)sender {
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber) {
        int currentCount = [_numberField.text intValue];
        if (currentCount > 1) {
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
    if (isNumber && [_numberField.text intValue] > 0) {
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
