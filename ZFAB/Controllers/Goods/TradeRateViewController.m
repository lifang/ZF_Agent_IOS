//
//  TradeRateViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TradeRateViewController.h"

@interface TradeRateViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TradeRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易费率";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initSubView];
    
}

- (void)initSubView {
    CGFloat titleHeight = 36.f;
    CGFloat contentHeight = 50.f;
    
    UILabel *dateTitleLabel = [[UILabel alloc] init];
    dateTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dateTitleLabel.backgroundColor = [UIColor clearColor];
    dateTitleLabel.font = [UIFont systemFontOfSize:15.f];
    dateTitleLabel.textAlignment = NSTextAlignmentCenter;
    dateTitleLabel.text = @"结算时间";
    [_scrollView addSubview:dateTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:titleHeight]];
    UILabel *rateTitleLabel = [[UILabel alloc] init];
    rateTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    rateTitleLabel.backgroundColor = [UIColor clearColor];
    rateTitleLabel.font = [UIFont systemFontOfSize:15.f];
    rateTitleLabel.textAlignment = NSTextAlignmentCenter;
    rateTitleLabel.text = @"资金服务费（/天）";
    [_scrollView addSubview:rateTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:titleHeight]];
    UIView *topView = nil;
    topView = [self addLineWithTopView:dateTitleLabel];
    for (GoodRateModel *model in _tradeRateItem) {
        topView = [self addRowsWithDate:model.rateName
                                   rate:model.ratePercent
                                topView:topView
                                 height:contentHeight];
    }
    CGFloat totalHeight = titleHeight + [_tradeRateItem count] * (contentHeight + kLineHeight) + kLineHeight;
    //竖线
    UIView *vLine = [[UIView alloc] init];
    vLine.translatesAutoresizingMaskIntoConstraints = NO;
    vLine.backgroundColor = kColor(204, 202, 203, 1);
    [_scrollView addSubview:vLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:kLineHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:totalHeight]];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, totalHeight);
}

- (UIView *)addRowsWithDate:(NSString *)date
                   rate:(CGFloat)rate
                topView:(UIView *)topView
                 height:(CGFloat)height {
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:15.f];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = date;
    [_scrollView addSubview:dateLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:height]];
    
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    rateLabel.backgroundColor = [UIColor clearColor];
    rateLabel.font = [UIFont systemFontOfSize:15.f];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.text = [NSString stringWithFormat:@"%.1f‰",rate];
    [_scrollView addSubview:rateLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:height]];
    UIView *rowLine = [self addLineWithTopView:dateLabel];
    return rowLine;
}

- (UIView *)addLineWithTopView:(UIView *)topView {
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = kColor(204, 202, 203, 1);
    [_scrollView addSubview:line];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:kLineHeight]];
    return line;
}

@end
