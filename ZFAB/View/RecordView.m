//
//  RecordView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RecordView.h"

//static CGFloat topSpace = 10.f; //顶部与底部距离
static CGFloat recordMiddleSpace = 5.f;   //label之间间距
static CGFloat leftSpace = 10.f; //水平与两端间距
static CGFloat recordLabelHeight = 18.f;  //label高度

static CGFloat  fontSize = 12.f;

@implementation RecordView

- (id)initWithRecords:(NSArray *)records
                width:(CGFloat)width {
    if (self = [super init]) {
        _recordItems = records;
        _width = width;
        self.backgroundColor = kColor(230, 230, 230, 1);
    }
    return self;
}

- (CGFloat)getHeight {
    CGFloat height = 0.f;
    for (RecordModel *record in _recordItems) {
        CGFloat rowHeight = 0;
        CGRect rect = [self rectWithString:record.recordContent];
        rect.size.height = rect.size.height < recordLabelHeight ? recordLabelHeight : rect.size.height;
        rowHeight = rect.size.height + 1 + recordLabelHeight + recordMiddleSpace * 2 + 1;
        height += rowHeight;
    }
    return height + 2 * recordMiddleSpace;
}

- (CGRect)rectWithString:(NSString *)content {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:fontSize],NSFontAttributeName,
                          nil];
    return  [content boundingRectWithSize:CGSizeMake(_width - 2 * leftSpace, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attr
                                  context:nil];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = recordMiddleSpace;
    int i = 0;
    for (RecordModel *record in _recordItems) {
        i++;
        CGRect rect = [self rectWithString:record.recordContent];
        rect.size.height = rect.size.height < recordLabelHeight ? recordLabelHeight : rect.size.height;
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textColor = kColor(108, 108, 108, 1);
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.numberOfLines = 0;
        contentLabel.text = record.recordContent;
        [self addSubview:contentLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:topSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-leftSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:0.0
                                                               constant:rect.size.height + 1]];
        //姓名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = kColor(108, 108, 108, 1);
        nameLabel.font = [UIFont systemFontOfSize:fontSize];
        nameLabel.text = record.recordName;
        [self addSubview:nameLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:contentLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:recordMiddleSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:leftSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:80.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.0
                                                          constant:recordLabelHeight]];
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = kColor(108, 108, 108, 1);
        timeLabel.font = [UIFont systemFontOfSize:fontSize];
        timeLabel.text = record.recordTime;
        [self addSubview:timeLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:contentLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:recordMiddleSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nameLabel
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:-leftSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.0
                                                          constant:recordLabelHeight]];
        //划线
        UIView *firstLine = [[UIView alloc] init];
        firstLine.translatesAutoresizingMaskIntoConstraints = NO;
        firstLine.backgroundColor = kColor(150, 150, 150, 1);
        [self addSubview:firstLine];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nameLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:leftSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:-leftSpace]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.0
                                                          constant:kLineHeight]];
        topSpace += rect.size.height + 1 + recordMiddleSpace * 2 + recordLabelHeight + 1;
    }
}



@end
