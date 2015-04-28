//
//  UserArchiveHelper.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/28.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "UserArchiveHelper.h"

#define kLastestPath  @"lastestUserInformation"
#define kLastestFile  @"lastestUser"

@implementation UserArchiveHelper

#pragma mark - 最后登录用户

+ (NSString *)lastestUserPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:kLastestPath];
}

+ (void)savePasswordForUser:(LoginUserModel *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:user forKey:kLastestFile];
        [archiver finishEncoding];
        [data writeToFile:[[self class] lastestUserPath] atomically:YES];
    });
}

+ (LoginUserModel *)getLastestUser {
    NSString *userPath = [[self class] lastestUserPath];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:userPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchiver decodeObjectForKey:kLastestFile];
}


@end
