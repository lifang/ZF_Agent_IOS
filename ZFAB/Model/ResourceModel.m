//
//  ResourceModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ResourceModel.h"

@implementation ResourceModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"title"]) {
            _title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        }
        else {
            _title = @"";
        }
        if ([dict objectForKey:@"upload_path"]) {
            _path = [NSString stringWithFormat:@"%@",[dict objectForKey:@"upload_path"]];
        }
    }
    return self;
}

@end
