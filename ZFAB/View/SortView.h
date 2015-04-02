//
//  SortView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

typedef enum {
    SortNone = 0,
    SortDefault,     //默认排序
    SortSales,       //销量优先
    SortPriceDown,   //价格降序
    SortScore,       //评分最高
    SortPriceUp,     //价格升序
}SortType;

#import <UIKit/UIKit.h>

@protocol SortViewDelegate <NSObject>

- (void)changeValueWithIndex:(NSInteger)index;

@end

@interface SortView : UIView

@property (nonatomic, assign) id<SortViewDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setItems:(NSArray *)itemNames;

@end
