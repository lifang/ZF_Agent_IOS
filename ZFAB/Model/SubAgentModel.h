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

@property (nonatomic, assign) int saleCount;   //已售数量

@property (nonatomic, assign) int stockCount;   //剩余数量

@property (nonatomic, assign) int openCount;    //开通数量

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
