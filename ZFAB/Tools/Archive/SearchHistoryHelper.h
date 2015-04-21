//
//  SearchHistoryHelper.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/29.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHistory           @"searchHistory"

#define kGoodsHistoryPath  @"GoodsHistory"
#define kGoodsKey          @"Goods"

#define kAfterSaleApplyHistoryPath  @"AfterSaleApplyHistoryPath"
#define kAfterSaleApplyKey          @"AfterSaleApply"

#define kPGHistoryPath @"PGHistoryPath"
#define kPGKey         @"PG"

#define kOrderHistoryPath @"OrderHistoryPath"
#define kOrderKey         @"Order"

#define kTMHistoryPath @"TMHistoryPath"
#define kTMKey         @"TM"

#define kOpenApplyHistoryPath @"OpenApplyHistoryPath"
#define kOpenApplyKey         @"OpenApply"

#define kCSHistoryPath   @"CSHistoryPath"
#define kCSKey           @"CS"

#define kMerchantHistoryPath @"MerchantHistoryPath"
#define kMerchantKey         @"MerchantKey"

typedef enum {
    HistoryTypeNone = 0,
    HistoryTypeGood,    //商品搜索历史
    HistoryTypeAfterSaleApply,  //申请售后终端搜索历史
    HistoryTypePG,      //配货搜索历史
    HistoryTypeOrder,   //订单搜索
    HistoryTypeTM,      //终端管理
    HistoryTypeOpenApply, //开通申请
    HistoryTypeCS,       //售后
    HistoryTypeMerchant,  //商家
}HistoryType;

@interface SearchHistoryHelper : NSObject

+ (NSMutableArray *)getHistoryWithType:(HistoryType)type;
+ (void)saveHistory:(NSMutableArray *)historyList forType:(HistoryType)type;
+ (void)removeHistoryWithType:(HistoryType)type;

@end
