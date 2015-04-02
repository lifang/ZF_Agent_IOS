//
//  TimeFormat.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeFormat : NSObject

//将日期转化成字符串yyyy-MM-dd格式
+ (NSString *)stringFromDate:(NSDate *)date;

//将yyyy-MM-dd格式字符串转化成日期
+ (NSDate *)dateFromString:(NSString *)string;

@end
