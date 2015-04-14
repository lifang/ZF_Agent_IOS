//
//  GoodAgentModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodAgentModel.h"

@implementation GoodAgentModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"company_name"]) {
            _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"company_name"]];
        }
    }
    return self;
}

@end
