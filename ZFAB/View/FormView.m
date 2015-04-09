//
//  FormView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "FormView.h"

@implementation FormView

+ (CGFloat)heightWithRowCount:(NSInteger)row
                     hasTitle:(BOOL)hasTitle {
    CGFloat height = 0.f;
    if (hasTitle) {
        height += 20.f;
    }
    height += row * (contentHeight + kLineHeight) + kLineHeight * 2 + menuHeight;
    return height;
}



- (void)createFormWithTitle:(NSString *)formTitle
                     column:(NSArray *)titleArray
                    content:(NSArray *)itemArray {
    CGFloat borderSpace = 20.f;
    NSInteger columnCount = [titleArray count];
    NSInteger itemCount = [itemArray count];
    CGFloat itemWidth = (kScreenWidth - borderSpace * 2 - (columnCount + 1) * kLineHeight) / columnCount;
    
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.translatesAutoresizingMaskIntoConstraints = NO;
    pointView.image = kImageName(@"point.png");
    [self addSubview:pointView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:pointView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:6.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:pointView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:borderSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:pointView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:5.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:pointView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:5.f]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.text = formTitle;
    [self addSubview:titleLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:pointView
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-borderSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:20.f]];
    //竖线
    CGFloat lineHeight = menuHeight + itemCount * (contentHeight + kLineHeight) + kLineHeight * 2;
    
    for (int i = 0; i < columnCount + 1; i++) {
        CGFloat originX = i * (itemWidth + kLineHeight) + borderSpace;
        
        UIView *vLine = [[UIView alloc] init];
        vLine.translatesAutoresizingMaskIntoConstraints = NO;
        vLine.backgroundColor = kColor(165, 164, 164, 1);
        [self addSubview:vLine];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:titleLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:originX]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:kLineHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:lineHeight]];
    }
    //横线
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(165, 164, 164, 1);
    [self addSubview:firstLine];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:borderSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-borderSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:kLineHeight]];
    
    for (int i = 0; i < itemCount + 1; i++) {
        CGFloat originY = 20 + menuHeight + kLineHeight + i * (contentHeight + kLineHeight);
        
        UIView *hLine = [[UIView alloc] init];
        hLine.translatesAutoresizingMaskIntoConstraints = NO;
        hLine.backgroundColor = kColor(165, 164, 164, 1);
        [self addSubview:hLine];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:originY]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:borderSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:-borderSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:kLineHeight]];
    }
    
    //column标题
    for (int i = 0; i < columnCount; i++) {
        CGFloat titleOriginX = borderSpace + i * (itemWidth + kLineHeight);
        NSString *columnTitle = [titleArray objectAtIndex:i];
        
        UILabel *columnLabel = [[UILabel alloc] init];
        columnLabel.translatesAutoresizingMaskIntoConstraints = NO;
        columnLabel.backgroundColor = [UIColor clearColor];
        columnLabel.font = [UIFont systemFontOfSize:13.f];
        columnLabel.textAlignment = NSTextAlignmentCenter;
        columnLabel.text = columnTitle;
        [self addSubview:columnLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:titleLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:kLineHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:titleOriginX]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:itemWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:menuHeight]];
    }
    //内容
    for (int i = 0; i < itemCount; i++) {
        CGFloat contentOriginY = 20 + kLineHeight * 2 + menuHeight + i * (contentHeight + kLineHeight);
        NSDictionary *dict = [itemArray objectAtIndex:i];
        for (int j = 0; j < columnCount; j++) {
            CGFloat contentOriginX = borderSpace + j * (itemWidth + kLineHeight);
            
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.font = [UIFont systemFontOfSize:13.f];
            contentLabel.textColor = kColor(144, 143, 143, 1);
            contentLabel.textAlignment = NSTextAlignmentCenter;
            contentLabel.text = [dict objectForKey:[NSString stringWithFormat:@"%d",j]];
            [self addSubview:contentLabel];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:contentOriginY]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:contentOriginX]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.0
                                                              constant:itemWidth]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.0
                                                              constant:contentHeight]];
        }
    }
    
}

