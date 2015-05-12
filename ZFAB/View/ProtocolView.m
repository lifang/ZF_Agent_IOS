//
//  ProtocolView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ProtocolView.h"

static CGFloat fontSize = 14.f;
static CGFloat stableHeight = 160.f;

@implementation ProtocolView

- (id)initWithFrame:(CGRect)frame string:(NSString *)content {
    if (self = [super initWithFrame:frame]) {
        _content = content;
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _panelView.backgroundColor = [UIColor blackColor];
    _panelView.alpha = 0.7;
    [self addSubview:_panelView];
    
    CGFloat outsideSpace = 20.f;
    CGFloat inSideSpace = 15.f;
    CGFloat height = [self heightForComment:_content withFont:[UIFont systemFontOfSize:fontSize] width:kScreenWidth - (outsideSpace + inSideSpace) * 2];
    CGFloat maxContentHeight = kScreenHeight - 80 * 2 - stableHeight;
    CGFloat contentHeight = height > maxContentHeight ? maxContentHeight : height;
    CGFloat originY = (kScreenHeight - stableHeight - contentHeight) / 2;
    _markView = [[UIView alloc] initWithFrame:CGRectMake(outsideSpace, originY, kScreenWidth - outsideSpace * 2, stableHeight + contentHeight)];
    _markView.backgroundColor = [UIColor whiteColor];
    _markView.layer.cornerRadius = 8;
    _markView.layer.masksToBounds = YES;
    [self addSubview:_markView];
    
    originY = 10.f;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(inSideSpace, originY, _markView.bounds.size.width - inSideSpace * 2, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = @"申请开通协议";
    [_markView addSubview:titleLabel];
    
    originY += 30;
    //内容
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(inSideSpace, originY, _markView.bounds.size.width - inSideSpace * 2, contentHeight)];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.contentSize = CGSizeMake(_markView.bounds.size.width - inSideSpace * 2, height);
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _markView.bounds.size.width - inSideSpace * 2, height)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:fontSize];
    contentLabel.numberOfLines = 0;
    contentLabel.text = _content;
    [contentView addSubview:contentLabel];
    [_markView addSubview:contentView];
    
    originY += contentHeight + 4;
    
    //划线
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, originY, _markView.bounds.size.width, 1)];
    firstLine.backgroundColor = kColor(233, 233, 234, 1);
    [_markView addSubview:firstLine];
    
    originY += 1 + 15;
    //选中按钮
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake(30, originY, 20, 20);
    [_agreeBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_agreeBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_agreeBtn addTarget:self action:@selector(agreeProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self setSelectedStatus];
    [_markView addSubview:_agreeBtn];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, originY, _markView.bounds.size.width - 52, 20)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:14.f];
    tipLabel.userInteractionEnabled = YES;
    tipLabel.text = @"我接受此开通协议";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreeProtocol:)];
    [tipLabel addGestureRecognizer:tap];
    [_markView addSubview:tipLabel];
    
    //按钮
    originY += 40;
    CGFloat btnWidth = (_markView.bounds.size.width - 4 * inSideSpace) / 2;
    CGFloat btnHeight = 36.f;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(inSideSpace, originY, btnWidth, btnHeight);
    cancelButton.layer.cornerRadius = 4.f;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.borderWidth = 1.f;
    cancelButton.layer.borderColor = kMainColor.CGColor;
    [cancelButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_markView addSubview:cancelButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(btnWidth + 3 * inSideSpace, originY, btnWidth, btnHeight);
    sureButton.layer.cornerRadius = 4.f;
    sureButton.layer.masksToBounds = YES;
    [sureButton setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [sureButton addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
    [_markView addSubview:sureButton];
}

#pragma mark - Action

- (IBAction)agreeProtocol:(id)sender {
    _agreeBtn.selected = !_agreeBtn.selected;
    [self setSelectedStatus];
}

- (IBAction)cancel:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)agree:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(protocolView:agreeProtocolWithStatus:)]) {
        [_delegate protocolView:self agreeProtocolWithStatus:_agreeBtn.isSelected];
    }
}

- (void)setSelectedStatus {
    if (_agreeBtn.isSelected) {
        [_agreeBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
    }
    else {
        [_agreeBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    }
}

#pragma mark - 计算高度

- (CGFloat)heightForComment:(NSString *)content
                   withFont:(UIFont *)font
                      width:(CGFloat)width {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          font,NSFontAttributeName,
                          nil];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height + 1 < 60 ? 60 : rect.size.height + 1;
}

@end
