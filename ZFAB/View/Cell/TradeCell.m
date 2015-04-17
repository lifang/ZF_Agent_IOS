//
//  TradeCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TradeCell.h"

@implementation TradeCell

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
    CGFloat labelWidth = 200.f;
    CGFloat labelHeight = 18.f;
    
    //交易时间
    _tradeTimeLabel = [[UILabel alloc] init];
    _tradeTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _tradeTimeLabel.backgroundColor = [UIColor clearColor];
    _tradeTimeLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_tradeTimeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_tradeTimeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_tradeTimeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_tradeTimeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_tradeTimeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //付款账号
    _payFromLabel = [[UILabel alloc] init];
    _payFromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _payFromLabel.backgroundColor = [UIColor clearColor];
    _payFromLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_payFromLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payFromLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payFromLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_tradeTimeLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payFromLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payFromLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //收款账号
    _payToLabel = [[UILabel alloc] init];
    _payToLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _payToLabel.backgroundColor = [UIColor clearColor];
    _payToLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_payToLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payToLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payToLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_payFromLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payToLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payToLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //终端号
    _terminalLabel = [[UILabel alloc] init];
    _terminalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _terminalLabel.backgroundColor = [UIColor clearColor];
    _terminalLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_terminalLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_payToLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:14.f];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statusLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_tradeTimeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //总额
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.font = [UIFont systemFontOfSize:14.f];
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_terminalLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_payToLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
}

#pragma mark - Set

- (NSString *)statusForIndex:(NSString *)indexString {
    NSString *statusString = nil;
    int index = [indexString intValue];
    switch (index) {
        case TradeStatusUnPaid:
            statusString = @"待付款";
            break;
        case TradeStatusFinish:
            statusString = @"交易完成";
            break;
        case TradeStatusFail:
            statusString = @"交易失败";
            break;
        default:
            break;
    }
    return statusString;
}

- (void)setContentWithData:(TradeModel *)tradeModel
             withTradeType:(TradeType)tradeType {
    _tradeTimeLabel.text = [NSString stringWithFormat:@"交易时间：%@",tradeModel.tradeTime];
    _terminalLabel.text = [NSString stringWithFormat:@"终  端  号：%@",tradeModel.terminalNumber];
    _statusLabel.text = [self statusForIndex:tradeModel.tradeStatus];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",tradeModel.amount];
    switch (tradeType) {
        case TradeTypeTransfer:
            _payFromLabel.text = [NSString stringWithFormat:@"付款账号：%@",tradeModel.payFromAccount];
            _payToLabel.text = [NSString stringWithFormat:@"收款账号：%@",tradeModel.payIntoAccount];
            break;
        case TradeTypeConsume:
            _payFromLabel.text = [NSString stringWithFormat:@"结算时间：%@",tradeModel.payedTime];
            _payToLabel.text = [NSString stringWithFormat:@"手  续  费：%.2f",tradeModel.poundage];
            break;
        case TradeTypeRepayment:
            _payFromLabel.text = [NSString stringWithFormat:@"付款账号：%@",tradeModel.payFromAccount];
            _payToLabel.text = [NSString stringWithFormat:@"转入账号：%@",tradeModel.payIntoAccount];
            break;
        case TradeTypeLife:
            _payFromLabel.text = [NSString stringWithFormat:@"账  户  名：%@",tradeModel.accountName];
            _payToLabel.text = [NSString stringWithFormat:@"账户号码：%@",tradeModel.accountNumber];
            break;
        case TradeTypeTelephoneFare:
            _payFromLabel.text = @"";
            _payToLabel.text = [NSString stringWithFormat:@"手机号码：%@",tradeModel.phoneNumber];
            break;
        default:
            break;
    }
}

@end
