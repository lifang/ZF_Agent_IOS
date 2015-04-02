//
//  CircleView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, kMainColor.CGColor);
    CGContextSetLineWidth(context, 1.5f);
    CGFloat startAngle = M_PI / 3;
    _progress = _progress > 0.9 ? 0.9 : _progress;
    CGFloat step = 12 * M_PI / 6 * _progress;
    CGContextAddArc(context, self.bounds.size.width / 2, self.bounds.size.height / 2, self.bounds.size.width / 2 - 3, startAngle, startAngle + step, 0);
    CGContextStrokePath(context);
}

@end
