//
//  ImageScrollView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "ImageScrollView.h"

@interface ImageScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGRect scaleOriginRect;

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign) CGRect initRect;

@end

@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setContentWithFrame:(CGRect)rect {
    _imageView.frame = rect;
    _initRect = rect;
}

- (void)setAnimationRect {
    _imageView.frame = _scaleOriginRect;
}

- (void)rechangeInitRdct {
    self.zoomScale = 1.0;
    _imageView.frame = _initRect;
}

- (void)setImage:(UIImage *)image {
    if (image) {
        _imageView.image = image;
        _imageSize = image.size;
        
        //判断首先缩放的值
        float scaleX = self.frame.size.width / _imageSize.width;
        float scaleY = self.frame.size.height / _imageSize.height;
        
        //倍数小的，先到边缘
        if (scaleX > scaleY) {
            //Y方向先到边缘
            float imgViewWidth = _imageSize.width * scaleY;
            self.maximumZoomScale = self.frame.size.width / imgViewWidth;
            
            _scaleOriginRect = (CGRect){self.frame.size.width / 2 - imgViewWidth / 2,0,imgViewWidth,self.frame.size.height};
        }
        else {
            //X先到边缘
            float imgViewHeight = _imageSize.height * scaleX;
            self.maximumZoomScale = self.frame.size.height / imgViewHeight;
            
            _scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        }
    }
}

#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    if (imgFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2;
    }
    if (imgFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2;
    }
    _imageView.center = centerPoint;
}

#pragma mark -
#pragma mark - touch
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.tapDelegate respondsToSelector:@selector(tapImageViewWithObject:)]) {
        [self.tapDelegate tapImageViewWithObject:self];
    }
}


@end

