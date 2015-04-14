//
//  TerminalBottomView.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalBottomView.h"

@implementation TerminalBottomView

- (id)init {
    if (self = [super init]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = kColor(188, 187, 187, 1);
    [self addSubview:line];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:kLineHeight]];
    
    _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishButton.translatesAutoresizingMaskIntoConstraints = NO;
    _finishButton.layer.cornerRadius = 4;
    _finishButton.layer.masksToBounds = YES;
    _finishButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_finishButton setTitle:@"确认" forState:UIControlStateNormal];
    [_finishButton setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [self addSubview:_finishButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_finishButton
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-10.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_finishButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_finishButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:80.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_finishButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:40.f]];
    //选中按钮
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_selectedButton setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_selectedButton setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_selectedButton addTarget:self action:@selector(selectedAll:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectedButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:10.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:18.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:18.f]];
    //全选文字
    _selectedLabel = [[UILabel alloc] init];
    _selectedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _selectedLabel.backgroundColor = [UIColor clearColor];
    _selectedLabel.font = [UIFont systemFontOfSize:15.f];
    _selectedLabel.textColor = kColor(128, 126, 126, 1);
    _selectedLabel.text = @"全选";
    _selectedLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(selectButton:)];
    [_selectedLabel addGestureRecognizer:tap];
    [self addSubview:_selectedLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_selectedButton
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:5.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:36.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectedLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:20.f]];
    //合计
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalLabel.backgroundColor = [UIColor clearColor];
    _totalLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.text = @"已选中0台";
    [self addSubview:_totalLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_finishButton
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:-5.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_selectedLabel
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:20.f]];
}

- (void)setBtnStatus {
    if (_selectedButton.isSelected) {
        [_selectedButton setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
        _selectedLabel.textColor = [UIColor blackColor];
    }
    else {
        [_selectedButton setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
        _selectedLabel.textColor = kColor(128, 126, 126, 1);
    }
}

#pragma mark - Action

- (IBAction)selectedAll:(id)sender {
    _selectedButton.selected = !_selectedButton.selected;
    [self setBtnStatus];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedAllTerminal:)]) {
        [_delegate selectedAllTerminal:_selectedButton.isSelected];
    }
}

- (void)selectButton:(UITapGestureRecognizer *)tap {
    [self selectedAll:nil];
}

- (void)setSelectedStatus:(BOOL)select {
    _selectedButton.selected = select;
    [self setBtnStatus];
}



@end
