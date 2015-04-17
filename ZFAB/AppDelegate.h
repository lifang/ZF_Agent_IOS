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

@property (nonatomic, strong) NSString *agentUserID;  //代理商对应的用户id
@property (nonatomic, strong) NSString *agentID;      //代理商id
@property (nonatomic, strong) NSString *userID;       //用户id
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, assign) BOOL hasProfit;         //是否有分润

@property (nonatomic, strong) RootViewController *rootViewController;

+ (AppDelegate *)shareAppDelegate;

+ (RootViewController *)shareRootViewController;

@end

