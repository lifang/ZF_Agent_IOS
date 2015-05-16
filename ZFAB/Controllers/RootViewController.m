//
//  RootViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RootViewController.h"
#import "NavigationBarAttr.h"
#import "UserArchiveHelper.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fillingUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化完成后查找上次登录的用户
- (void)fillingUser {
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user && user.password && user.agentID && ![user.agentID isEqualToString:@""]) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        delegate.agentID = user.agentID;
        delegate.agentUserID = user.agentUserID;
        delegate.userID = user.userID;
        delegate.cityID = user.cityID;
        delegate.hasProfit = user.hasProfit;
        delegate.userType = user.userType;
        delegate.isFirstLevelAgent = user.isFirstLevel;
        delegate.authDict = user.authDict;
        [self showMainViewController];
    }
    else {
        [self showLoginViewController];
    }
    [user print];
}

#pragma mark - 登录与主界面

- (void)showLoginViewController {
    if (!_loginNav) {
        LoginViewController *loginC = [[LoginViewController alloc] init];
        _loginNav = [[UINavigationController alloc] initWithRootViewController:loginC];
        _loginNav.view.frame = self.view.bounds;
        [self.view addSubview:_loginNav.view];
        [self addChildViewController:_loginNav];
        [NavigationBarAttr setNavigationBarStyle:_loginNav];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:nil
                                                                    action:nil];
        loginC.navigationItem.backBarButtonItem = backItem;
    }
    if (_mainController) {
        [_mainController.view removeFromSuperview];
        [_mainController removeFromParentViewController];
        _mainController = nil;
    }
}

- (void)showMainViewController {
    if (!_mainController) {
        _mainController = [[MainViewController alloc] init];
        _mainController.view.frame = self.view.bounds;
        [self.view addSubview:_mainController.view];
        [self addChildViewController:_mainController];
    }
    if (_loginNav) {
        [_loginNav.view removeFromSuperview];
        [_loginNav removeFromParentViewController];
        _loginNav = nil;
    }
    [self.view bringSubviewToFront:_mainController.view];
}

@end
