//
//  StockTerminalModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StockTerminalModel.h"

@implementation StockTerminalModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"good_brand"]) {
            _terminalBrand = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_brand"]];
        }
        else {
            _terminalBrand = @"";
        }
        if ([dict objectForKey:@"Model_number"]) {
            _terminalModel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Model_number"]];
        }
        else {
            _terminalModel = @"";
        }
        if ([dict objectForKey:@"serial_num"]) {
            _terminalNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        }
        else {
            _terminalNumber = @"";
        }
        _openStatus = [[dict objectForKey:@"status"] intValue];
    }
    return self;
}

- (NSString *)getOpenStatusString {
    NSString *status = nil;
    switch (_openStatus) {
        case TerminalStatusOpened:
            status = @"已开通";
            break;
        case TerminalStatusPartOpened:
            status = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            status = @"未开通";
            break;
        case TerminalStatusCanceled:
            status = @"已取消";
            break;
        case TerminalStatusStopped:
            status = @"已停用";
            break;
        default:
            break;
    }
    return status;
}

@end
