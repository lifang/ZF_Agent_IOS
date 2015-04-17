//
//  ProfitModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ProfitModel.h"

@implementation ProfitModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"agent"]) {
            _agentName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agent"]];
        }
        else {
            _agentName = @"";
        }
        _totalCount = [[dict objectForKey:@"total"] intValue];
        _getProfit = [[dict objectForKey:@"get"] floatValue] / 100;
        _payProfit = [[dict objectForKey:@"pay"] floatValue] / 100;
        _amount = [[dict objectForKey:@"amountTotal"] floatValue] / 100;
    }
    return self;
}

@end
