//
//  PollingView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/***********图片轮询视图***********/

#import <UIKit/UIKit.h>

@interface PollingView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) NSTimer *timer;

- (void)downloadImageWithURLs:(NSArray *)urlArray
                       target:(id)target
                     action:(SEL)action
                   scaleImage:(BOOL)scaleImage;

@end
