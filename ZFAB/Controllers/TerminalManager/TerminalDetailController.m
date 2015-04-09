//
//  TerminalDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalDetailController.h"
#import "FormView.h"
#import "OpeningModel.h"
#import "RecordView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ApplyDetailController.h"

typedef enum {
    TerDetailBtnTopRight = 1,
    TerDetailBtnTopLeft,
    TerDetailBtnBottomRight,
    TerDetailBtnBottomLeft,
}TerDetailBtnPosition;

@interface TerminalDetailController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *records; //保存追踪记录

@property (nonatomic, strong) NSMutableArray *ratesItems; //保存费率

@property (nonatomic, strong) NSMutableArray *openItems;   //保存开通资料

//终端信息
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *terminalNum;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantPhone;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *createTime;

@end

@implementation TerminalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"终端详情";
    _records = [[NSMutableArray alloc] init];
    _ratesItems = [[NSMutableArray alloc] init];
    _openItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self downloadDetail];
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
}

- (void)initSubViews {
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpce = 20.f;
    CGFloat labelHeight = 18.f;
    CGFloat space = 2.f;       //label之间垂直间距
    CGFloat lineSpace = 20.f;  //划线前后间距
    CGFloat titleLabelHeight = 20.f;
    
    //状态
    UILabel *statusTitleLabel = [[UILabel alloc] init];
    statusTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusTitleLabel.backgroundColor = [UIColor clearColor];
    statusTitleLabel.font = [UIFont systemFontOfSize:13.f];
    statusTitleLabel.text = @"开通状态：";
    [self.scrollView addSubview:statusTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont systemFontOfSize:18.f];
    [self.scrollView addSubview:statusLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.f]];
    //划线 90
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(222, 220, 220, 1);
    [self.scrollView addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:statusLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //终端信息 111
    UILabel *terminalTitleLabel = [[UILabel alloc] init];
    terminalTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    terminalTitleLabel.backgroundColor = [UIColor clearColor];
    terminalTitleLabel.textColor = kColor(108, 108, 108, 1);
    terminalTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:terminalTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线 133
    UIView *secondLine = [[UIView alloc] init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.backgroundColor = kMainColor;
    [self.scrollView addSubview:secondLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //终端号136
    UILabel *terminalNumberLabel = [[UILabel alloc] init];
    [self setLabel:terminalNumberLabel withTopView:secondLine middleSpace:space titleName:@"终端号"];
    //POS品牌
    UILabel *brandLabel = [[UILabel alloc] init];
    [self setLabel:brandLabel withTopView:terminalNumberLabel middleSpace:space titleName:@"POS品牌"];
    //POS型号
    UILabel *modelLabel = [[UILabel alloc] init];
    [self setLabel:modelLabel withTopView:brandLabel middleSpace:space titleName:@"POS型号"];
    //支付平台
    UILabel *channelLabel = [[UILabel alloc] init];
    [self setLabel:channelLabel withTopView:modelLabel middleSpace:space titleName:@"支付平台"];
    //商户名
    UILabel *merchantNameLabel = [[UILabel alloc] init];
    [self setLabel:merchantNameLabel withTopView:channelLabel middleSpace:space titleName:@"商户名"];
    //商户电话 236
    UILabel *merchantPhoneLabel = [[UILabel alloc] init];
    [self setLabel:merchantPhoneLabel withTopView:merchantNameLabel middleSpace:space titleName:@"商户电话"];
    //订单号
    UILabel *orderLabel = [[UILabel alloc] init];
    [self setLabel:orderLabel withTopView:merchantPhoneLabel middleSpace:space titleName:@"订单号"];
    //订购时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self setLabel:timeLabel withTopView:orderLabel middleSpace:space titleName:@"订购时间"];
    
    //费率表
    CGFloat rateHeight = [FormView heightWithRowCount:[_ratesItems count] hasTitle:NO];
    FormView *formView = [[FormView alloc] init];
    formView.translatesAutoresizingMaskIntoConstraints = NO;
    [formView setRateData:_ratesItems];
    [_scrollView addSubview:formView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:timeLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:rateHeight]];
    
    //开通信息
    UILabel *openTitleLabel = [[UILabel alloc] init];
    openTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    openTitleLabel.backgroundColor = [UIColor clearColor];
    openTitleLabel.textColor = kColor(108, 108, 108, 1);
    openTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:openTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:formView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.translatesAutoresizingMaskIntoConstraints = NO;
    thirdLine.backgroundColor = kMainColor;
    [self.scrollView addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:openTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //开通详情高度
    CGFloat openHeight = 0;
    //文字
    for (OpeningModel *model in _openItems) {
        if (model.type == ResourceText) {
            UILabel *openLabel = [[UILabel alloc] init];
            [self setLabel:openLabel withTopView:thirdLine middleSpace:openHeight + space titleName:model.resourceKey];
            openLabel.text = model.resourceValue;
            openHeight += titleLabelHeight;
        }
    }
    //图片
    int index = 0;
    for (OpeningModel *model in _openItems) {
        if (model.type == ResourceImage) {
            model.index = index;
            if (index % 2 == 0 && index != 0) {
                openHeight += labelHeight + lineSpace;
            }
            UILabel *imageLabel = [[UILabel alloc] init];
            [self setImageLabel:imageLabel withTopView:openTitleLabel middleSpace:openHeight + lineSpace data:model];
            index++;
        }
    }
    openHeight += labelHeight + lineSpace;
    //跟踪记录
    CGFloat recordHeight = 0.f;
    if ([self.records count] > 0) {
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = kColor(108, 108, 108, 1);
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"追踪记录：";
        [_scrollView addSubview:tipLabel];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:openTitleLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:openHeight + lineSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-rightSpce]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelHeight]];
        
        RecordView *recordView = [[RecordView alloc] initWithRecords:self.records
                                                               width:(kScreenWidth - leftSpace * 2)];
        recordView.translatesAutoresizingMaskIntoConstraints = NO;
        recordHeight = [recordView getHeight];
        [self.scrollView addSubview:recordView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:openTitleLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:lineSpace * 2 + openHeight]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-rightSpce]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:recordHeight]];
        [recordView initAndLayoutUI];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 400 + rateHeight + openHeight + recordHeight);
    terminalTitleLabel.text = @"终端信息";
    openTitleLabel.text = @"开通详情";
    statusLabel.text = [self getStatusString];
    terminalNumberLabel.text = _terminalNum;
    brandLabel.text = _brand;
    modelLabel.text = _model;
    channelLabel.text = _channel;
    merchantNameLabel.text = _merchantName;
    merchantPhoneLabel.text = _merchantPhone;
    orderLabel.text = _orderNumber;
    timeLabel.text = _createTime;
}