- (void)createFormWithColumn:(NSArray *)titleArray
                    content:(NSArray *)itemArray {
    CGFloat borderSpace = 20.f;
    NSInteger columnCount = [titleArray count];
    NSInteger itemCount = [itemArray count];
    CGFloat itemWidth = (kScreenWidth - borderSpace * 2 - (columnCount + 1) * kLineHeight) / columnCount;
    //竖线
    CGFloat lineHeight = menuHeight + itemCount * (contentHeight + kLineHeight) + kLineHeight * 2;
    
    for (int i = 0; i < columnCount + 1; i++) {
        CGFloat originX = i * (itemWidth + kLineHeight) + borderSpace;
        
        UIView *vLine = [[UIView alloc] init];
        vLine.translatesAutoresizingMaskIntoConstraints = NO;
        vLine.backgroundColor = kMainColor;
        [self addSubview:vLine];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:originX]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:kLineHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:lineHeight]];
    }
    //横线
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kMainColor;
    [self addSubview:firstLine];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:borderSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-borderSpace]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:kLineHeight]];
    
    for (int i = 0; i < itemCount + 1; i++) {
        if (!(i == 0 || i == itemCount)) {
            continue;
        }
        CGFloat originY = menuHeight + kLineHeight + i * (contentHeight + kLineHeight);
        
        UIView *hLine = [[UIView alloc] init];
        hLine.translatesAutoresizingMaskIntoConstraints = NO;
        hLine.backgroundColor = kMainColor;
        [self addSubview:hLine];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:originY]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:borderSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:-borderSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:hLine
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:kLineHeight]];
    }
    
    //column标题
    for (int i = 0; i < columnCount; i++) {
        CGFloat titleOriginX = borderSpace + i * (itemWidth + kLineHeight);
        NSString *columnTitle = [titleArray objectAtIndex:i];
        
        UILabel *columnLabel = [[UILabel alloc] init];
        columnLabel.translatesAutoresizingMaskIntoConstraints = NO;
        columnLabel.backgroundColor = [UIColor clearColor];
        columnLabel.font = [UIFont systemFontOfSize:13.f];
        columnLabel.textAlignment = NSTextAlignmentCenter;
        columnLabel.text = columnTitle;
        [self addSubview:columnLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:kLineHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:titleOriginX]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:itemWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:columnLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:menuHeight]];
    }
    //内容
    for (int i = 0; i < itemCount; i++) {
        CGFloat contentOriginY = kLineHeight * 2 + menuHeight + i * (contentHeight + kLineHeight);
        NSDictionary *dict = [itemArray objectAtIndex:i];
        for (int j = 0; j < columnCount; j++) {
            CGFloat contentOriginX = borderSpace + j * (itemWidth + kLineHeight);
            
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.font = [UIFont systemFontOfSize:13.f];
            contentLabel.textColor = kColor(144, 143, 143, 1);
            contentLabel.textAlignment = NSTextAlignmentCenter;
            contentLabel.text = [dict objectForKey:[NSString stringWithFormat:@"%d",j]];
            [self addSubview:contentLabel];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:contentOriginY]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:contentOriginX]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.0
                                                              constant:itemWidth]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.0
                                                              constant:contentHeight]];
        }
    }
}

#pragma mark - Data

- (void)setRateData:(NSArray *)rateItems {
    NSMutableArray *contentArray = [[NSMutableArray alloc] init];
    for (RateModel *model in rateItems) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (model.rateName) {
            [dict setObject:model.rateName forKey:@"0"];
        }
        else {
            [dict setObject:@"" forKey:@"0"];
        }
        CGFloat rate = model.rateTerminal;
        if ([model.rateName isEqualToString:@"消费"]) {
            rate = model.rateService + model.rateBase;
        }
        [dict setObject:[NSString stringWithFormat:@"%2.f‰",rate] forKey:@"1"];
        if ([model statusString]) {
            [dict setObject:[model statusString] forKey:@"2"];
        }
        else {
            [dict setObject:@"" forKey:@"2"];
        }
        [contentArray addObject:dict];
    }
    NSArray *titleArray = [NSArray arrayWithObjects:@"交易类型",@"费率",@"开通状态", nil];
    [self createFormWithColumn:titleArray content:contentArray];
}

- (void)setGoodDetailDataWithFormTitle:(NSString *)formTitle
                               content:(NSArray *)detailItems
                            titleArray:(NSArray *)titleArray {
    NSMutableArray *contentArray = [[NSMutableArray alloc] init];
    for (GoodRateModel *model in detailItems) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (model.rateName) {
            [dict setObject:model.rateName forKey:@"0"];
        }
        else {
            [dict setObject:@"" forKey:@"0"];
        }
        [dict setObject:[NSString stringWithFormat:@"%.f‰",model.ratePercent] forKey:@"1"];
        if (model.rateDescription) {
            [dict setObject:model.rateDescription forKey:@"2"];
        }
        else {
            [dict setObject:@"" forKey:@"2"];
        }
        [contentArray addObject:dict];
    }
    [self createFormWithTitle:formTitle column:titleArray content:contentArray];
}

@end
