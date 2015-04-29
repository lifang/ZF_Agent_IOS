//
//  RateModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RateModel.h"

@implementation RateModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _rateID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"trade_value"]) {
            _rateName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"trade_value"]];
        }
        if ([dict objectForKey:@"service_rate"]) {
            _rateService = [[dict objectForKey:@"service_rate"] floatValue] / 10;
        }
        if ([dict objectForKey:@"terminal_rate"]) {
            _rateTerminal = [[dict objectForKey:@"terminal_rate"] floatValue] / 10;
        }
        if ([dict objectForKey:@"base_rate"]) {
            _rateBase = [[dict objectForKey:@"base_rate"] floatValue] / 10;
        }
        if ([dict objectForKey:@"status"]) {
            _rateStatus = (RateStatus)[[dict objectForKey:@"status"] intValue];
        }
    }
    return self;
}

- (NSString *)statusString {
    if (_rateStatus == RateStatusOpened) {
        return @"开通";
    }
    return @"未开通";
}

@end
