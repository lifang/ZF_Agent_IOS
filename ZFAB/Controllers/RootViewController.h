//
//  RootViewController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "LoginViewController.h"

@interface RootViewController : UIViewController

@property (nonatomic, strong) UINavigationController *loginNav;

@property (nonatomic, strong) MainViewController *mainController;

- (void)showLoginViewController;

- (void)showMainViewController;

@end
