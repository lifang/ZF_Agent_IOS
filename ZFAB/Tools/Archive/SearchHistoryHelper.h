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

typedef enum {
    HistoryTypeNone = 0,
    HistoryTypeGood,    //商品搜索历史
    HistoryTypeAfterSaleApply,  //申请售后终端搜索历史
}HistoryType;

@interface SearchHistoryHelper : NSObject

+ (NSMutableArray *)getHistoryWithType:(HistoryType)type;
+ (void)saveHistory:(NSMutableArray *)historyList forType:(HistoryType)type;
+ (void)removeHistoryWithType:(HistoryType)type;

@end
