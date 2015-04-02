//
//  StockAgentModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StockAgentModel.h"

@implementation StockAgentModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"agent_id"]) {
            _agentID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agent_id"]];
        }
        if ([dict objectForKey:@"company_name"]) {
            _agentName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"company_name"]];
        }
        else {
            _agentName = @"";
        }
        if ([dict objectForKey:@"lastPrepareTime"]) {
            _prepareTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lastPrepareTime"]];
        }
        else {
            _prepareTime = @"";
        }
        if ([dict objectForKey:@"lastOpenTime"]) {
            _openTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lastOpenTime"]];
        }
        else {
            _openTime = @"";
        }
        _totalCount = [[dict objectForKey:@"hoitoryCount"] intValue];
        _openCount = [[dict objectForKey:@"openCount"] intValue];
    }
    return self;
}

@end
