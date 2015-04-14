//
//  ScanImageViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ScanImageViewController.h"

@interface ScanImageViewController ()<ImageScrollViewDelegate>

//点击看大图
@property (nonatomic, strong) UIScrollView *imagesScrollView;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *scrollPanel;

@end

@implementation ScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initImageScanView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

//查看大图
- (void)initImageScanView {
    _scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    _scrollPanel.backgroundColor = [UIColor clearColor];
    _scrollPanel.alpha = 0;
    [self.view addSubview:_scrollPanel];
    CGRect rect = _scrollPanel.bounds;
    rect.size.height += 64;
    _markView = [[UIView alloc] initWithFrame:rect];
    _markView.backgroundColor = [UIColor blackColor];
    _markView.alpha = 0.0;
    [_scrollPanel addSubview:_markView];
    
    _imagesScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollPanel addSubview:_imagesScrollView];
    _imagesScrollView.pagingEnabled = YES;
}


#pragma mark - 图片点击

- (void)showDetailImageWithURL:(NSString *)urlString
                     imageRect:(CGRect)rect {
    urlString = @"http://pic42.nipic.com/20140608/18347945_020920394000_2.jpg";
    [self.view bringSubviewToFront:self.scrollPanel];
    self.scrollPanel.alpha = 1.0;
    
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGPoint contentOffset = self.imagesScrollView.contentOffset;
        
        ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:(CGRect){contentOffset,self.imagesScrollView.bounds.size}];
        [imagescroll setContentWithFrame:rect];
        [imagescroll setImage:imageView.image]; 
        [self.imagesScrollView addSubview:imagescroll];
        imagescroll.tapDelegate = self;
        [self performSelector:@selector(setOriginFrame:) withObject:imagescroll afterDelay:0.1f];
    }];
}

#pragma mark - 大图

- (void)setOriginFrame:(ImageScrollView *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.navigationBarHidden = YES;
        [sender setAnimationRect];
        self.markView.alpha = 1.0;
    }];
}

#pragma mark - ImageScrollViewDelegate

- (void)tapImageViewWithObject:(ImageScrollView *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.markView.alpha = 0;
        [sender rechangeInitRdct];
    } completion:^(BOOL finished) {
        self.scrollPanel.alpha = 0;
    }];
}

@end
