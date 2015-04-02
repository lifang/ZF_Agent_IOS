//
//  UserModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "UserModel.h"

@implementation UserTerminalModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _terminalID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"serial_num"]) {
            _terminalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        }
        else {
            _terminalNum = @"";
        }
    }
    return self;
}

@end

@implementation UserModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"customersId"]) {
            _userID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"customersId"]];
        }
        if ([dict objectForKey:@"agentId"]) {
            _agentID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agentId"]];
        }
        if ([dict objectForKey:@"name"]) {
            _userName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        else {
            _userName = @"";
        }
    }
    return self;
}

@end
