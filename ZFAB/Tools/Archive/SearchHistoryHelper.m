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

+ (NSMutableArray *)getGoodsHistory {
    NSMutableArray *historyItems = nil;
    NSString *directory = [[self class] searchHistoyDirectory];
    NSString *path = [directory stringByAppendingPathComponent:kGoodsHistoryPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        historyItems = [unarchiver decodeObjectForKey:kGoodsKey];
    }
    return historyItems;
}

+ (void)saveGoodsHistory:(NSMutableArray *)goodsHistory {
    NSString *directory = [[self class] searchHistoyDirectory];
    NSString *path = [directory stringByAppendingPathComponent:kGoodsHistoryPath];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:goodsHistory forKey:kGoodsKey];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
}

+ (void)removeGoodsHistory {
    NSString *directory = [[self class] searchHistoyDirectory];
    NSString *path = [directory stringByAppendingPathComponent:kGoodsHistoryPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

@end
