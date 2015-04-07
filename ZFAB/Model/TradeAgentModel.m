//
//  TradeAgentModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TradeAgentModel.h"

@implementation TradeAgentModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"agentId"]) {
            _agentID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agentId"]];
        }
        if ([dict objectForKey:@"agentName"]) {
            _agentName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agentName"]];
        }
        else {
            _agentName = @"";
        }
    }
    return self;
}

@end
