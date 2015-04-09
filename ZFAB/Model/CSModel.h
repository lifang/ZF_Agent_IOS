//
//  CSModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkInterface.h"

//对应于枚举状态为1的样式 
static NSString *firstStatusIdentifier = @"firstStatusIdentifier";
//2
static NSString *secondStatusIdentifier = @"secondStatusIdentifier";
//3
static NSString *thirdStatusIdentifier = @"thirdStatusIdentifier";
//4
static NSString *forthStatusIdentifier = @"forthStatusIdentifier";
//5
static NSString *fifthStatusIdentifier = @"fifthStatusIdentifier";

typedef enum {
    CSStatusAll = -1,
    CSStatusFirst = 1,
    CSStatusSecond,
    CSStatusThird,
    CSStatusForth,
    CSStatusFifth,
}CSStatus;

@interface CSModel : NSObject

@property (nonatomic, strong) NSString *csID;

@property (nonatomic, strong) NSString *terminalNum;

@property (nonatomic, strong) NSString *applyNum;

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString *createTime;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getCellIdentifier;

//编号
- (NSString *)getCSNumberPrefixWithCSType:(CSType)csType;

@end
