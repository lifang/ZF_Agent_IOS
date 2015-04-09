//
//  OrderDetailCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "UIImageView+WebCache.h"

#define kOrderDetailCellHeight  90.f

@interface OrderDetailCell : UITableViewCell

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *primaryPriceLabel; //原价

@property (nonatomic, strong) UILabel *actualPriceLabel; //现价

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

@property (nonatomic, assign) SupplyGoodsType supplyType;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         supplyType:(SupplyGoodsType)supplyType;

- (void)setContentsWithData:(OrderGoodModel *)data;

@end
