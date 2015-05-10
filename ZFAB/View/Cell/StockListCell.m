//
//  StockListCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StockListCell.h"

@implementation StockListCell

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
    CGFloat leftSpace = 10.f;
    CGFloat rightSpace = 10.f;
    CGFloat topSpace = 20.f;
    
    CGFloat hSpace = 10.f;   //距图片水平间距
    CGFloat vSpace = 0.f;
    
    CGFloat pictureSize = 70.f;  //图片大小
    
    CGFloat btnWidth = 70.f;
    
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
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
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
                                                                  constant:-rightSpace - btnWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:20.f]];
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
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace - btnWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:20.f]];
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
                                                                  constant:-rightSpace - btnWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:20.f]];
//    _nameButton = [self buttonWithTitle:@"商品更名" action:@selector(changeName:)];
//    [self.contentView addSubview:_nameButton];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:-rightSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeTop
//                                                                multiplier:1.0
//                                                                  constant:topSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:1.0
//                                                                  constant:btnWidth]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:24.f]];
//    _wholesaleButton = [self buttonWithTitle:@"去批购" action:@selector(goWholesale:)];
//    [self.contentView addSubview:_wholesaleButton];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesaleButton
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:-rightSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesaleButton
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_nameButton
//                                                                 attribute:NSLayoutAttributeBottom
//                                                                multiplier:1.0
//                                                                  constant:10.f]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesaleButton
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:1.0
//                                                                  constant:btnWidth]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wholesaleButton
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:24.f]];
    [self initNumberView];
}

- (void)initNumberView {
    CGFloat backHeight = 42.f;
    UIImageView *backView = [[UIImageView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.image = [kImageName(@"cellback.png") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.contentView addSubview:backView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:backHeight]];
    //划线
    UIImageView *firstLine = [[UIImageView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.image = [kImageName(@"stock_h_line.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    [backView addSubview:firstLine];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:1.f]];
    UIImageView *secondLine = [[UIImageView alloc] init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.image = [kImageName(@"stock_h_line.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    [backView addSubview:secondLine];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-kLineHeight]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.f]];
    //竖线
    CGFloat vLineWidth = 1.f;
    CGFloat itemWidth = (kScreenWidth - 3 * vLineWidth) / 4;
    for (int i = 0; i < 3; i++) {
        CGFloat originX = i * (itemWidth + vLineWidth) + itemWidth;
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(originX , 8, vLineWidth, 24)];
        line.image = [kImageName(@"stock_v_line.png") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        [backView addSubview:line];
    }
    _historyCountLabel = [[UILabel alloc] init];
    [self initLabelWithOriginX:0
                         width:itemWidth
                     titleName:@"历史进货数量"
                   numberLabel:_historyCountLabel
                       forView:backView];
    _openCountLabel = [[UILabel alloc] init];
    [self initLabelWithOriginX:itemWidth + vLineWidth
                         width:itemWidth
                     titleName:@"已开通数量"
                   numberLabel:_openCountLabel
                       forView:backView];
    _agentCountLabel = [[UILabel alloc] init];
    [self initLabelWithOriginX:(itemWidth + vLineWidth) * 2
                         width:itemWidth
                     titleName:@"代理商库存"
                   numberLabel:_agentCountLabel
                       forView:backView];
    _totalCountLabel = [[UILabel alloc] init];
    [self initLabelWithOriginX:(itemWidth + vLineWidth) * 3
                         width:itemWidth
                     titleName:@"总库存"
                   numberLabel:_totalCountLabel
                       forView:backView];
}

- (void)initLabelWithOriginX:(CGFloat)originX
                       width:(CGFloat)width
                   titleName:(NSString *)titleName
                 numberLabel:(UILabel *)numberLabel
                     forView:(UIView *)superView{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, width, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:11.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = titleName;
    [superView addSubview:titleLabel];
    
    numberLabel.frame = CGRectMake(originX, 20, width, 20);
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.font = [UIFont systemFontOfSize:12.f];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:numberLabel];
}

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = kMainColor.CGColor;
    [button setTitleColor:kMainColor forState:UIControlStateNormal];
    [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Data

- (void)setContentWithData:(StockListModel *)model {
    _stockModel = model;
    _titleLabel.text = model.stockTitle;
    NSString *brandString = [NSString stringWithFormat:@"品牌型号   %@%@",model.stockGoodBrand,model.stockGoodModel];
    _brandLabel.attributedText = [self attrStringWithString:brandString];
    NSString *channelString = [NSString stringWithFormat:@"支付平台   %@",model.stockChannel];
    _channelLabel.attributedText = [self attrStringWithString:channelString];
    _historyCountLabel.text = [NSString stringWithFormat:@"%d件",model.historyCount];
    _openCountLabel.text = [NSString stringWithFormat:@"%d件",model.openCount];
    _agentCountLabel.text = [NSString stringWithFormat:@"%d件",model.agentCount];
    _totalCountLabel.text = [NSString stringWithFormat:@"%d件",model.totalCount];
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:model.stockImagePath]];
}

- (NSAttributedString *)attrStringWithString:(NSString *)string {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    if ([string length] < 4) {
        return attrString;
    }
    NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont systemFontOfSize:13.f],NSFontAttributeName,
                               kColor(98, 97, 97, 1),NSForegroundColorAttributeName,
                               nil];
    NSDictionary *contentAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont boldSystemFontOfSize:13.f],NSFontAttributeName,
                                 [UIColor blackColor],NSForegroundColorAttributeName,
                                 nil];
    [attrString addAttributes:titleAttr range:NSMakeRange(0, 4)];
    [attrString addAttributes:contentAttr range:NSMakeRange(4, [attrString length] - 4)];
    return attrString;
}

#pragma mark - Action

- (IBAction)changeName:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(stockCellRenameForGood:)]) {
        [_delegate stockCellRenameForGood:_stockModel];
    }
}

- (IBAction)goWholesale:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(stockCellGoWholesale:)]) {
        [_delegate stockCellGoWholesale:_stockModel];
    }
}

@end
