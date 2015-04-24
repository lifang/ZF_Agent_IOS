//
//  ModifyPasswordController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ModifyPasswordController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "AppDelegate.h"

@interface ModifyPasswordController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *oldPasswordField;

@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UITextField *confirmField;

@end

@implementation ModifyPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18 * kScaling)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    save.layer.cornerRadius = 4;
    save.layer.masksToBounds = YES;
    save.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(savePassword:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:save];
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
    //输入框
    CGFloat offsetX = 20.0f;
    //旧密码
    _oldPasswordField = [[UITextField alloc] init];
    _oldPasswordField.borderStyle = UITextBorderStyleNone;
    _oldPasswordField.backgroundColor = [UIColor clearColor];
    _oldPasswordField.delegate = self;
    _oldPasswordField.placeholder = @"原密码";
    _oldPasswordField.font = [UIFont systemFontOfSize:15.f];
    _oldPasswordField.secureTextEntry = YES;
    UIView *oldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
    _oldPasswordField.leftView = oldView;
    _oldPasswordField.leftViewMode = UITextFieldViewModeAlways;
    _oldPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //新密码
    _passwordField = [[UITextField alloc] init];
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.backgroundColor = [UIColor clearColor];
    _passwordField.delegate = self;
    _passwordField.placeholder = @"新密码";
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.secureTextEntry = YES;
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
    _passwordField.leftView = passwordView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //confirm
    _confirmField = [[UITextField alloc] init];
    _confirmField.borderStyle = UITextBorderStyleNone;
    _confirmField.backgroundColor = [UIColor clearColor];
    _confirmField.delegate = self;
    _confirmField.placeholder = @"确认密码";
    _confirmField.font = [UIFont systemFontOfSize:15.f];
    _confirmField.secureTextEntry = YES;
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offsetX, offsetX)];
    _confirmField.leftView = confirmView;
    _confirmField.leftViewMode = UITextFieldViewModeAlways;
    _confirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [_oldPasswordField becomeFirstResponder];
}

#pragma mark - Request

- (void)modifyPassword {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyPasswordWithAgentUserID:delegate.agentUserID token:delegate.token primaryPassword:_oldPasswordField.text newPassword:_passwordField.text finished:^(BOOL success, NSData *response) {
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"密码修改成功"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
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

- (IBAction)savePassword:(id)sender {
    if (!_oldPasswordField.text || [_oldPasswordField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入原密码";
        return;
    }
    if (!_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入新密码";
        return;
    }
    if (!_confirmField.text || [_confirmField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请再次输入新密码";
        return;
    }
    if (![_confirmField.text isEqualToString:_passwordField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"两次输入的密码不一致";
        return;
    }
    [_oldPasswordField becomeFirstResponder];
    [_oldPasswordField resignFirstResponder];
    [self modifyPassword];
}

#pragma mark - TableView

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
            //原密码
            _oldPasswordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_oldPasswordField];
        }
            break;
        case 1: {
            //新密码
            _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_passwordField];
        }
            break;
        case 2: {
            //确认密码
            _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_confirmField];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 2.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.f;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[[AppDelegate shareAppDelegate] rootViewController] showLoginViewController];
}

@end
