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

@end
