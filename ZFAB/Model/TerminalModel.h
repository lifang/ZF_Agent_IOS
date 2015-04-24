//
//  TerminalModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*终端对象*/
#import <Foundation/Foundation.h>

typedef enum {
    TerminalStatusNone = 0,
    TerminalStatusOpened,       //已开通
    TerminalStatusPartOpened,   //部分开通
    TerminalStatusUnOpened,     //未开通
    TerminalStatusCanceled,     //已注销
    TerminalStatusStopped,      //已停用
}TerminalStatus;

@interface TerminalModel : NSObject

@property (nonatomic, strong) NSString *terminalID;

@property (nonatomic, strong) NSString *terminalNumber;

@property (nonatomic, assign) int status;

@property (nonatomic, assign) BOOL hasVideoAuth;   //是否需要视频认证

/*
 若有值，订单状态为已开通，有视频认证和找回POS密码操作,否则是自助开通
 若有值，订单状态为未开通，无同步操作
 */
@property (nonatomic, strong) NSString *appID;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getStatusString;

@end
