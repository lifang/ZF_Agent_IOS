//
//  TransferGoodCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TransferGoodCell.h"

@implementation TransferGoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    CGFloat rightSpace = 20.f;
    CGFloat labelHeight = 20.f;
    
    CGFloat scaleSize = 0.38;  //比例
    
    _fromLabel = [[UILabel alloc] init];
    _fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fromLabel.backgroundColor = [UIColor clearColor];
    _fromLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [self.contentView addSubview:_fromLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:scaleSize
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //图片
    UIImageView *transferView = [[UIImageView alloc] init];
    transferView.translatesAutoresizingMaskIntoConstraints = NO;
    transferView.image = kImageName(@"transfer.png");
    [self.contentView addSubview:transferView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:transferView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace + 5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:transferView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_fromLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:transferView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.f
                                                                  constant:50.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:transferView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:5.f]];
    _toLabel = [[UILabel alloc] init];
    _toLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _toLabel.backgroundColor = [UIColor clearColor];
    _toLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [self.contentView addSubview:_toLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:transferView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:scaleSize
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];

    //配货日期标题
    UILabel *timeTitleLabel = [[UILabel alloc] init];
    timeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeTitleLabel.backgroundColor = [UIColor clearColor];
    timeTitleLabel.font = [UIFont systemFontOfSize:12.f];
    timeTitleLabel.text = @"配货日期：";
    [self.contentView addSubview:timeTitleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:timeTitleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_fromLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:2.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:timeTitleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:timeTitleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:timeTitleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //调货数量标题
    UILabel *countTitleLabel = [[UILabel alloc] init];
    countTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    countTitleLabel.backgroundColor = [UIColor clearColor];
    countTitleLabel.font = [UIFont systemFontOfSize:12.f];
    countTitleLabel.text = @"配货数量：";
    [self.contentView addSubview:countTitleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:countTitleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_fromLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:2.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:countTitleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:countTitleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:-rightSpace - leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:countTitleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //日期
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:timeTitleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //数量
    _countLabel = [[UILabel alloc] init];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_countLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:countTitleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:-rightSpace - leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    
}

#pragma mark - Data

- (void)setContentWithData:(TransferGoodModel *)model {
    _fromLabel.text = [NSString stringWithFormat:@"%@",model.fromAgentName];
    _toLabel.text = [NSString stringWithFormat:@"%@",model.toAgentName];
    _timeLabel.text = model.createTime;
    _countLabel.text = [NSString stringWithFormat:@"%d件",model.count];
}


@end
