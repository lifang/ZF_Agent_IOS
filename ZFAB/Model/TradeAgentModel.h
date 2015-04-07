//
//  TradeAgentModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*交易流水代理商*/

#import <Foundation/Foundation.h>

@interface TradeAgentModel : NSObject

@property (nonatomic, strong) NSString *agentID;

@property (nonatomic, strong) NSString *agentName;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
