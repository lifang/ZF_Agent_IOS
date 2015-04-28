//
//  StringFormat.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFormat : NSObject

//计算文本高度
+ (CGFloat)heightForComment:(NSString *)content
                   withFont:(UIFont *)font
                      width:(CGFloat)width;

//账户隐藏倒数5-8位
+ (NSString *)serectAccountString:(NSString *)string;

//名字隐藏第二位
+ (NSString *)serectNameString:(NSString *)string;

@end
