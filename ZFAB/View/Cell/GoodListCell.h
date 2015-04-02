//
//  GoodListCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kGoodCellHeight  136.f

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "GoodListModel.h"

@interface GoodListCell : UITableViewCell

//图片框
@property (nonatomic, strong) UIImageView *pictureView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//原价
@property (nonatomic, strong) UILabel *primaryPriceLabel;
//批购价
@property (nonatomic, strong) UILabel *wholesalePriceLabel;
//最小起批量
@property (nonatomic, strong) UILabel *minWholesaleLabel;
//销售量
@property (nonatomic, strong) UILabel *salesVolumeLabel;
//品牌型号
@property (nonatomic, strong) UILabel *brandLabel;
//支付通道
@property (nonatomic, strong) UILabel *channelLabel;

- (void)setContentWithData:(GoodListModel *)model;

@end
