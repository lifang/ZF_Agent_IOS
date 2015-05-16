//
//  LoginUserModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUserModel : NSObject<NSCoding,NSCopying>

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *agentID;

@property (nonatomic, strong) NSString *agentUserID;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, assign) BOOL hasProfit;

@property (nonatomic, assign) int userType;

@property (nonatomic, assign) BOOL isFirstLevel;

@property (nonatomic, strong) NSMutableDictionary *authDict;

- (void)print;

@end
