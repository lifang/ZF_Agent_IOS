//
//  BankModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"name"]) {
            _bankName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"code"]) {
            _bankCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        }
    }
    return self;
}

@end
