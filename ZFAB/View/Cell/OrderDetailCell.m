//
//  OrderDetailCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         supplyType:(SupplyGoodsType)supplyType {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _supplyType = supplyType;
        [self initAndLayoutUI];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = 10.f;
    CGFloat leftSpace = 20.f;
    CGFloat labelHeight = 14.f;
    
    CGFloat imageSize = 70.f;
    
    //图片
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    CGFloat primaryWidth = 100.f;
    if (_supplyType == SupplyGoodsProcurement) {
        primaryWidth = 0.f;
    }
    //商品名
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace - primaryWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    if (_supplyType == SupplyGoodsWholesale) {
        //原价
        _primaryPriceLabel = [[UILabel alloc] init];
        _primaryPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _primaryPriceLabel.backgroundColor = [UIColor clearColor];
        _primaryPriceLabel.font = [UIFont systemFontOfSize:12.f];
        _primaryPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_primaryPriceLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:topSpace]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-10.f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:primaryWidth]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:0.0
                                                                      constant:14.f]];
    }
    //价格
    _actualPriceLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_actualPriceLabel WithTopView:_nameLabel topSpace:0.f alignment:NSTextAlignmentRight leftSpace:10.f];
    _actualPriceLabel.textColor = kColor(255, 102, 36, 1);
    _actualPriceLabel.font = [UIFont boldSystemFontOfSize:13.f];
    //开通费用
    _openPriceLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_openPriceLabel WithTopView:_actualPriceLabel topSpace:0.f alignment:NSTextAlignmentRight leftSpace:10.f];
    _openPriceLabel.textColor = kColor(255, 102, 36, 1);
    _openPriceLabel.font = [UIFont boldSystemFontOfSize:12.f];
//    //数量
//    _numberLabel = [[UILabel alloc] init];
//    [self layoutGoodLabel:_numberLabel WithTopView:_actualPriceLabel topSpace:0.f alignment:NSTextAlignmentRight leftSpace:10.f];
    //型号
    _brandLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_brandLabel WithTopView:_openPriceLabel topSpace:0.f alignment:NSTextAlignmentLeft leftSpace:10.f];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_channelLabel WithTopView:_brandLabel topSpace:0.f alignment:NSTextAlignmentLeft leftSpace:40.f];
    //数量
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.font = [UIFont systemFontOfSize:12.f];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_numberLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_numberLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_brandLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_numberLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_channelLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_numberLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_numberLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];

}

- (void)layoutGoodLabel:(UILabel *)label
            WithTopView:(UIView *)topView
               topSpace:(CGFloat)space
              alignment:(NSTextAlignment)alignment
              leftSpace:(CGFloat)leftSpace {
    CGFloat labelHeight = 14.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.f];
    label.textAlignment = alignment;
    [self.contentView addSubview:label];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:space]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    
}

#pragma mark - Data

- (void)setContentsWithData:(OrderGoodModel *)data {
    self.nameLabel.text = data.goodName;
    if (_supplyType == SupplyGoodsWholesale) {
        [self setPrimaryPriceWithString:[NSString stringWithFormat:@"原价 ￥%.2f",data.goodPrimaryPrice]];
        self.actualPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.goodActualPirce];
    }
    else {
        self.actualPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.goodPrimaryPrice];
    }
    self.openPriceLabel.text = [NSString stringWithFormat:@"(含开通费￥%.2f)",data.openCost];
    self.numberLabel.text = [NSString stringWithFormat:@"X %d",data.goodCount];
    self.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",data.goodBrand];
    self.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",data.goodChannel];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:data.goodImagePath] placeholderImage:nil];
}

- (void)setPrimaryPriceWithString:(NSString *)price {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:price];
    NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:12.f],NSFontAttributeName,
                                [UIColor blackColor],NSForegroundColorAttributeName,
                                [NSNumber numberWithInt:1],NSStrikethroughStyleAttributeName,
                                nil];
    [attrString addAttributes:normalAttr range:NSMakeRange(0, [attrString length])];
    _primaryPriceLabel.attributedText = attrString;
}

@end
