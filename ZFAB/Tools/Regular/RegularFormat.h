//
//  RegularFormat.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularFormat : NSObject

//手机正则
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//固话
+ (BOOL)isTelephoneNumber:(NSString *)teleNum;
//邮箱正则
+ (BOOL)isCorrectEmail:(NSString *)email;
//纯数字
+ (BOOL)isNumber:(NSString *)string;
//整形
+ (BOOL)isInt:(NSString*)string;

@end
