//
//  UserModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

/*用户终端*/
@interface UserTerminalModel : NSObject

@property (nonatomic, strong) NSString *terminalID;

@property (nonatomic, strong) NSString *terminalNum;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

/*用户管理*/
@interface UserModel : NSObject

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *agentID;

@property (nonatomic, strong) NSString *userName;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
