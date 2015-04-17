//
//  CommentModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _contentID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"score"]) {
            _score = [[dict objectForKey:@"score"] floatValue] / 10;
        }
        if ([dict objectForKey:@"created_at"]) {
            _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"created_at"]];
        }
        if ([dict objectForKey:@"content"]) {
            _content = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
        }
    }
    return self;
}

@end
