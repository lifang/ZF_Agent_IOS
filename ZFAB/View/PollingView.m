//
//  PollingView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PollingView.h"
#import "UIImageView+WebCache.h"

@implementation PollingView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 20)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:kImageName(@"doc_unselected.png")];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:kImageName(@"doc_selected.png")];
    [self addSubview:_pageControl];
}

- (void)downloadImageWithURLs:(NSArray *)urlArray
                       target:(id)target
                       action:(SEL)action {
    NSInteger count = [urlArray count];
    _totalPage = count;
    _pageControl.numberOfPages = _totalPage;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * count, self.bounds.size.height);
    CGRect rect = self.bounds;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.tag = i + 1;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [imageView addGestureRecognizer:tap];
        //loading...
        NSString *urlString = [urlArray objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [_scrollView addSubview:imageView];
        rect.origin.x += self.bounds.size.width;
    }
    [self startTimer];
}

- (void)nextImage {
    NSInteger currentPage = _pageControl.currentPage;
    if (currentPage == _totalPage - 1) {
        currentPage = 0;
    }
    else {
        currentPage ++;
    }
    CGFloat offsetX = currentPage * self.bounds.size.width;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.f
                                              target:self
                                            selector:@selector(nextImage)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)endTimer {
    [_timer invalidate];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self endTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimer];
}

@end
