//
//  TransferGoodModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferGoodModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *fromAgentName;

@property (nonatomic, strong) NSString *toAgentName;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, assign) int count;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
