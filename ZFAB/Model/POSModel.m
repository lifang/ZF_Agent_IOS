//
//  POSModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "POSModel.h"

@implementation POSModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"title"]) {
            _title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        }
    }
    return self;
}

- (id)initWithParsePrepareGoodDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"goodname"]) {
            _title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"goodname"]];
        }
    }
    return self;
}

@end
