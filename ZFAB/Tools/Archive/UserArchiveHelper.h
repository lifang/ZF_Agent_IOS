//
//  UserArchiveHelper.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUserModel.h"

@interface UserArchiveHelper : NSObject

+ (void)savePasswordForUser:(LoginUserModel *)user;

+ (LoginUserModel *)getLastestUser;

@end
