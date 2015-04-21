//
//  FindPasswordController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "FindPasswordController.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"
#import "MobileFindController.h"

@interface FindPasswordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) SendType sendType;

@end

@implementation FindPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    _sendType = SendTypeMobile;
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

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
    
    _inputField = [[UITextField alloc] init];
    _inputField.delegate = self;
    _inputField.placeholder = @"输入手机/邮箱";
    _inputField.font = [UIFont systemFontOfSize:15.f];
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _sendButton.layer.cornerRadius = 4.f;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton setBackgroundImage:kImageName(@"light_red.png") forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)setSendType:(SendType)sendType {
    _sendType = sendType;
    if (_sendType == SendTypeMobile) {
        [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    else if (_sendType == SendTypeEmail) {
        [_sendButton setTitle:@"发送重置密码邮件" forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (IBAction)sendInfo:(id)sender {
    [_inputField resignFirstResponder];
    if (_sendType == SendTypeMobile) {
        if ([RegularFormat isMobileNumber:_inputField.text]) {
            [self sendMobileValidate];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请输入正确的手机号";
        }
    }
    else if (_sendType == SendTypeEmail) {
        if ([RegularFormat isCorrectEmail:_inputField.text]) {
            [self sendEmailValidate];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请输入正确的邮箱号";
        }
    }
    
}

#pragma mark - Request

//发送验证码
- (void)sendMobileValidate {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface sendValidateWithMobileNumber:_inputField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    NSString *validate = [object objectForKey:@"result"];
                    MobileFindController *mobileC = [[MobileFindController alloc] init];
                    mobileC.validate = validate;
                    mobileC.phoneNumber = _inputField.text;
                    [self.navigationController pushViewController:mobileC animated:YES];
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

//发送邮箱验证码
- (void)sendEmailValidate {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface sendEmailValidateWithEmail:_inputField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
//                    EmailFindController *emailC = [[EmailFindController alloc] init];
//                    [self.navigationController pushViewController:emailC animated:YES];
                    NSString *info = [NSString stringWithFormat:@"重置密码邮件已发送至%@，请注意查收",_inputField.text];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:info
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
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


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGFloat buttonWidth = 100;
    CGFloat space = 10.f;
    _inputField.frame = CGRectMake(space, (cell.frame.size.height - 30) / 2, kScreenWidth - buttonWidth - 3 * space, 30);
    _sendButton.frame = CGRectMake(kScreenWidth - 110, (cell.frame.size.height - 30) / 2, 100, 30);
    [cell.contentView addSubview:_inputField];
    [cell.contentView addSubview:_sendButton];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_inputField becomeFirstResponder];
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        //删除
        if ([textField.text length] > 0 && [[textField.text substringToIndex:[textField.text length] - 1] rangeOfString:@"@"].length != 0) {
            self.sendType = SendTypeEmail;
        }
        else {
            self.sendType = SendTypeMobile;
        }
    }
    else if ([textField.text rangeOfString:@"@"].length != 0 || [string rangeOfString:@"@"].length != 0) {
        self.sendType = SendTypeEmail;
    }
    else {
        self.sendType = SendTypeMobile;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.sendType = SendTypeMobile;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end


