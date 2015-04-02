//
//  StockAgentCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StockAgentCell.h"

@implementation StockAgentCell

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
    CGFloat leftSpace = 10.f;
    CGFloat rightSpace = 10.f;
    CGFloat labelHeight = 20.f;
    CGFloat arrowWidth = 20.f;
    
    //名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
//    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_nameLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.4
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //配货总量
    _totalCountLabel = [[UILabel alloc] init];
    _totalCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalCountLabel.backgroundColor = [UIColor clearColor];
    _totalCountLabel.font = [UIFont systemFontOfSize:13.f];
    _totalCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_totalCountLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_nameLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:-leftSpace - arrowWidth / 2]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //已开通量
    _openCountLabel = [[UILabel alloc] init];
    _openCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _openCountLabel.backgroundColor = [UIColor clearColor];
    _openCountLabel.font = [UIFont systemFontOfSize:13.f];
    _openCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_openCountLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openCountLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openCountLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openCountLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:-leftSpace - arrowWidth / 2]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openCountLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //箭头
    _arrowView = [[UIImageView alloc] init];
    _arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    _arrowView.image = kImageName(@"arrow_right.png");
    [self.contentView addSubview:_arrowView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_openCountLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:5.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace + 2]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:8.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:15.f]];

    
    //配货日期
    _prepareTimeLabel = [[UILabel alloc] init];
    _prepareTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _prepareTimeLabel.backgroundColor = [UIColor clearColor];
    _prepareTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _prepareTimeLabel.textColor = kColor(107, 106, 106, 1);
    _prepareTimeLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_prepareTimeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_prepareTimeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_prepareTimeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_nameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:5.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_prepareTimeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_prepareTimeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //开通日期
    _openTimeLabel = [[UILabel alloc] init];
    _openTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _openTimeLabel.backgroundColor = [UIColor clearColor];
    _openTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _openTimeLabel.textColor = kColor(107, 106, 106, 1);
    _openTimeLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_openTimeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openTimeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openTimeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_nameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:5.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openTimeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_openTimeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
}

#pragma mark - Data

- (void)setContentWithData:(StockAgentModel *)model {
    _nameLabel.text = model.agentName;
    _totalCountLabel.text = [NSString stringWithFormat:@"%d",model.totalCount];
    _openCountLabel.text = [NSString stringWithFormat:@"%d",model.openCount];
    _prepareTimeLabel.text = [NSString stringWithFormat:@"上次配货日期:%@",model.prepareTime];
    _openTimeLabel.text = [NSString stringWithFormat:@"上次开通日期:%@",model.openTime];
}

@end
