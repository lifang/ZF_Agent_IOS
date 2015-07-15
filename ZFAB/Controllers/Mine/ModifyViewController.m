//
//  ModifyViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/5/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ModifyViewController.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"
#import "AppDelegate.h"
#import "PersonInfoController.h"

@interface ModifyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *primaryField;

@property (nonatomic, strong) UITextField *validateField;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSString *validate;

@property (nonatomic, strong) NSString *primaryData;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    NSString *tipInfo = nil;
    NSString *btnTitle = @"";
    SEL action = nil;
    if (_editType == EditViewModify) {
        btnTitle = @"下一步";
        if (_type == ModifyUserMobile) {
            tipInfo = @"修改手机号将向您的原手机发送验证码";
            action = @selector(goNextMobile:);
        }
        else {
            tipInfo = @"修改邮箱将向您的原邮箱发送验证码";
            action = @selector(goNextEmail:);
        }
    }
    else {
        btnTitle = @"提交";
        if (_type == ModifyUserMobile) {
            tipInfo = @"将向您的新手机发送验证码";
            action = @selector(submitMobile:);
        }
        else {
            tipInfo = @"将向您的新邮箱发送验证码";
            action = @selector(submitEmail:);
        }
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.f)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, 20)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:14.f];
    infoLabel.text = tipInfo;
    [headerView addSubview:infoLabel];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [submitBtn setTitle:btnTitle forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
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
    _primaryField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (_editType == EditViewModify) {
        if (_type == ModifyUserMobile) {
            _primaryField.text = _userInfo.mobileNumber;
        }
        else {
            _primaryField.text = _userInfo.email;
        }
        _primaryField.userInteractionEnabled = NO;
    }
    
    _validateField = [[UITextField alloc] init];
    _validateField.delegate = self;
    _validateField.placeholder = @"输入验证码";
    _validateField.font = [UIFont systemFontOfSize:15.f];
    _validateField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _sendButton.layer.cornerRadius = 4.f;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton setBackgroundImage:kImageName(@"light_red.png") forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

//倒计时
- (void)countDownStart {
    __block int timeout = kCoolDownTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _sendButton.userInteractionEnabled = YES;
                [_sendButton setBackgroundImage:kImageName(@"light_red.png") forState:UIControlStateNormal];
                [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendButton.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_sendButton setBackgroundImage:nil forState:UIControlStateNormal];
                [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_sendButton setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Data

- (PersonModel *)newUserInfo {
    PersonModel *model = [[PersonModel alloc] init];
    switch (_type) {
        case ModifyUserMobile:
            model.mobileNumber = _primaryField.text;
            break;
        case ModifyUserEmail:
            model.email = _primaryField.text;
            break;
        default:
            break;
    }
    return model;
}

- (void)updateUserInfoWithModel:(PersonModel *)model {
    switch (_type) {
        case ModifyUserMobile:
            _userInfo.mobileNumber = model.mobileNumber;
            break;
        case ModifyUserEmail:
            _userInfo.email = model.email;
            break;
        default:
            break;
    }
}

#pragma mark - Request

- (void)getMobileValidate {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getPersonModifyMobileValidateWithAgentUserID:delegate.agentUserID token:delegate.token phoneNumber:_primaryField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    id infoDict = [object objectForKey:@"result"];
                    if ([infoDict isKindOfClass:[NSDictionary class]]) {
                        if ([[infoDict objectForKey:@"dentcode"] isKindOfClass:[NSString class]]) {
                            _validate = [infoDict objectForKey:@"dentcode"];
                        }
                    }
                    _primaryData = _primaryField.text;
                    hud.labelText = @"验证码发送成功";
                    [self countDownStart];
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

- (void)getEmailValidate {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getPersonModifyEmailValidateWithAgentUserID:delegate.agentUserID agentName:_userInfo.personName token:delegate.token email:_primaryField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    id infoDict = [object objectForKey:@"result"];
                    if ([infoDict isKindOfClass:[NSDictionary class]]) {
                        if ([[infoDict objectForKey:@"dentcode"] isKindOfClass:[NSString class]]) {
                            _validate = [infoDict objectForKey:@"dentcode"];
                        }
                    }
                    _primaryData = _primaryField.text;
                    hud.labelText = @"验证邮件已发送至邮箱，请查收";
                    [self countDownStart];
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
    [NetworkInterface modifyPersonMobileWithAgentUserID:delegate.agentUserID token:delegate.token newPhoneNumber:_primaryField.text validate:_validateField.text finished:^(BOOL success, NSData *response) {
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
                    _userInfo.mobileNumber = _primaryField.text;
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshPersonInfoNotification object:nil];
                    UIViewController *controller = nil;
                    for (UIViewController *cc in self.navigationController.childViewControllers) {
                        if ([cc isKindOfClass:[PersonInfoController class]]) {
                            controller = cc;
                            break;
                        }
                    }
                    if (controller) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
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

- (void)modifyPersonEmail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface modifyPersonEmailWithAgentUserID:delegate.agentUserID token:delegate.token newEmail:_primaryField.text validate:_validateField.text finished:^(BOOL success, NSData *response) {
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
                    _userInfo.email = _primaryField.text;
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshPersonInfoNotification object:nil];
                    UIViewController *controller = nil;
                    for (UIViewController *cc in self.navigationController.childViewControllers) {
                        if ([cc isKindOfClass:[PersonInfoController class]]) {
                            controller = cc;
                            break;
                        }
                    }
                    if (controller) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
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

- (IBAction)goNextMobile:(id)sender {
    [_validateField becomeFirstResponder];
    [_validateField resignFirstResponder];
    if (!_validateField.text || [_validateField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入验证码";
        return;
    }
    if (!_validate ||[_validate isEqualToString:@""] || ![_validate isEqualToString:_validateField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"验证码不正确";
        return;
    }
    ModifyViewController *editC = [[ModifyViewController alloc] init];
    editC.editType = EditViewNew;
    editC.type = ModifyUserMobile;
    editC.userInfo = _userInfo;
    [self.navigationController pushViewController:editC animated:YES];
}

- (IBAction)goNextEmail:(id)sender {
    [_validateField becomeFirstResponder];
    [_validateField resignFirstResponder];
    if (!_validateField.text || [_validateField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入验证码";
        return;
    }
    if (!_validate ||[_validate isEqualToString:@""] || ![_validate isEqualToString:_validateField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"验证码不正确";
        return;
    }
    ModifyViewController *editC = [[ModifyViewController alloc] init];
    editC.editType = EditViewNew;
    editC.type = ModifyUserEmail;
    editC.userInfo = _userInfo;
    [self.navigationController pushViewController:editC animated:YES];
}

- (IBAction)submitMobile:(id)sender {
    [_validateField becomeFirstResponder];
    [_validateField resignFirstResponder];
    if (![RegularFormat isMobileNumber:_primaryField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的手机号";
        return;
    }
    if (!_validateField.text || [_validateField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入验证码";
    }
    if (!_validate ||[_validate isEqualToString:@""] || ![_validate isEqualToString:_validateField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"验证码不正确";
        return;
    }
    if (!_primaryData || [_primaryData isEqualToString:@""] || ![_primaryData isEqualToString:_primaryField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"手机号和验证码不对应";
        return;
    }
    [self modifyPersonMobile];
}

- (IBAction)submitEmail:(id)sender {
    [_validateField becomeFirstResponder];
    [_validateField resignFirstResponder];
    if (_type == ModifyUserEmail && ![RegularFormat isCorrectEmail:_primaryField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的邮箱";
        return;
    }
    if (!_validateField.text || [_validateField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入验证码";
        return;
    }
    if (!_validate ||[_validate isEqualToString:@""] || ![_validate isEqualToString:_validateField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"验证码不正确";
        return;
    }
    if (!_primaryData || [_primaryData isEqualToString:@""] || ![_primaryData isEqualToString:_primaryField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"邮箱和验证码不对应";
        return;
    }
    [self modifyPersonEmail];
}

- (IBAction)sendInfo:(id)sender {
    [_validateField becomeFirstResponder];
    [_validateField resignFirstResponder];
    if (_type == ModifyUserMobile && ![RegularFormat isMobileNumber:_primaryField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的手机号";
        return;
    }
    if (_type == ModifyUserEmail && ![RegularFormat isCorrectEmail:_primaryField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的邮箱";
        return;
    }
    if (_type == ModifyUserMobile) {
        [self getMobileValidate];
    }
    else {
        [self getEmailValidate];
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height + kOffsetKeyboard - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.primaryPoint = self.tableView.contentOffset;
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
