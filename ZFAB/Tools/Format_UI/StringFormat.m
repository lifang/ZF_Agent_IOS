//
//  StringFormat.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StringFormat.h"

@implementation StringFormat

+ (CGFloat)heightForComment:(NSString *)content
                   withFont:(UIFont *)font
                      width:(CGFloat)width {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          font,NSFontAttributeName,
                          nil];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height + 1 > 20.f ? rect.size.height + 1 : 20.f;
}

+ (NSString *)serectAccountString:(NSString *)string {
    //倒数5-8位星号
    NSInteger length = [string length];
    if (length < 8) {
        return string;
    }
    NSMutableString *encryptString = [NSMutableString stringWithString:string];
    [encryptString replaceCharactersInRange:NSMakeRange(length - 8, 4) withString:@"****"];
    return encryptString;
}

+ (NSString *)serectNameString:(NSString *)string {
    //名字第二位
    NSInteger length = [string length];
    if (length < 2) {
        return string;
    }
    NSMutableString *encryptString = [NSMutableString stringWithString:string];
    [encryptString replaceCharactersInRange:NSMakeRange(length - 2, 1) withString:@"*"];
    return encryptString;
}

@end
