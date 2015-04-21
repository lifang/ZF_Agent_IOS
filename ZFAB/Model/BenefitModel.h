//
//  BenefitModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TradeTypeModel.h"

@interface BenefitModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *channelName;

@property (nonatomic, strong) NSMutableArray *tradeList;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
