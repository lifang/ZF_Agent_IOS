//
//  StockAgentModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

/*库存详情代理商对象*/
@interface StockAgentModel : NSObject

@property (nonatomic, strong) NSString *agentName;

@property (nonatomic, strong) NSString *agentID;
//上次配货时间
@property (nonatomic, strong) NSString *prepareTime;
//上次开通时间
@property (nonatomic, strong) NSString *openTime;

@property (nonatomic, assign) int totalCount;

@property (nonatomic, assign) int openCount;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
