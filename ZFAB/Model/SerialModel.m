//
//  SerialModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SerialModel.h"

@implementation SerialModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"serial_num"]) {
            _serialNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        }
        _price = [[dict objectForKey:@"retail_price"] floatValue] / 100;
    }
    return self;
}

@end
