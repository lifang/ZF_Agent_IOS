//
//  RootViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RootViewController.h"
#import "NavigationBarAttr.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showLoginViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
