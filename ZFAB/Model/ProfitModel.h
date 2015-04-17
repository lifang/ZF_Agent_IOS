//
//  ProfitModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfitModel : NSObject

@property (nonatomic, strong) NSString *agentName;

@property (nonatomic, assign) int totalCount;

@property (nonatomic, assign) CGFloat getProfit;

@property (nonatomic, assign) CGFloat payProfit;

@property (nonatomic, assign) CGFloat amount;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
