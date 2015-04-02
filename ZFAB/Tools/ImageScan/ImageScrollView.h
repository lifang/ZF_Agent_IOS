//
//  ImageScrollView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

/*
 图片放大缩小
 */

#import <UIKit/UIKit.h>

@class ImageScrollView;

@protocol ImageScrollViewDelegate <NSObject>

- (void)tapImageViewWithObject:(ImageScrollView *)sender;

@end

@interface ImageScrollView : UIScrollView

@property (nonatomic, assign) id<ImageScrollViewDelegate> tapDelegate;

- (void)setContentWithFrame:(CGRect)rect; //设置初始的frame
- (void)setImage:(UIImage *)image;        //图片处理
- (void)setAnimationRect;                 //动画，imageView从初始移动到处理后的位置
- (void)rechangeInitRdct;                 //消失动画

@end