#pragma mark - Layout

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
       titleName:(NSString *)title {
    CGFloat leftSpace = 20.f;
    CGFloat rightSpce = 20.f;
    CGFloat labelHeight = 18.f;
    CGFloat vSpace = 10.f;
    CGFloat titleWidth = 80.f;
    
    //标题label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor = kColor(108, 108, 108, 1);
    titleLabel.text = title;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_scrollView addSubview:titleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:titleWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = kColor(108, 108, 108, 1);
    [_scrollView addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:vSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
}

- (void)setImageLabel:(UILabel *)label
          withTopView:(UIView *)topView
          middleSpace:(CGFloat)space
                 data:(OpeningModel *)dataModel {
    CGFloat leftSpace = 20.f;
    CGFloat labelHeight = 20.f;
    CGFloat vSpace = 0.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = kColor(108, 108, 108, 1);
    label.text = dataModel.resourceKey;
    [_scrollView addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    if (dataModel.index % 2 == 0) {
        //左侧
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
    }
    else {
        //右侧
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:0.5
                                                               constant:0.f]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.4
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    if (!dataModel.resourceValue) {
        return;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.tag = dataModel.index + 1;
    [btn setBackgroundImage:kImageName(@"upload.png") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanImage:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:label
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:vSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:20.f]];
}

#pragma mark - Request

- (void)downloadDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalDetailWithToken:delegate.token terminalID:_terminalModel.terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseTerminalDetailDataWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseTerminalDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    if ([[infoDict objectForKey:@"applyDetails"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *applyDict = [infoDict objectForKey:@"applyDetails"];
        if ([applyDict objectForKey:@"status"]) {
            _status = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"status"]];
        }
        if ([applyDict objectForKey:@"serial_num"]) {
            _terminalNum = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"serial_num"]];
        }
        if ([applyDict objectForKey:@"brandName"]) {
            _brand = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"brandName"]];
        }
        if ([applyDict objectForKey:@"model_number"]) {
            _model = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"model_number"]];
        }
        if ([applyDict objectForKey:@"channelName"]) {
            _channel = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"channelName"]];
        }
        if ([applyDict objectForKey:@"title"]) {
            _merchantName = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"title"]];
        }
        if ([applyDict objectForKey:@"phone"]) {
            _merchantPhone = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"phone"]];
        }
        if ([applyDict objectForKey:@"order_number"]) {
            _orderNumber = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"order_number"]];
        }
        if ([applyDict objectForKey:@"createdAt"]) {
            _createTime = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"createdAt"]];
        }
    }
    //费率
    id rateObject = [infoDict objectForKey:@"rates"];
    if ([rateObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [rateObject count]; i++) {
            id dict = [rateObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RateModel *model = [[RateModel alloc] initWithParseDictionary:dict];
                [self.ratesItems addObject:model];
            }
        }
    }
    //开通资料
    id openObject = [infoDict objectForKey:@"openingDetails"];
    if ([rateObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [openObject count]; i++) {
            id dict = [openObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                OpeningModel *model = [[OpeningModel alloc] initWithParseDictionary:dict];
                [self.openItems addObject:model];
            }
        }
    }
    //跟踪记录
    id recordObject = [infoDict objectForKey:@"trackRecord"];
    if ([recordObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [recordObject count]; i++) {
            id dict = [recordObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RecordModel *model = [[RecordModel alloc] initWithParseTerminalDictionary:dict];
                [self.records addObject:model];
            }
        }
    }
    [self initSubViews];
    [self addButton];
}

