//
//  AfterSaleApplyController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AfterSaleApplyController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "AddressModel.h"
#import "SelectedAddressController.h"
#import "TMSelectedTerminalController.h"
#import "NavigationBarAttr.h"
#import "TMTerminalListController.h"
#import "SerialModel.h"

@interface AfterSaleApplyController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,SelectedAddressDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) AddressModel *defaultAddress;

@property (nonatomic, strong) NSMutableArray *addressItem;

//选中的终端号数组 通过通知传递
@property (nonatomic, strong) NSArray *selectedTerminalList;

@end

@implementation AfterSaleApplyController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请售后";
    _addressItem = [[NSMutableArray alloc] init];
    [self initAndLauoutUI];
    [self getAddressList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getSelectedTerminalList:)
                                                 name:getSelectedTerminalsNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitApply:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLauoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.font = [UIFont systemFontOfSize:15.f];
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.textColor = kColor(146, 146, 146, 1);
    _placeholderLabel.font = [UIFont systemFontOfSize:15.f];
    _placeholderLabel.text = @"售后原因";
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.font = [UIFont systemFontOfSize:12.f];
    _tipLabel.text = @"最多填写200个汉字";

}

#pragma mark - Request

- (void)getAddressList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAddressListWithAgentUserID:delegate.agentUserID token:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseAddressListDataWithDict:object];
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

- (void)submitAfterSaleApply {
    NSString *terminalString = [self terminalStringWithArray:_selectedTerminalList];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitAfterSaleApplyWithUserID:delegate.agentUserID token:delegate.token terminalCount:[_selectedTerminalList count] address:_defaultAddress.address receiver:_defaultAddress.addressReceiver phoneNumber:_defaultAddress.addressPhone reason:_textView.text terminalList:terminalString finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"提交申请成功";
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

- (void)parseAddressListDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_addressItem removeAllObjects];
    NSArray *addressList = [dict objectForKey:@"result"];
    for (int i = 0; i < [addressList count]; i++) {
        NSDictionary *addressDict = [addressList objectAtIndex:i];
        AddressModel *model = [[AddressModel alloc] initWithParseDictionary:addressDict];
        [_addressItem addObject:model];
    }
    for (AddressModel *model in _addressItem) {
        if ([model.isDefault intValue] == AddressDefault) {
            _defaultAddress = model;
            break;
        }
    }
    if (!_defaultAddress && [_addressItem count] > 0) {
        _defaultAddress = [_addressItem objectAtIndex:0];
    }
    [_tableView reloadData];
}

- (NSString *)terminalStringWithArray:(NSArray *)terminalList {
    NSString *names = @"";
    for (int i = 0; i < [terminalList count]; i++) {
        SerialModel *model = [terminalList objectAtIndex:i];
        names = [names stringByAppendingString:model.serialNumber];
        if (i != [terminalList count] - 1) {
            names = [names stringByAppendingString:@","];
        }
    }
    return names;
}

#pragma mark - Action

- (IBAction)submitApply:(id)sender {
    if ([_selectedTerminalList count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择终端";
        return;
    }
    if (!_defaultAddress) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择地址";
        return;
    }
    if (!_textView.text || [_textView.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入售后原因";
        return;
    }
    [self submitAfterSaleApply];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.textLabel.text = @"选择终端号";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [self terminalStringWithArray:_selectedTerminalList];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        }
            break;
        case 1: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            NSString *name = @"";
            NSString *phoneNumber = @"";
            NSString *address = @"";
            if (_defaultAddress.addressReceiver) {
                name = _defaultAddress.addressReceiver;
            }
            if (_defaultAddress.addressPhone) {
                phoneNumber = _defaultAddress.addressPhone;
            }
            if (_defaultAddress.address) {
                address = _defaultAddress.address;
            }
            NSString *receiver = [NSString stringWithFormat:@"收件人：%@",name];
            NSString *totalString = [NSString stringWithFormat:@"%@   %@",receiver,phoneNumber];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
            NSDictionary *receiverAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont boldSystemFontOfSize:15.f],NSFontAttributeName,
                                          nil];
            NSDictionary *phoneAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:14],NSFontAttributeName,
                                       nil];
            [attrString addAttributes:receiverAttr range:NSMakeRange(0, [receiver length])];
            [attrString addAttributes:phoneAttr range:NSMakeRange([receiver length], [attrString length] - [receiver length])];
            cell.textLabel.attributedText = attrString;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"收件地址：%@",address];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _textView.frame = CGRectMake(10, 0, kScreenWidth - 20, 180);
            _placeholderLabel.frame = CGRectMake(15, 7, kScreenWidth - 20, 20.f);
            _tipLabel.frame = CGRectMake(10, 180, kScreenWidth - 20, 20);
            [cell.contentView addSubview:_textView];
            [cell.contentView addSubview:_placeholderLabel];
            [cell.contentView addSubview:_tipLabel];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case 0:
            height = 44;
            break;
        case 1:
            height = 80.f;
            break;
        case 2:
            height = 200.f;
            break;
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            TMSelectedTerminalController *terminalC = [[TMSelectedTerminalController alloc] init];
            [self.navigationController pushViewController:terminalC animated:YES];
        }
            break;
        case 1: {
            SelectedAddressController *addressC = [[SelectedAddressController alloc] init];
            addressC.addressItems = _addressItem;
            addressC.addressID = _defaultAddress.addressID;
            addressC.delegate = self;
            [self.navigationController pushViewController:addressC animated:YES];
        }
            break;
        case 2: {
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - UITextView

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else if ([textView.text length] + [text length] > 200 && ![text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        _placeholderLabel.text = @"售后原因";
    }
    else {
        _placeholderLabel.text = @"";
    }
    NSInteger number = 200 - [textView.text length];
    if (number < 0) {
        number = 0;
    }
    _tipLabel.text = [NSString stringWithFormat:@"最多填写%ld个汉字", number];
}

#pragma mark - SelectedAddressDelegate

- (void)getSelectedAddress:(AddressModel *)addressModel {
    self.defaultAddress = addressModel;
    [_tableView reloadData];
}

#pragma mark - NSNotification

- (void)getSelectedTerminalList:(NSNotification *)notification {
    _selectedTerminalList = [notification.userInfo objectForKey:kTMTermainalList];
    [_tableView reloadData];
}

@end
