//
//  FormView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateModel.h"
#import "ChannelModel.h"

static CGFloat menuHeight = 24.f;
static CGFloat contentHeight = 34.f;

@interface FormView : UIView


+ (CGFloat)heightWithRowCount:(NSInteger)row
                     hasTitle:(BOOL)hasTitle;

//商品详情中样式
- (void)createFormWithTitle:(NSString *)formTitle
                     column:(NSArray *)titleArray
                    content:(NSArray *)itemArray;

//终端详情中样式
- (void)createFormWithColumn:(NSArray *)titleArray
                     content:(NSArray *)itemArray;

//终端详情数据
- (void)setRateData:(NSArray *)rateItems;

//商品详情数据
- (void)setGoodDetailDataWithFormTitle:(NSString *)formTitle
                               content:(NSArray *)detailItems
                            titleArray:(NSArray *)titleArray;

@end
