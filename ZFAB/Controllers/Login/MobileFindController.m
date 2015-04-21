//
//  MobileFindController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/20.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MobileFindController.h"
#import "NetworkInterface.h"

@interface MobileFindController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *usernameField;

@property (nonatomic, strong) UITextField *validateField;

@property (nonatomic, strong) UIButton *countDownButton;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmField;

@property (nonatomic, assign) BOOL isChecked;

@end

@implementation MobileFindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    [self initAndLayoutUI];
    [self countDownStart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initSubViews];
    
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
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    checkButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    checkButton.layer.cornerRadius = 4.f;
    checkButton.layer.masksToBounds = YES;
    [checkButton setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkValidate:) forControlEvents:UIControlEventTouchUpInside];
    [checkButton setTitle:@"核对验证码" forState:UIControlStateNormal];
    [footerView addSubview:checkButton];
    _tableView.tableFooterView = footerView;
}

- (void)updateFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    submitButton.layer.cornerRadius = 4.f;
    submitButton.layer.masksToBounds = YES;
    [submitButton setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [footerView addSubview:submitButton];
    _tableView.tableFooterView = footerView;
}

- (void)initSubViews {
    _usernameField = [[UITextField alloc] init];
    _usernameField.delegate = self;
    _usernameField.placeholder = @"输入手机";
    _usernameField.text = _phoneNumber;
    _usernameField.font = [UIFont systemFontOfSize:15.f];
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    _usernameField.leftView = userView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.userInteractionEnabled = NO;
    
    _countDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _countDownButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _countDownButton.layer.cornerRadius = 4.f;
    _countDownButton.layer.masksToBounds = YES;
    [_countDownButton addTarget:self action:@selector(sendValidate:) forControlEvents:UIControlEventTouchUpInside];
    
    _validateField = [[UITextField alloc] init];
    _validateField.delegate = self;
    _validateField.placeholder = @"请输入验证码";
    _validateField.font = [UIFont systemFontOfSize:15.f];
    _validateField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *validateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    _validateField.leftView = validateView;
    _validateField.leftViewMode = UITextFieldViewModeAlways;
    
    _checkImageView = [[UIImageView alloc] init];
    
    CGFloat imageSize = 20.0f; //输入框图片大小
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.delegate = self;
    _passwordField.placeholder = @"输入密码";
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *pwsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, imageSize, imageSize)];
    pwsImageView.image = kImageName(@"myinfo7.png");
    [pwdView addSubview:pwsImageView];
    _passwordField.leftView = pwdView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.secureTextEntry = YES;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _confirmField = [[UITextField alloc] init];
    _confirmField.delegate = self;
    _confirmField.placeholder = @"确认密码";
    _confirmField.font = [UIFont systemFontOfSize:15.f];
    _confirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmField.secureTextEntry = YES;
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *confirmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, imageSize, imageSize)];
    confirmImageView.image = kImageName(@"myinfo7.png");
    [confirmView addSubview:confirmImageView];
    _confirmField.leftView = confirmView;
    _confirmField.leftViewMode = UITextFieldViewModeAlways;
    _confirmField.secureTextEntry = YES;
    _confirmField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    if (_isChecked) {
        _validateField.userInteractionEnabled = NO;
        _checkImageView.image = kImageName(@"check_right.png");
        [self updateFooterView];
        [_tableView reloadData];
    }
    else {
        _validateField.userInteractionEnabled = YES;
        _checkImageView.hidden = YES;
        _validateField.text = @"";
        _passwordField.text = @"";
        _confirmField.text = @"";
        [self setHeaderAndFooterView];
        [_tableView reloadData];
    }
}

#pragma mark - Action

- (IBAction)sendValidate:(id)sender {
    [self sendMobileValidate];
}

- (IBAction)checkValidate:(id)sender {
    NSLog(@"%@",_validate);
    _checkImageView.hidden = NO;
    if ([_validateField.text isEqualToString:_validate]) {
        self.isChecked = YES;
    }
    else {
        _checkImageView.image = kImageName(@"check_wrong.png");
    }
}

- (IBAction)submitInfo:(id)sender {
    if (![_validateField.text isEqualToString:_validate]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不正确!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([_passwordField.text length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"密码不能少于6位!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_passwordField.text isEqualToString:_confirmField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"两次密码不一致!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self findPasswordWithMobile];
}

#pragma mark - Data

//发送验证码
- (void)sendMobileValidate {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface sendValidateWithMobileNumber:_usernameField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    _validate = [object objectForKey:@"result"];
                    [self resetStatus];
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

- (void)findPasswordWithMobile {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在提交...";
    [NetworkInterface findPasswordWithUsername:_usernameField.text password:_passwordField.text validateCode:_validate finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                [hud hide:YES];
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"success = %@",[object objectForKey:@"message"]);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"修改成功"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

- (void)resetStatus {
    self.isChecked = NO;
    [self countDownStart];
}

//倒计时
- (void)countDownStart {
    __block int timeout = 10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _countDownButton.userInteractionEnabled = YES;
                [_countDownButton setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
                [_countDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_countDownButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _countDownButton.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_countDownButton setBackgroundImage:nil forState:UIControlStateNormal];
                [_countDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_countDownButton setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Action



#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isChecked) {
        return 3;
    }
    else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 1;
            break;
        case 2:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    //username
                    CGFloat btnWidth = 120;
                    _usernameField.frame = CGRectMake(0, 0, kScreenWidth - btnWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_usernameField];
                    _countDownButton.frame = CGRectMake(kScreenWidth - btnWidth, (cell.contentView.frame.size.height - 30) / 2, btnWidth - 10, 30);
                    [cell.contentView addSubview:_countDownButton];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    //Validate Code
                    CGFloat imageSize = 25.f;
                    _validateField.frame = CGRectMake(0, 0, kScreenWidth - imageSize  - 40, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_validateField];
                    _checkImageView.frame = CGRectMake(_validateField.bounds.size.width + 10, (cell.contentView.bounds.size.height - imageSize ) / 2, imageSize, imageSize);
                    [cell.contentView addSubview:_checkImageView];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    //new password
                    _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_passwordField];
                }
                    break;
                case 1: {
                    //confirm password
                    _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_confirmField];
                }
                    break;
                default:
                    break;
            }
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
    if (section == 1 && _isChecked) {
        return 40;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
