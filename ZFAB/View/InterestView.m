//
//  InterestView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "InterestView.h"
#import "UIImageView+WebCache.h"

@implementation InterestView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAndLayoutUI];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    self.layer.borderColor = kColor(200, 200, 200, 1).CGColor;
    self.layer.borderWidth = kLineHeight;
    self.backgroundColor = kColor(246, 246, 246, 1);
    CGFloat topSpace = 5.f;
    CGFloat leftSpace = 5.f;
    CGFloat rightSpace = 5.f;
    CGFloat countLabelWidth = 50.f;
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_pictureView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:topSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:leftSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-rightSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:-(rightSpace + leftSpace)]];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_pictureView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:leftSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-rightSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:40.f]];
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.font = [UIFont boldSystemFontOfSize:13.f];
    _priceLabel.textColor = kColor(255, 102, 36, 1);
    [self addSubview:_priceLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:leftSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-rightSpace - countLabelWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:20.f]];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = kColor(175, 175, 175, 1);
    _countLabel.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:_countLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_priceLabel
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-rightSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:20.f]];
}

#pragma mark - Data

- (void)setRelationData:(RelativeGood *)relativeGood {
    _relativeGood = relativeGood;
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:relativeGood.pictureURL]];
    _titleLabel.text = relativeGood.title;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",relativeGood.price];
    _countLabel.text = [NSString stringWithFormat:@"已售%@",@"44"];
}

@end
