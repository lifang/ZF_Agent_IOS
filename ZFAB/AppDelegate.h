//
//  AppDelegate.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

typedef enum {
    AuthWholesale = 1,  //批购权限
    AuthProcurement,    //代购权限
    AuthTM_CS,          //终端管理+售后记录
    AuthT_B,            //交易流水+分润
    AuthSubAgent,       //下级代理商管理
    AuthUM,             //用户管理
    AuthEA,             //员工账号
    AuthAR,             //代理商资料
    AuthStock,          //库存
}AuthType; //权限

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *agentUserID;  //代理商对应的用户id
@property (nonatomic, strong) NSString *agentID;      //代理商id
@property (nonatomic, strong) NSString *userID;       //用户id
@property (nonatomic, strong) NSMutableDictionary *authDict;   //权限
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, assign) BOOL hasProfit;         //是否有分润

@property (nonatomic, strong) RootViewController *rootViewController;

+ (AppDelegate *)shareAppDelegate;

+ (RootViewController *)shareRootViewController;

- (void)saveLoginInfo:(NSDictionary *)dict;

- (void)loginOut;

@end

