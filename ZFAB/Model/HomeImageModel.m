//
//  HomeImageModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/12.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "HomeImageModel.h"

@implementation HomeImageModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"picture_url"]) {
            _pictureURL = [NSString stringWithFormat:@"%@",[dict objectForKey:@"picture_url"]];
        }
        if ([dict objectForKey:@"website_url"]) {
            _websiteURL = [NSString stringWithFormat:@"%@",[dict objectForKey:@"website_url"]];
        }
        if ([dict objectForKey:@"goodid"]) {
            _goodID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"goodid"]];
        }
    }
    return self;
}

@end
