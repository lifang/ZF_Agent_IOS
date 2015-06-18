//
//  RegularFormat.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RegularFormat.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

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

+ (BOOL)isZipCode:(NSString *)zipCode {
    NSString *zipCodeRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *zipCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zipCodeRegex];
    return [zipCodeTest evaluateWithObject:zipCode];
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
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isFloat:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (int)stringLength:(NSString *)string {
    int strLength = 0;
    char *p = (char *)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strLength++;
        }
        else {
            p++;
        }
    }
    return strLength;
}

+ (BOOL)isCorrectIdentificationCard:(NSString *)string {
    if ([string length] == 18) {
        return YES;
    }
    return NO;
}

+ (BOOL)supportSIMStatusNotInserted {
    CTTelephonyNetworkInfo *teleNetInfo = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [teleNetInfo subscriberCellularProvider];
    if (nil != carrier.carrierName) {
        NSString *radiotech = [teleNetInfo currentRadioAccessTechnology];
        if (nil != radiotech) {
            return NO;
        }
        return YES;
        
    }
    else {
        return YES;
    }
}

//extern NSString* const kCTSMSMessageReceivedNotification;
//extern NSString* const kCTSMSMessageReplaceReceivedNotification;
//extern NSString* const kCTSIMSupportSIMStatusNotInserted;
//extern NSString* const kCTSIMSupportSIMStatusReady;
//
//id CTTelephonyCenterGetDefault(void);
//void CTTelephonyCenterAddObserver(id,id,CFNotificationCallback,NSString*,void*,int);
//void CTTelephonyCenterRemoveObserver(id,id,NSString*,void*);
//int CTSMSMessageGetUnreadCount(void);
//
//int CTSMSMessageGetRecordIdentifier(void * msg);
//NSString * CTSIMSupportGetSIMStatus();
//NSString * CTSIMSupportCopyMobileSubscriberIdentity();
//
//id  CTSMSMessageCreate(void* unknow/*always 0*/,NSString* number,NSString* text);
//void * CTSMSMessageCreateReply(void* unknow/*always 0*/,void * forwardTo,NSString* text);
//
//void* CTSMSMessageSend(id server,id msg);
//
//NSString *CTSMSMessageCopyAddress(void *, void *);
//NSString *CTSMSMessageCopyText(void *, void *);
//
//+ (BOOL)supportSIMStatusNotInserted {
//    return [CTSIMSupportGetSIMStatus() isEqualToString:kCTSIMSupportSIMStatusNotInserted];
//}

@end
