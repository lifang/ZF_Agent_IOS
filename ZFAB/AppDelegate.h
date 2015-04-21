//
//  AppDelegate.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

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

