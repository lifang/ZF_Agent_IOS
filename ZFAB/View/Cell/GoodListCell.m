//
//  GoodListCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodListCell.h"

@implementation GoodListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

- (void)initAndLayoutUI {
    CGFloat leftSpace = 10.f;
    CGFloat rightSpace = 10.f;
    CGFloat topSpace = 10.f;
    
    CGFloat hSpace = 20.f;   //距图片水平间距
    CGFloat vSpace = 2.f;
    
    CGFloat pictureSize = 110.f;  //图片大小
    
    CGFloat priceWidth = 120.f;
    
    //图片框
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:36.f]];
    //原价
    _primaryPriceLabel = [[UILabel alloc] init];
    _primaryPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _primaryPriceLabel.backgroundColor = [UIColor clearColor];
    _primaryPriceLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _primaryPriceLabel.textColor = kColor(98, 97, 97, 1);
    [self.contentView addSubview:_primaryPriceLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:14.f]];
    //批购价
    _wholesalePriceLabel = [[UILabel alloc] init];
    _wholesalePriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _wholesalePriceLabel.backgroundColor = [UIColor clearColor];
    _wholesalePriceLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _wholesalePriceLabel.textColor = kColor(98, 97, 97, 1);
    [self.contentView addSubview:_wholesalePriceLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesalePriceLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesalePriceLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_primaryPriceLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesalePriceLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesalePriceLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:14.f]];
    //最小起批量
    _minWholesaleLabel = [[UILabel alloc] init];
    _minWholesaleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _minWholesaleLabel.backgroundColor = [UIColor clearColor];
    _minWholesaleLabel.font = [UIFont systemFontOfSize:12.f];
    _minWholesaleLabel.textColor = kColor(177, 176, 176, 1);
    [self.contentView addSubview:_minWholesaleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minWholesaleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minWholesaleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_wholesalePriceLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minWholesaleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:priceWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_minWholesaleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:14.f]];
    //销售量
    _salesVolumeLabel = [[UILabel alloc] init];
    _salesVolumeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _salesVolumeLabel.backgroundColor = [UIColor clearColor];
    _salesVolumeLabel.font = [UIFont systemFontOfSize:12.f];
    _salesVolumeLabel.textColor = kColor(177, 176, 176, 1);
    [self.contentView addSubview:_salesVolumeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-5.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_wholesalePriceLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_minWholesaleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:14.f]];
    
    //品牌
    _brandLabel = [[UILabel alloc] init];
    _brandLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _brandLabel.backgroundColor = [UIColor clearColor];
    _brandLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_brandLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_minWholesaleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:14.f]];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    _channelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _channelLabel.backgroundColor = [UIColor clearColor];
    _channelLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_channelLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_brandLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:14.f]];
    
}

#pragma mark - Data

- (void)setContentWithData:(GoodListModel *)model {
    _titleLabel.text = model.goodName;
    NSString *primaryPrice = [NSString stringWithFormat:@"原价 ￥%.2f",model.goodPrimaryPrice];
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:primaryPrice];
    NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont systemFontOfSize:12.f],NSFontAttributeName,
                               [NSNumber numberWithInt:2],NSStrikethroughStyleAttributeName,
                               nil];
    [priceAttrString addAttributes:priceAttr range:NSMakeRange(0, [priceAttrString length])];
    _primaryPriceLabel.attributedText = priceAttrString;
    
    NSString *wholesalePrice = [NSString stringWithFormat:@"批购价：￥%.2f",model.goodWholesalePrice];
    NSMutableAttributedString *wholesaleAttrString = [[NSMutableAttributedString alloc] initWithString:wholesalePrice];
    NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont systemFontOfSize:12.f],NSFontAttributeName,
                               nil];
    NSDictionary *contentAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont boldSystemFontOfSize:15],NSFontAttributeName,
                                 kColor(255, 102, 36, 1),NSForegroundColorAttributeName,
                                 nil];
    [wholesaleAttrString addAttributes:titleAttr range:NSMakeRange(0, 4)];
    [wholesaleAttrString addAttributes:contentAttr range:NSMakeRange(4, [wholesaleAttrString length] - 4)];
    _wholesalePriceLabel.attributedText = wholesaleAttrString;
    _minWholesaleLabel.text = [NSString stringWithFormat:@"最小起批量：%d件",model.minWholesaleNumber];
    _salesVolumeLabel.text = [NSString stringWithFormat:@"已售%d",model.goodSaleNumber];
    _brandLabel.text = [NSString stringWithFormat:@"品牌型号   %@%@",model.goodBrand,model.goodModel];
    _channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",model.goodChannel];
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:model.goodImagePath]];
}

@end
