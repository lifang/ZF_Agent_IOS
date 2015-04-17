//
//  InterestView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailModel.h"

@interface InterestView : UIView

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) RelativeGood *relativeGood;

- (void)setRelationData:(RelativeGood *)relativeGood;

@end
