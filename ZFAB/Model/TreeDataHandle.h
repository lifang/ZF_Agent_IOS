//
//  TreeDataHandle.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNodeModel.h"

#define kNoneFilterID  @"-1"   //全部ID

/*此处内容为解析字段，不可变动*/
static NSString *s_brands = @"brands";
static NSString *s_category = @"category";
static NSString *s_slip = @"sale_slip";
static NSString *s_card = @"pay_card";
static NSString *s_channel = @"pay_channel";
static NSString *s_trade = @"trade_type";
static NSString *s_date = @"tDate";
//*************************************
static NSString *s_maxPrice = @"maxPrice";
static NSString *s_minPrice = @"minPrice";
static NSString *s_rent = @"onlyRent";

@interface TreeDataHandle : NSObject

+ (NSDictionary *)parseData:(NSDictionary *)object;

@end
