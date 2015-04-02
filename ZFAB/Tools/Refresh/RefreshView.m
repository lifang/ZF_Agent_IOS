//
//  RefreshView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 30) / 2, 40, 32, 32)];
        [self addSubview:_circleView];
        [self setRefreshState:RefreshNormal];
    }
    return self;
}

- (void)setDirection:(PullDirection)direction {
    _direction = direction;
    if (_direction == PullFromBottom) {
        //上拉将圆环设置在顶部
        CGRect rect = _circleView.frame;
        rect.origin.y = 10;
        _circleView.frame = rect;
    }
}

- (void)setRefreshState:(RefreshState)refreshState {
    switch (refreshState) {
        case RefreshPulling: {
            NSLog(@"松开刷新!");
        }
            break;
        case RefreshNormal: {
            NSLog(@"下拉刷新!");
        }
            break;
        case RefreshLoading: {
            NSLog(@"正在刷新!");
            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
            rotate.removedOnCompletion = FALSE;
            rotate.fillMode = kCAFillModeForwards;
            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
            rotate.repeatCount = HUGE_VALF;
            rotate.duration = 0.25;
            rotate.cumulative = TRUE;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            [_circleView.layer addAnimation:rotate forKey:@"rotateAnimation"];
        }
            break;
        default:
            break;
    }
    _refreshState = refreshState;
}

- (void)refreshViewDidScroll:(UIScrollView *)scrollView {
    if (_refreshState == RefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.f, 0.f, 0.f);
        }
        else {
            scrollView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 60.f, 0.f);
        }
    }
    else if (scrollView.isDragging) {
        BOOL loading = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(refreshViewIsLoading:)]) {
            loading = [_delegate refreshViewIsLoading:self];
        }
        
        if (_direction == PullFromTop) {
            //下拉刷新
            if (_refreshState == RefreshPulling &&
                scrollView.contentOffset.y > -maxOffsetForDownRefresh &&
                scrollView.contentOffset.y < 0.f &&
                !loading) {
                [self setRefreshState:RefreshNormal];
            }
            else if (_refreshState == RefreshNormal &&
                     scrollView.contentOffset.y < -maxOffsetForDownRefresh &&
                     !loading) {
                [self setRefreshState:RefreshPulling];
                _circleView.progress = 0.f;
                [_circleView setNeedsDisplay];
            }
            CGFloat offsetY = fabsf(scrollView.contentOffset.y);
            if (offsetY > 30) {
                offsetY = offsetY > maxOffsetForDownRefresh ? maxOffsetForDownRefresh : offsetY;
                _circleView.progress = (offsetY - 30) / (maxOffsetForDownRefresh - 30);
                [_circleView setNeedsDisplay];
            }
            if (scrollView.contentInset.top != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
        }
        else if (_direction == PullFromBottom) {
            //上拉加载更多
            if (_refreshState == RefreshPulling &&
                scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.bounds.size.height + maxOffsetForDownRefresh &&
                scrollView.contentOffset.y > 0.f &&
                !loading) {
                [self setRefreshState:RefreshNormal];
            }
            else if (_refreshState == RefreshNormal &&
                     scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height + maxOffsetForDownRefresh &&
                     !loading) {
                [self setRefreshState:RefreshPulling];
                _circleView.progress = 0.f;
                [_circleView setNeedsDisplay];
            }
            CGFloat offsetY = fabsf(scrollView.contentSize.height - scrollView.bounds.size.height - scrollView.contentOffset.y);
            if (offsetY > 30) {
                offsetY = offsetY > maxOffsetForDownRefresh ? maxOffsetForDownRefresh : offsetY;
                _circleView.progress = (offsetY - 30) / (maxOffsetForDownRefresh - 30);
                [_circleView setNeedsDisplay];
            }
            if (scrollView.contentInset.bottom != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
        }
    }
    else {
        if (_circleView.progress > 0) {
            _circleView.progress = 0.f;
            [_circleView setNeedsDisplay];
            [_circleView.layer removeAllAnimations];
        }
    }
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView {
    BOOL loading = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(refreshViewIsLoading:)]) {
        loading = [_delegate refreshViewIsLoading:self];
    }
    if (_direction == PullFromTop) {
        //下拉刷新
        if (scrollView.contentOffset.y <= -maxOffsetForDownRefresh && !loading) {
            if (_delegate && [_delegate respondsToSelector:@selector(refreshViewDidEndTrackingForRefresh:)]) {
                [_delegate refreshViewDidEndTrackingForRefresh:self];
            }
            [self setRefreshState:RefreshLoading];
            CGFloat offsetY = fabsf(scrollView.contentOffset.y);
            offsetY = offsetY > maxOffsetForDownRefresh ? maxOffsetForDownRefresh : offsetY;
            if (_circleView.progress == 0.f) {
                _circleView.progress = offsetY / maxOffsetForDownRefresh;
                [_circleView setNeedsDisplay];
            }
            [UIView animateWithDuration:.2f animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(60.f, 0.f, 0.f, 0.f);
            }];
        }
    }
    else if (_direction == PullFromBottom) {
        //上拉加载更多
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height + maxOffsetForDownRefresh && !loading) {
            if (_delegate && [_delegate respondsToSelector:@selector(refreshViewDidEndTrackingForRefresh:)]) {
                [_delegate refreshViewDidEndTrackingForRefresh:self];
            }
            [self setRefreshState:RefreshLoading];
            CGFloat offsetY = fabsf(scrollView.contentSize.height - scrollView.bounds.size.height - scrollView.contentOffset.y);
            offsetY = offsetY > maxOffsetForDownRefresh ? maxOffsetForDownRefresh : offsetY;
            if (_circleView.progress == 0.f) {
                _circleView.progress = offsetY / maxOffsetForDownRefresh;
                [_circleView setNeedsDisplay];
            }
            [UIView animateWithDuration:0.2f animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 60.f, 0.f);
            }];
        }
    }
}

- (void)refreshViewDidFinishedLoading:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.3f animations:^{
        scrollView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    }];
    _circleView.progress = 0.f;
    [_circleView setNeedsDisplay];
    [_circleView.layer removeAllAnimations];
    [self setRefreshState:RefreshNormal];
}

@end
