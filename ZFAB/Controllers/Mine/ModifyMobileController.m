//
//  ModifyMobileController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ModifyMobileController.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"
#import "PersonInfoController.h"

@interface ModifyMobileController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *primaryField;  //旧手机号

@property (nonatomic, strong) UITextField *validateField;

@property (nonatomic, strong) UITextField *modifyField;   //新手机号

@property (nonatomic, strong) UIButton *sendButton;


@end

@implementation ModifyMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改手机";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.f)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, 20)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:14.f];
    infoLabel.text = @"修改手机号将向您的原手机发送验证码";
    [headerView addSubview:infoLabel];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(modifyMobile:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
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
    [self initSubViews];
}

- (void)initSubViews {
    _primaryField = [[UITextField alloc] init];
    _primaryField.delegate = self;
    _primaryField.placeholder = @"";
    _primaryField.font = [UIFont systemFontOfSize:15.f];
    _primaryField.enabled = NO;
    _primaryField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _primaryField.text = _personInfo.mobileNumber;
    
    _validateField = [[UITextField alloc] init];
    _validateField.delegate = self;
    _validateField.placeholder = @"输入验证码";
    _validateField.font = [UIFont systemFontOfSize:15.f];
    _validateField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _modifyField = [[UITextField alloc] init];
    _modifyField.delegate = self;
    _modifyField.placeholder = @"新手机号";
    _modifyField.font = [UIFont systemFontOfSize:15.f];
    _modifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _sendButton.layer.cornerRadius = 4.f;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton setBackgroundImage:kImageName(@"light_red.png") forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

#pragma mark - Request

- (void)getMobileValidate {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getPersonModifyMobileValidateWithAgentUserID:delegate.agentUserID token:delegate.token phoneNumber:_personInfo.mobileNumber finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"验证码发送成功";
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

- (void)modifyPersonMobile {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface modifyPersonMobileWithAgentUserID:delegate.agentUserID token:delegate.token newPhoneNumber:_modifyField.text validate:_validateField.text finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"修改成功";
                    _personInfo.mobileNumber = _modifyField.text;
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshPersonInfoNotification object:nil];
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

#pragma mark - Action

- (IBAction)modifyMobile:(id)sender {
    if (!_validateField.text || [_validateField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入验证码";
        return;
    }
    if (!_modifyField.text || [_modifyField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入新手机号";
        return;
    }
    if (![RegularFormat isMobileNumber:_modifyField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的手机号";
        return;
    }
    [self modifyPersonMobile];
}

- (IBAction)sendInfo:(id)sender {
    if (!_personInfo.mobileNumber || [_personInfo.mobileNumber isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"原手机号码为空，无法发送验证码";
        return;
    }
    [self getMobileValidate];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            CGFloat buttonWidth = 100;
            CGFloat space = 10.f;
            _primaryField.frame = CGRectMake(20, (cell.frame.size.height - 30) / 2, kScreenWidth - buttonWidth - 2 * space - 20, 30);
            _sendButton.frame = CGRectMake(kScreenWidth - buttonWidth - 10, (cell.frame.size.height - 30) / 2, buttonWidth, 30);
            [cell.contentView addSubview:_primaryField];
            [cell.contentView addSubview:_sendButton];
        }
            break;
        case 1: {
            _validateField.frame = CGRectMake(20, (cell.frame.size.height - 30) / 2, kScreenWidth - 40, 30);
            [cell.contentView addSubview:_validateField];
        }
            break;
        case 2: {
            _modifyField.frame = CGRectMake(20, (cell.frame.size.height - 30) / 2, kScreenWidth - 40, 30);
            [cell.contentView addSubview:_modifyField];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.001f;
    switch (section) {
        case 0:
            height = 30.f;
            break;
        case 1:
            height = 15.f;
            break;
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
