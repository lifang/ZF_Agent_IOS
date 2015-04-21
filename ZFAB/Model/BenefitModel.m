//
//  BenefitModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "BenefitModel.h"

@implementation BenefitModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"channelName"]) {
            _channelName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"channelName"]];
        }
        id list = [dict objectForKey:@"detail"];
        if ([list isKindOfClass:[NSArray class]]) {
            _tradeList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [list count]; i++) {
                id tradeDict = [list objectAtIndex:i];
                if ([tradeDict isKindOfClass:[NSDictionary class]]) {
                    TradeTypeModel *model = [[TradeTypeModel alloc] initWithGetListParseDictionary:tradeDict];
                    [_tradeList addObject:model];
                }
            }
        }
    }
    return self;
}

@end
