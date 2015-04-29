//
//  LoginViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "FindPasswordController.h"
#import "RegisterViewController.h"
#import "NetworkInterface.h"
#import "UserArchiveHelper.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameField;

@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *GuideView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initAndLayoutUI];
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        
        [self setGuideUI];
    }
    
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.primaryPoint = CGPointMake(0, self.view.frame.origin.y + topHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [self fillingUser];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat imageSize = 26.f;
    CGFloat leftSpace = 30.f;
    CGFloat rightSpace = 30.f;
    CGFloat textFieldHeight = 44.f;
    
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.image = kImageName(@"login_back.png");
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_backgroundView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    UIImageView *loginView = [[UIImageView alloc] init];
    loginView.image = kImageName(@"login_logo.png");
    loginView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loginView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:80.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:180.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:80.f]];
    NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              kColor(149, 197, 241, 1),NSForegroundColorAttributeName,
                              nil];
    //用户名
    _usernameField = [[UITextField alloc] init];
    _usernameField.translatesAutoresizingMaskIntoConstraints = NO;
    _usernameField.borderStyle = UITextBorderStyleNone;
    _usernameField.background = kImageName(@"login_textback.png");
    _usernameField.delegate = self;
    NSMutableAttributedString *usernameString = [[NSMutableAttributedString alloc] initWithString:@"使用id登录"];
    [usernameString addAttributes:textDict range:NSMakeRange(0, [usernameString length])];
    _usernameField.attributedPlaceholder = usernameString;
    _usernameField.font = [UIFont systemFontOfSize:15.f];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, imageSize, imageSize)];
    nameImageView.image = [UIImage imageNamed:@"login_user.png"];
    [nameView addSubview:nameImageView];
    _usernameField.leftView = nameView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_usernameField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:loginView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:15.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:textFieldHeight]];
    //密码
    _passwordField = [[UITextField alloc] init];
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.background = kImageName(@"login_textback.png");
    _passwordField.delegate = self;
    NSMutableAttributedString *passwordString = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    [passwordString addAttributes:textDict range:NSMakeRange(0, [passwordString length])];
    _passwordField.attributedPlaceholder = passwordString;
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.secureTextEntry = YES;
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, imageSize, imageSize)];
    passwordImageView.image = [UIImage imageNamed:@"login_pwd.png"];
    [passwordView addSubview:passwordImageView];
    _passwordField.leftView = passwordView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_passwordField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:textFieldHeight]];
    //登录
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signInBtn.layer.cornerRadius = 4;
    signInBtn.layer.masksToBounds = YES;
    signInBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [signInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_passwordField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:160.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:40]];
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [forgetBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:32]];
    //注册
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [signUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [signUpBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-35.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:32.f]];
}


-(void)setGuideUI
{
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

      float wide=[[UIScreen mainScreen] bounds].size.width;
      float high=[[UIScreen mainScreen] bounds].size.height;
   

    _GuideView = [[UIView alloc]init];
    _GuideView.frame = CGRectMake(0, 0, wide, high);
    _GuideView.backgroundColor = [UIColor whiteColor];
   // [_backgroundView addSubview:_GuideView];
    [self.view addSubview:_GuideView];
    
    NSArray *arr=[NSArray arrayWithObjects:@"iphone1",@"iphone2",@"iphone3",@"iphone4", nil];
    //数组内存放的是我要显示的假引导页面图片
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize=CGSizeMake(wide*arr.count, high);
    scrollView.pagingEnabled=YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [_GuideView addSubview:scrollView];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*wide, 0, wide, high)];
        img.image=[UIImage imageNamed:arr[i]];
        [scrollView addSubview:img];
    }
    
    UIButton *applyBtn=[[UIButton alloc] init];
    applyBtn.frame=CGRectMake(24+wide*3, high-60-50, (wide-48-50)/2.0, 50);
    applyBtn.layer.masksToBounds=YES;
    applyBtn.layer.borderWidth=1.0;
    applyBtn.layer.cornerRadius=8.0;
   // applyBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
     applyBtn.layer.borderColor=[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1].CGColor;
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn setTitle:@"申请成为代理商" forState:UIControlStateNormal];
    //[applyBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    [applyBtn setBackgroundColor:[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1]];
    [applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:applyBtn];
    
    UIButton *useBtn=[[UIButton alloc] init];
    useBtn.frame=CGRectMake(24+wide*3+(wide-48-50)/2.0+50, high-60-50, (wide-48-50)/2.0, 50);
    useBtn.layer.masksToBounds=YES;
    useBtn.layer.borderWidth=1.0;
    useBtn.layer.cornerRadius=8.0;
    useBtn.layer.borderColor=[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1].CGColor;
    [useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useBtn setTitle:@"马上使用" forState:UIControlStateNormal];
   // [useBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    [useBtn setBackgroundColor:[UIColor colorWithRed:0 green:0.435 blue:0.835 alpha:1]];
    [useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:useBtn];
    
    
}

-(void)useBtnClick:(id)sender
{
    [_GuideView removeFromSuperview];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
}

-(void)applyBtnClick:(id)sender
{
    [_GuideView removeFromSuperview];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self gotoregister];
    
}

-(void)gotoregister
{
    RegisterViewController *registerV = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerV animated:YES];
}


#pragma mark - Request

- (void)userLogin {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在登录...";
    [NetworkInterface loginWithUsername:_usernameField.text password:_passwordField.text isAlreadyEncrypt:NO finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    NSLog(@"%@",object);
                    [self parseLoginDataWithDictionary:object];
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

#pragma mark - Data

- (void)parseLoginDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    [self saveLoginUser];
    [[AppDelegate shareAppDelegate] saveLoginInfo:infoDict];
    [[AppDelegate shareRootViewController] showMainViewController];
}

#pragma mark - Action

- (IBAction)signIn:(id)sender {
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""] || !_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"用户名或密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self userLogin];
//    [[AppDelegate shareRootViewController] showMainViewController];
}

- (IBAction)forgetPassword:(id)sender {
    FindPasswordController *findC = [[FindPasswordController alloc] init];
    [self.navigationController pushViewController:findC animated:YES];
}

- (IBAction)signUp:(id)sender {
    RegisterViewController *registerC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerC animated:YES];
}

#pragma mark - 数据处理

//初始化完成后查找上次登录的用户
- (void)fillingUser {
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user) {
        _usernameField.text = user.username;
        _passwordField.text = user.password;
    }
}

//保存登录用户
- (void)saveLoginUser {
    LoginUserModel *user = [[LoginUserModel alloc] init];
    user.username = _usernameField.text;
    user.password = _passwordField.text;
    [UserArchiveHelper savePasswordForUser:user];
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
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y - offsetY, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        self.offset = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.primaryPoint.x, self.primaryPoint.y, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}


@end
