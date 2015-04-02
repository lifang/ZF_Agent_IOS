//
//  RegularFormat.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RegularFormat.h"

@implementation RegularFormat

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSString *newNumber = @"^1[0-9]{10}$";
    NSPredicate *regexNew = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",newNumber];
    if ([regexNew evaluateWithObject:mobileNum] == YES) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTelephoneNumber:(NSString *)teleNum {
    NSString *teleRegex = @"((\\d{3,4})|\\d{3,4}-|\\s)?\\d{7,8}";
    NSPredicate *teleTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",teleRegex];
    return [teleTest evaluateWithObject:teleNum];
}

+ (BOOL)isCorrectEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isNumber:(NSString *)string {
    NSString *regex = @"^[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (isMatch) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isInt:(NSString*)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
