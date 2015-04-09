//
//  CSModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CSModel.h"

@implementation CSModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _csID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"terminal_num"]) {
            _terminalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"terminal_num"]];
        }
        if ([dict objectForKey:@"apply_num"]) {
            _applyNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"apply_num"]];
        }
        else {
            _applyNum = @"";
        }
        _status = [[dict objectForKey:@"status"] intValue];
        if ([dict objectForKey:@"create_time"]) {
            _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"create_time"]];
        }
    }
    return self;
}

- (NSString *)getCellIdentifier {
    NSString *cellIdentifier = nil;
    switch (_status) {
        case CSStatusFirst:
            cellIdentifier = firstStatusIdentifier;
            break;
        case CSStatusSecond:
            cellIdentifier = secondStatusIdentifier;
            break;
        case CSStatusThird:
            cellIdentifier = thirdStatusIdentifier;
            break;
        case CSStatusForth:
            cellIdentifier = forthStatusIdentifier;
            break;
        case CSStatusFifth:
            cellIdentifier = fifthStatusIdentifier;
            break;
        default:
            break;
    }
    return cellIdentifier;
}

- (NSString *)getCSNumberPrefixWithCSType:(CSType)csType {
    NSString *prefix = nil;
    switch (csType) {
        case CSTypeAfterSale:
            prefix = @"售后单编号：";
            break;
        case CSTypeUpdate:
            prefix = @"更新资料编号：";
            break;
        case CSTypeCancel:
            prefix = @"注销编号：";
            break;
        default:
            break;
    }
    return prefix;
}

@end
