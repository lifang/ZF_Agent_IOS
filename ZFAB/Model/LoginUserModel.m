//
//  LoginUserModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LoginUserModel.h"

@implementation LoginUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_agentID forKey:@"agentID"];
    [aCoder encodeObject:_agentUserID forKey:@"agentUserID"];
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_cityID forKey:@"cityID"];
    [aCoder encodeObject:[NSNumber numberWithBool:_hasProfit] forKey:@"profit"];
    [aCoder encodeObject:[NSNumber numberWithInt:_userType] forKey:@"userType"];
    [aCoder encodeObject:[NSNumber numberWithBool:_isFirstLevel] forKey:@"level"];
    [aCoder encodeObject:_authDict forKey:@"auth"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _agentID = [aDecoder decodeObjectForKey:@"agentID"];
        _agentUserID = [aDecoder decodeObjectForKey:@"agentUserID"];
        _userID = [aDecoder decodeObjectForKey:@"userID"];
        _cityID = [aDecoder decodeObjectForKey:@"cityID"];
        _hasProfit = [[aDecoder decodeObjectForKey:@"profit"] boolValue];
        _userType = [[aDecoder decodeObjectForKey:@"userType"] intValue];
        _isFirstLevel = [[aDecoder decodeObjectForKey:@"level"] boolValue];
        _authDict = [aDecoder decodeObjectForKey:@"auth"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LoginUserModel *user = [[self class] allocWithZone:zone];
    user.username = [_username copyWithZone:zone];
    user.password = [_password copyWithZone:zone];
    user.agentID = [_agentID copyWithZone:zone];
    user.agentUserID = [_agentUserID copyWithZone:zone];
    user.userID = [_userID copyWithZone:zone];
    user.cityID = [_cityID copyWithZone:zone];
    user.hasProfit = _hasProfit;
    user.userType = _userType;
    user.isFirstLevel = _isFirstLevel;
    user.authDict = [_authDict copyWithZone:zone];
    return user;
}

- (void)print {
    NSLog(@"username = %@",_username);
    NSLog(@"password = %@",_password);
    NSLog(@"agentID = %@",_agentID);
    NSLog(@"agentUserID = %@",_agentUserID);
    NSLog(@"userID = %@",_userID);
    NSLog(@"cityID = %@",_cityID);
    NSLog(@"profit = %d",_hasProfit);
    NSLog(@"userType = %d",_userType);
    NSLog(@"isFirst = %d",_isFirstLevel);
    NSLog(@"auth = %@",_authDict);
}

@end
