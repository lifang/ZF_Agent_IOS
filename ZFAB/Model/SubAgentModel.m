//
//  SubAgentModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SubAgentModel.h"

@implementation SubAgentModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _agentID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"company_name"]) {
            _agentName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"company_name"]];
        }
        else {
            _agentName = @"";
        }
        if ([dict objectForKey:@"created_at"]) {
            _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"created_at"]];
        }
        else {
            _createTime = @"";
        }
        _saleCount = [[dict objectForKey:@"soldNum"] intValue];
        _stockCount = [[dict objectForKey:@"allQty"] intValue];
        _openCount = [[dict objectForKey:@"openNum"] intValue];
    }
    return self;
}

@end
