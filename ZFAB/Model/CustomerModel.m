//
//  CustomerModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"username"]) {
            _loginName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
        }
        if ([dict objectForKey:@"name"]) {
            _realName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
    }
    return self;
}

@end
