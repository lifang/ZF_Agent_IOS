//
//  AppDelegate.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UserArchiveHelper.h"
#import "NetworkInterface.h"
#import "BPush.h"
#import "MessageDetailController.h"
#import "NavigationBarAttr.h"
#import "MobClick.h"

@interface AppDelegate ()<BPushDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (RootViewController *)shareRootViewController {
    return [[self shareAppDelegate] rootViewController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setStatisticData];
    _rootViewController = [[RootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window makeKeyAndVisible];
    // iOS8 下需要使⽤用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound
        | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    // 在 App 启动时注册百度云推送服务,需要提供 Apikey
    //*****************
    //掌富证书请替换apikey为t2EIwYVCal4Tl2zNloV9ld97
    [BPush registerChannel:launchOptions apiKey:@"e3hwiQojGDW6i0sFivClE4lq" pushMode:BPushModeDevelopment isDebug:NO];
    // 设置 BPush 的回调
    [BPush setDelegate:self];
    // App 是⽤用户点击推送消息启动
    NSLog(@"!@#!#!%@",launchOptions);
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"!!!!%@",userInfo);      
        [BPush handleNotification:userInfo];
        [self showNotificationViewWithInfo:userInfo pushLaunch:YES];
    }
    [self umengTrack];
    return YES;
}

//友盟
- (void)umengTrack {
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick updateOnlineConfig];  //在线参数配置
}

//百度推送*******************************************
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [BPush registerDeviceToken:deviceToken];
    //    [BPush bindChannel];
}

// 当 DeviceToken 获取失败时,系统会回调此⽅方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:( NSError *)error {
    NSLog(@"DeviceToken 获取失败,原因:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // App 收到推送通知
    [BPush handleNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        //前台
        NSLog(@"active");
        self.messageCount ++;
        NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:self.messageCount],s_messageTab,
                                     nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabBadgeNotification object:nil userInfo:messageDict];
    }
    else {
        //后台
        NSLog(@"unactive");
        [self showNotificationViewWithInfo:userInfo pushLaunch:NO];
    }
    [application setApplicationIconBadgeNumber:0];
    
}

//收到通知弹出到通知界面
- (void)showNotificationViewWithInfo:(NSDictionary *)userInfo pushLaunch:(BOOL)pushLaunch {
    NSLog(@"%@",userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSString *messageID = nil;
    if ([userInfo objectForKey:@"msgId"] && ![[userInfo objectForKey:@"msgId"] isKindOfClass:[NSNull class]]) {
        messageID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"msgId"]];
    }
    if (self.agentUserID) {
        MessageDetailController *detailC = [[MessageDetailController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailC];
        detailC.messageID = messageID;
        detailC.isFromPush = YES;
        [NavigationBarAttr setNavigationBarStyle:nav];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }
    else {
        [self.rootViewController showLoginViewController];
    }
}

- (void)onMethod:(NSString*)method response:(NSDictionary *)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethodBind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSLog(@"tttt = %@,%@,%@,%d",appid ,userid, channelid,returnCode);
        if (returnCode == 0) {
            [self uploadPushChannel:channelid];
        }
        
    } else if ([BPushRequestMethodUnbind isEqualToString:method]) {
        
    }
    
}

//绑定成功向服务端提交信息
- (void)uploadPushChannel:(NSString *)channel {
    NSString *appInfo = [NSString stringWithFormat:@"%d%@",kAppChannel,channel];
    [NetworkInterface uploadPushInfoWithUserID:self.agentUserID channelInfo:appInfo finished:^(BOOL success, NSData *response) {
        NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }];
}

//***************************************************

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

- (void)saveLoginInfo:(NSDictionary *)dict username:(NSString *)username password:(NSString *)password {
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
    [self saveLoginUserWithUsername:username password:password];
}

//保存登录用户
- (void)saveLoginUserWithUsername:(NSString *)username password:(NSString *)password {
    LoginUserModel *user = [[LoginUserModel alloc] init];
    user.username = username;
    user.password = password;
    user.agentID = self.agentID;
    user.agentUserID = self.agentUserID;
    user.userID = self.userID;
    user.cityID = self.cityID;
    user.hasProfit = self.hasProfit;
    user.userType = self.userType;
    user.isFirstLevel = self.isFirstLevelAgent;
    user.authDict = self.authDict;
    [UserArchiveHelper savePasswordForUser:user];
}

- (void)loginOut {
    [BPush unbindChannel];
    _agentID = @"";
    _userID = @"";
    _agentUserID = @"";
    _cityID = @"";
    _userType = 2;
    _hasProfit = NO;
    _isFirstLevelAgent = NO;
    [_authDict removeAllObjects];
    for (int i = 1; i < 11; i++) {
        [_authDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:i]];
    }
    [self deleteUserPassword];
}

- (void)deleteUserPassword {
    LoginUserModel *user = [UserArchiveHelper getLastestUser];
    if (user) {
        user.password = nil;
        user.agentID = @"";
        user.agentUserID = @"";
        user.userID = @"";
        user.cityID = @"";
        user.userType = -1;
        user.hasProfit = NO;
        user.isFirstLevel = NO;
        [user.authDict removeAllObjects];
        [UserArchiveHelper savePasswordForUser:user];
    }
}

@end
