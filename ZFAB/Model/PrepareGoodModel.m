//
//  PrepareGoodModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PrepareGoodModel.h"

@implementation PrepareGoodModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"company_name"]) {
            _agentName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"company_name"]];
        }
        if ([dict objectForKey:@"created_at"]) {
            _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"created_at"]];
        }
        _count = [[dict objectForKey:@"quantity"] intValue];
    }
    return self;
}

@end
