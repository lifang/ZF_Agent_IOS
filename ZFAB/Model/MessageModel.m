//
//  MessageModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _messageID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"title"]) {
            _messageTitle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        }
        else {
            _messageTitle = @"";
        }
        if ([dict objectForKey:@"content"]) {
            _messageContent = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
        }
        else {
            _messageContent = @"";
        }
        if ([dict objectForKey:@"create_at"]) {
            _messageTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"create_at"]];
        }
        else {
            _messageTime = @"";
        }
        _messageRead = [[dict objectForKey:@"status"] boolValue];
    }
    return self;
}

@end
