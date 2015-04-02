//
//  AppDelegate.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *agentID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) RootViewController *rootViewController;

+ (AppDelegate *)shareAppDelegate;

+ (RootViewController *)shareRootViewController;

@end

