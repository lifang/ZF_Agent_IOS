//
//  SearchHistoryHelper.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/29.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SearchHistoryHelper.h"

@implementation SearchHistoryHelper

+ (NSString *)searchHistoyDirectory {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *historyDirectory = [document stringByAppendingPathComponent:kHistory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:historyDirectory]) {
        [fileManager createDirectoryAtPath:historyDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return historyDirectory;
}

+ (NSString *)pathForHistoryType:(HistoryType)type {
    NSString *path = nil;
    switch (type) {
        case HistoryTypeGood:
            path = kGoodsHistoryPath;
            break;
        case HistoryTypeAfterSaleApply:
            path = kAfterSaleApplyHistoryPath;
            break;
        case HistoryTypePG:
            path = kPGHistoryPath;
            break;
        case HistoryTypeOrder:
            path = kOrderHistoryPath;
            break;
        case HistoryTypeTM:
            path = kTMHistoryPath;
            break;
        case HistoryTypeOpenApply:
            path = kOpenApplyHistoryPath;
            break;
        case HistoryTypeCS:
            path = kCSHistoryPath;
            break;
        default:
            break;
    }
    return path;
}

+ (NSString *)keyForHistoryType:(HistoryType)type {
    NSString *key = nil;
    switch (type) {
        case HistoryTypeGood:
            key = kGoodsKey;
            break;
        case HistoryTypeAfterSaleApply:
            key = kAfterSaleApplyKey;
            break;
        case HistoryTypePG:
            key = kPGKey;
            break;
        case HistoryTypeOrder:
            key = kOrderKey;
            break;
        case HistoryTypeTM:
            key = kTMKey;
            break;
        case HistoryTypeOpenApply:
            key = kOpenApplyKey;
            break;
        case HistoryTypeCS:
            key = kCSKey;
            break;
        default:
            break;
    }
    return key;
}

+ (NSMutableArray *)getHistoryWithType:(HistoryType)type {
    NSMutableArray *historyItems = nil;
    NSString *directory = [[self class] searchHistoyDirectory];
    NSString *path = [directory stringByAppendingPathComponent:[[self class] pathForHistoryType:type]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        historyItems = [unarchiver decodeObjectForKey:[[self class] keyForHistoryType:type]];
    }
    return historyItems;
}

+ (void)saveHistory:(NSMutableArray *)historyList forType:(HistoryType)type {
    NSString *directory = [[self class] searchHistoyDirectory];
    NSString *path = [directory stringByAppendingPathComponent:[[self class] pathForHistoryType:type]];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:historyList forKey:[[self class] keyForHistoryType:type]];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
}

+ (void)removeHistoryWithType:(HistoryType)type {
    NSString *directory = [[self class] searchHistoyDirectory];
    NSString *path = [directory stringByAppendingPathComponent:[[self class] pathForHistoryType:type]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

@end