- (void)addButton {
    switch (_terminalModel.status) {
        case TerminalStatusOpened: {
            if (_terminalModel.appID) {
                UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
                UIButton *findPswBtn = [self buttonWithTitle:@"找回POS密码" action:@selector(findPassword:)];
                [self layoutButton:videoAuthBtn position:TerDetailBtnTopRight];
                [self layoutButton:findPswBtn position:TerDetailBtnBottomRight];
            }
        }
            break;
        case TerminalStatusPartOpened: {
            UIButton *synBtn = [self buttonWithTitle:@"同步" action:@selector(synchronization:)];
            UIButton *openConfirmBtn = [self buttonWithTitle:@"重新申请开通" action:@selector(openConfirm:)];
            UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
            UIButton *findPswBtn = [self buttonWithTitle:@"找回POS密码" action:@selector(findPassword:)];
            [self layoutButton:synBtn position:TerDetailBtnTopRight];
            [self layoutButton:openConfirmBtn position:TerDetailBtnBottomRight];
            [self layoutButton:videoAuthBtn position:TerDetailBtnTopLeft];
            [self layoutButton:findPswBtn position:TerDetailBtnBottomLeft];
        }
            break;
        case TerminalStatusUnOpened: {
            if (_terminalModel.appID) {
                UIButton *openApplyBtn = [self buttonWithTitle:@"开通申请" action:@selector(openApply:)];
                UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
                [self layoutButton:openApplyBtn position:TerDetailBtnTopRight];
                [self layoutButton:videoAuthBtn position:TerDetailBtnBottomRight];
            }
            else {
                UIButton *synBtn = [self buttonWithTitle:@"同步" action:@selector(synchronization:)];
                UIButton *openApplyBtn = [self buttonWithTitle:@"开通申请" action:@selector(openApply:)];
                UIButton *videoAuthBtn = [self buttonWithTitle:@"视频认证" action:@selector(videoAuth:)];
                [self layoutButton:synBtn position:TerDetailBtnTopRight];
                [self layoutButton:openApplyBtn position:TerDetailBtnBottomRight];
                [self layoutButton:videoAuthBtn position:TerDetailBtnTopLeft];
            }
        }
            break;
        case TerminalStatusCanceled:
            break;
        case TerminalStatusStopped: {
            UIButton *synBtn = [self buttonWithTitle:@"同步" action:@selector(synchronization:)];
            [self layoutButton:synBtn position:TerDetailBtnTopRight];
        }
            break;
        default:
            break;
    }
}

- (void)layoutButton:(UIButton *)button position:(TerDetailBtnPosition)position {
    CGFloat topSpace = 20.f;
    CGFloat middleSpace = 5.f;
    CGFloat btnWidth = 80.f;
    CGFloat btnHeight = 24.f;
    [_scrollView addSubview:button];
    if (position == TerDetailBtnTopRight || position == TerDetailBtnTopLeft) {
        //上面按钮
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scrollView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:topSpace]];
    }
    else if (position == TerDetailBtnBottomRight || position == TerDetailBtnBottomLeft) {
        //下面的按钮
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scrollView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:topSpace + middleSpace + btnHeight]];
    }
    if (position == TerDetailBtnTopRight || position == TerDetailBtnBottomRight) {
        //右侧按钮
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-20.f]];
    }
    else if (position == TerDetailBtnTopLeft || position == TerDetailBtnBottomLeft) {
        //左侧按钮
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-(20 + middleSpace + btnWidth)]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
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

- (NSString *)getStatusString {
    NSString *statusString = nil;
    int index = [self.status intValue];
    switch (index) {
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}

#pragma mark - Action

- (IBAction)scanImage:(id)sender {
    UIButton *btn = (UIButton *)sender;
    CGRect convertRect = [[btn superview] convertRect:btn.frame toView:self.view];
    for (OpeningModel *model in _openItems) {
        if (model.type == ResourceImage && btn.tag == model.index + 1) {
            [self showDetailImageWithURL:model.resourceValue imageRect:convertRect];
            break;
        }
    }
}

//同步
- (IBAction)synchronization:(id)sender {
    
}

//视频认证
- (IBAction)videoAuth:(id)sender {
    
}

//开通申请
- (IBAction)openApply:(id)sender {
    ApplyDetailController *detail = [[ApplyDetailController alloc] init];
    detail.terminalID = _terminalModel.terminalID;
    if (_terminalModel.status == TerminalStatusPartOpened) {
        detail.openStatus = OpenStatusReopen;
    }
    else {
        detail.openStatus = OpenStatusNew;
    }
    [self.navigationController pushViewController:detail animated:YES];
}

//重新开通申请
- (IBAction)openConfirm:(id)sender {
    ApplyDetailController *detail = [[ApplyDetailController alloc] init];
    detail.terminalID = _terminalModel.terminalID;
    if (_terminalModel.status == TerminalStatusPartOpened) {
        detail.openStatus = OpenStatusReopen;
    }
    else {
        detail.openStatus = OpenStatusNew;
    }
    [self.navigationController pushViewController:detail animated:YES];
}

//找回POS密码
- (IBAction)findPassword:(id)sender {
    
}


@end
