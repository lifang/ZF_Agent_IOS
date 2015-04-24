//
//  AppDelegate.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    return [UIApplication sharedApplication].delegate;
}

+ (RootViewController *)shareRootViewController {
    return [[self shareAppDelegate] rootViewController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    _rootViewController = [[RootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window makeKeyAndVisible];
    [self setStatisticData];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"%@",url);
    if ([url.host isEqualToString:@"safepay"]) {
        NSLog(@"!!!");
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            for (NSString *key in resultDic) {
                NSLog(@"%@->%@",key,[resultDic objectForKey:key]);
            }
        }];
    }
    return YES;
}

#pragma mark - Data

- (void)setStatisticData {
    _authDict = [[NSMutableDictionary alloc] init];
    for (int i = 1; i < 11; i++) {
        [_authDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:i]];
    }
    _userID = @"1";
    _agentUserID = @"1";
    _agentID = @"1";
    _token = @"123";
    _cityID = @"1";
    _hasProfit = YES;
}

- (void)saveLoginInfo:(NSDictionary *)dict {
    self.agentID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agentId"]];
    self.userID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    self.agentUserID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agentUserId"]];
    self.cityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cityId"]];
    if ([[dict objectForKey:@"is_have_profit"] intValue] == 2) {
        self.hasProfit = YES;
    }
    _userType = [[dict objectForKey:@"types"] intValue];
    if (_userType == UserEmployee) {
        //员工根据权限表
        id authList = [dict objectForKey:@"machtigingen"];
        if ([authList isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [authList count]; i++) {
                id object = [authList objectAtIndex:i];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    int authIndex = [[object objectForKey:@"role_id"] intValue];
                    [_authDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:authIndex]];
                }
            }
        }
    }
    else {
        for (int i = 1; i < 11; i++) {
            [_authDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:i]];
        }
        if ([[dict objectForKey:@"parent_id"] intValue] == 0) {
            //一级代理商 所有权限
            _isFirstLevelAgent = YES;
        }
        else {
            //下级代理商 批购 代购 订单无权限
            [_authDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:AuthWholesale]];
            [_authDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:AuthProcurement]];
            [_authDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:AuthOrder]];
        }
    }
}

- (void)loginOut {
    _agentID = nil;
    _userID = nil;
    _agentUserID = nil;
    _cityID = nil;
    _userType = 0;
    _hasProfit = NO;
    _isFirstLevelAgent = NO;
    [_authDict removeAllObjects];
    for (int i = 1; i < 11; i++) {
        [_authDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:i]];
    }
}

@end
