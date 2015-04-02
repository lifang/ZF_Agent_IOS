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

@interface SearchHistoryHelper : NSObject

/*
 商品搜索历史
 */
+ (NSMutableArray *)getGoodsHistory;
+ (void)saveGoodsHistory:(NSMutableArray *)goodsHistory;
+ (void)removeGoodsHistory;

@end
