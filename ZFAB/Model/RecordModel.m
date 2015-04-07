//
//  RecordModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"marks_person"]) {
            _recordName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"marks_person"]];
        }
        if ([dict objectForKey:@"marks_time"]) {
            _recordTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"marks_time"]];
        }
        if ([dict objectForKey:@"marks_content"]) {
            _recordContent = [NSString stringWithFormat:@"%@",[dict objectForKey:@"marks_content"]];
        }
    }
    return self;
}

@end
