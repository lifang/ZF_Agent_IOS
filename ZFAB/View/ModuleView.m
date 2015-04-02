//
//  ModuleView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ModuleView.h"

@implementation ModuleView

- (void)setTitleName:(NSString *)titleName
           imageName:(NSString *)imageName {
    _titleName = titleName;
    _imageName = imageName;
    [self initUI];
}

- (void)initUI {
    CGFloat imageSize = 32.f; //图片大小
    CGFloat middleSpace = 8.f; //图片和文字垂直间距
    CGFloat labelHeight = 24.f;
    CGFloat v_space = (self.bounds.size.height - imageSize - labelHeight - middleSpace) / 2;
    CGFloat h_space = (self.bounds.size.width - imageSize) / 2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(h_space, v_space, imageSize, imageSize)];
    imageView.image = [UIImage imageNamed:_imageName];
    [self addSubview:imageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageSize + middleSpace, self.bounds.size.width, labelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = _titleName;
    [self addSubview:titleLabel];
    [self setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
}

@end
