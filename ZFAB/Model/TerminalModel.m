//
//  TerminalModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalModel.h"

@implementation TerminalModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _terminalID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        _status = [[dict objectForKey:@"status"] intValue];
        if ([dict objectForKey:@"serial_num"]) {
            _terminalNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        }
        if ([dict objectForKey:@"appid"]) {
            _appID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"appid"]];
        }
        int videoAuth = [[dict objectForKey:@"hasVideoVerify"] intValue];
        if (videoAuth == 1) {
            _hasVideoAuth = YES;
        }
        else {
            _hasVideoAuth = NO;
        }
        if ([dict objectForKey:@"openingProtocol"]) {
            _protocol = [NSString stringWithFormat:@"%@",[dict objectForKey:@"openingProtocol"]];
        }
        else {
            _protocol = @"无";
        }
        _type = [[dict objectForKey:@"type"] intValue];
        _openStatus = [[dict objectForKey:@"appstatus"] intValue];
    }
    return self;
}

- (NSString *)getStatusString {
    NSString *statusString = nil;
    switch (_status) {
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}

@end
