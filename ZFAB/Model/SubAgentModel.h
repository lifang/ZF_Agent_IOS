//
//  SubAgentModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubAgentModel : NSObject

@property (nonatomic, strong) NSString *agentID;

@property (nonatomic, strong) NSString *agentName;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, assign) int agentType;

@property (nonatomic, assign) int saleCount;

@property (nonatomic, assign) int stockCount;

@property (nonatomic, assign) int openCount;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
