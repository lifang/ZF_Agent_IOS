//
//  RefreshView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"

static CGFloat maxOffsetForDownRefresh = 65.0f;

typedef enum {
    RefreshPulling = 0,
    RefreshNormal,
    RefreshLoading,
}RefreshState;

typedef enum {
    PullFromTop = 0,
    PullFromBottom,
}PullDirection;

@protocol RefreshDelegate;

@interface RefreshView : UIView

@property (nonatomic, assign) id<RefreshDelegate>delegate;

@property (nonatomic, assign, setter = setRefreshState:) RefreshState refreshState;

@property (nonatomic, strong) CircleView *circleView;

@property (nonatomic, assign) PullDirection direction;

- (void)refreshViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshViewDidFinishedLoading:(UIScrollView *)scrollView;

@end


@protocol RefreshDelegate <NSObject>

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view;
- (BOOL)refreshViewIsLoading:(RefreshView *)view;

@end
