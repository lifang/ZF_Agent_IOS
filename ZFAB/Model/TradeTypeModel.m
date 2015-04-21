//
//  TradeTypeModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TradeTypeModel.h"

@implementation TradeTypeModel

- (id)initWithGetListParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"tradeTypeName"]) {
            _tradeName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tradeTypeName"]];
        }
        _percent = [[dict objectForKey:@"percent"] floatValue];
        if ([dict objectForKey:@"tradeTypeId"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tradeTypeId"]];
        }
    }
    return self;
}

- (id)initWithGetTypeParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"trade_value"]) {
            _tradeName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"trade_value"]];
        }
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _channelName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        _percent = 1.f;
    }
    return self;
}

@end
