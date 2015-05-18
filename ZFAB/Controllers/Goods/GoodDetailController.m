//
//  GoodDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodDetailController.h"
#import "AppDelegate.h"
#import "GoodDetailModel.h"
#import "PollingView.h"
#import "ImageScrollView.h"
#import "GoodButton.h"
#import "UIImageView+WebCache.h"
#import "FormView.h"
#import "StringFormat.h"
#import "InterestView.h"
#import "FactoryDetailController.h"
#import "ChannelWebsiteController.h"
#import "CommentViewController.h"
#import "TradeRateViewController.h"
#import "OpenInfoViewController.h"
#import "RentDescriptionController.h"
#import "WholesaleOrderController.h"
#import "ProcurementBuyOrderController.h"
#import "ProcurementRentController.h"
#import "GoodImageController.h"

@interface GoodDetailController ()<UIScrollViewDelegate,ImageScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) PollingView *topScorllView;

@property (nonatomic, strong) UIView *footerView;

//代购需要显示购买方式
@property (nonatomic, strong) GoodButton *buyButton;  //代购
@property (nonatomic, strong) GoodButton *rentButton; //代租赁

@property (nonatomic, strong) UIButton *goOrderBtn;

@property (nonatomic, strong) GoodDetailModel *detailModel;

@property (nonatomic, strong) UILabel *primaryPriceLabel;

@property (nonatomic, strong) UILabel *actualPriceLabel;

//点击看大图
@property (nonatomic, strong) UIScrollView *imagesScrollView;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *scrollPanel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) UILabel *pageLabel;

@end

@implementation GoodDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self downloadGoodDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat footerHeight = 60.f;
    //底部按钮
    _footerView = [[UIView alloc] init];
    _footerView.translatesAutoresizingMaskIntoConstraints = NO;
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-footerHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self footerViewAddSubview];
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _mainScrollView.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_mainScrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_footerView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    //image
    _topScorllView = [[PollingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    [_mainScrollView addSubview:_topScorllView];
    
    _primaryPriceLabel = [[UILabel alloc] init];
    _primaryPriceLabel.backgroundColor = [UIColor clearColor];
    _primaryPriceLabel.textAlignment = NSTextAlignmentRight;
    
    _actualPriceLabel = [[UILabel alloc] init];
    _actualPriceLabel.backgroundColor = [UIColor clearColor];
    _actualPriceLabel.textAlignment = NSTextAlignmentRight;
    
    _buyButton = [GoodButton buttonWithType:UIButtonTypeCustom];
    [_buyButton setButtonAttrWithTitle:@"采购"];
    [_buyButton addTarget:self action:@selector(buyGood:) forControlEvents:UIControlEventTouchUpInside];
    _buyButton.selected = YES;
    _rentButton = [GoodButton buttonWithType:UIButtonTypeCustom];
    [_rentButton setButtonAttrWithTitle:@"租赁"];
    [_rentButton addTarget:self action:@selector(rentGood:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initImageScanView];
    
    [self initSubViews];
}

- (void)footerViewAddSubview {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = kColor(135, 135, 135, 1);
    [_footerView addSubview:line];
    CGFloat middleSpace = 20.f;
    CGFloat btnWidth = kScreenWidth - 2 * middleSpace;
    CGFloat btnHeight = 36.f;
    //立即批购 代购
    _goOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goOrderBtn.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
    _goOrderBtn.layer.cornerRadius = 4.f;
    _goOrderBtn.layer.masksToBounds = YES;
    [_goOrderBtn setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    if (_supplyType == SupplyGoodsWholesale) {
        [_goOrderBtn setTitle:@"立即批购" forState:UIControlStateNormal];
    }
    else {
        [_goOrderBtn setTitle:@"立即采购" forState:UIControlStateNormal];
    }
    _goOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [_goOrderBtn addTarget:self action:@selector(goBuy:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_goOrderBtn];
}

//查看大图
- (void)initImageScanView {
    _scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    _scrollPanel.backgroundColor = [UIColor clearColor];
    _scrollPanel.alpha = 0;
    [self.view addSubview:_scrollPanel];
    CGRect rect = _scrollPanel.bounds;
    rect.size.height += 64;
    _markView = [[UIView alloc] initWithFrame:rect];
    _markView.backgroundColor = [UIColor blackColor];
    _markView.alpha = 0.0;
    [_scrollPanel addSubview:_markView];
    
    _imagesScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollPanel addSubview:_imagesScrollView];
    _imagesScrollView.pagingEnabled = YES;
    _imagesScrollView.delegate = self;
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height - 40, rect.size.width, 20)];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont boldSystemFontOfSize:14];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollPanel addSubview:_pageLabel];
}

- (void)initSubViews {
    CGFloat leftSpace = 20.f;  //左侧间距
    CGFloat rightSpace = 20.f; //右侧间距
    CGFloat labelHeight = 20.f; //label 高度
    CGFloat firstSpace = 5.f;
    CGFloat vSpace = 2.f;  //label 垂直间距
    CGFloat hSpace = 10.f;
    CGFloat leftLabelWidth = 60.f;  //左侧标题label宽度
    CGFloat btnHeight = 30.f;  //支付通道 和 购买方式 按钮高度
    CGFloat btnWidth = (kScreenWidth - leftSpace - rightSpace - leftLabelWidth - firstSpace - 2 * hSpace) / 3;
    CGFloat originY = _topScorllView.frame.origin.y + _topScorllView.frame.size.height + vSpace;
    //商品名
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    titleLabel.text = _detailModel.goodName;
    [_mainScrollView addSubview:titleLabel];
    
    originY += vSpace + labelHeight;
    //商品简介
    CGFloat minWholesaleWidth = 120.f;  //最低起批量
    if (_supplyType != SupplyGoodsWholesale) {
        minWholesaleWidth = 0.f;
    }
    
    CGFloat secondTitleHeight = [StringFormat heightForComment:_detailModel.detailName
                                                  withFont:[UIFont systemFontOfSize:13.f]
                                                     width:kScreenWidth - leftSpace - rightSpace - minWholesaleWidth];
    secondTitleHeight = secondTitleHeight < labelHeight ? labelHeight : secondTitleHeight;
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace - minWholesaleWidth, secondTitleHeight)];
    summaryLabel.backgroundColor = [UIColor clearColor];
    summaryLabel.font = [UIFont systemFontOfSize:13.f];
    summaryLabel.textColor = [UIColor lightGrayColor];
    summaryLabel.numberOfLines = 0;
    summaryLabel.text = _detailModel.detailName;
    [_mainScrollView addSubview:summaryLabel];
    
    if (_supplyType == SupplyGoodsWholesale) {
        //批购需要显示最低起批量
        UILabel *minWholesaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - rightSpace - minWholesaleWidth, originY, minWholesaleWidth, labelHeight)];
        minWholesaleLabel.backgroundColor = [UIColor clearColor];
        minWholesaleLabel.font = [UIFont systemFontOfSize:12.f];
        minWholesaleLabel.text = [NSString stringWithFormat:@"最低起批量%d件",_detailModel.minWholesaleNumber];
        minWholesaleLabel.textAlignment = NSTextAlignmentRight;
        [_mainScrollView addSubview:minWholesaleLabel];
    }
    
    originY += vSpace + secondTitleHeight;
    //品牌
    UILabel *brandTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:brandTitleLabel withTitle:@"品牌" font:[UIFont systemFontOfSize:13.f]];
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, 80, labelHeight)];
    [self setLabel:brandLabel withTitle:_detailModel.goodBrand font:[UIFont boldSystemFontOfSize:13.f]];
    
    CGFloat originX = leftSpace + leftLabelWidth + firstSpace + 80;
    if (_supplyType == SupplyGoodsWholesale) {
        //原价
        _primaryPriceLabel.frame = CGRectMake(originX, originY, kScreenWidth - originX - rightSpace, labelHeight);
        [self setPrimaryPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.primaryPrice + _detailModel.defaultChannel.openCost]];
        [_mainScrollView addSubview:_primaryPriceLabel];
    }
    originY += vSpace + labelHeight;
    //型号
    UILabel *modelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:modelTitleLabel withTitle:@"型号" font:[UIFont systemFontOfSize:13.f]];
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, 80, labelHeight)];
    [self setLabel:modelLabel withTitle:_detailModel.goodModel font:[UIFont boldSystemFontOfSize:13.f]];
    
    //实际价格
    _actualPriceLabel.frame = CGRectMake(originX, originY, kScreenWidth - originX - rightSpace, labelHeight);
    if (_supplyType == SupplyGoodsWholesale) {
        [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.wholesalePrice + _detailModel.defaultChannel.openCost]];
    }
    else {
        if (_buyButton.isSelected) {
            [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.procurementPrice + _detailModel.defaultChannel.openCost]];
        }
        else {
            [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.deposit + _detailModel.defaultChannel.openCost]];
        }
    }
    [_mainScrollView addSubview:_actualPriceLabel];
    
    
    originY += vSpace + labelHeight;
    //终端类型
    UILabel *terTypeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:terTypeTitleLabel withTitle:@"终端类型" font:[UIFont systemFontOfSize:13.f]];
    UILabel *terTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, kScreenWidth - leftSpace - rightSpace - leftLabelWidth, labelHeight)];
    [self setLabel:terTypeLabel withTitle:_detailModel.goodCategory font:[UIFont boldSystemFontOfSize:13.f]];
    
    //已售
    UILabel *saleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kScreenWidth - originX - rightSpace, labelHeight)];
    saleNumberLabel.backgroundColor = [UIColor clearColor];
    saleNumberLabel.font = [UIFont systemFontOfSize:13.f];
    saleNumberLabel.textAlignment = NSTextAlignmentRight;
    saleNumberLabel.text = [NSString stringWithFormat:@"已售%d",_detailModel.goodSaleNumber];
    [_mainScrollView addSubview:saleNumberLabel];
    
    //支付通道
    originY += labelHeight + 10.f;
    UILabel *channelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, btnHeight)];
    [self setLabel:channelTitleLabel withTitle:@"支付通道" font:[UIFont systemFontOfSize:13.f]];
    CGFloat firstOrigin = leftSpace + leftLabelWidth + firstSpace;
    CGFloat btnMaxWidth = kScreenWidth - firstOrigin - rightSpace;
    originX = firstOrigin;
    CGFloat channelOriginY = originY;
    int channelRows = 1; //支付通道行数
    for (int i = 0; i < [_detailModel.channelItem count]; i++) {
        ChannelModel *model = [_detailModel.channelItem objectAtIndex:i];
        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                              nil];
        CGRect rect = [model.channelName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, btnHeight)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attr
                                                      context:nil];
        rect.size.width += 2; //防止文字靠边界
        //设置最小宽度
        CGFloat flexibleWidth = rect.size.width < btnWidth ? btnWidth : rect.size.width;
        //设置最大宽度
        flexibleWidth = flexibleWidth > btnMaxWidth ? btnMaxWidth : flexibleWidth;
        if (kScreenWidth - originX - rightSpace < flexibleWidth) {
            channelRows ++;
            originX = firstOrigin;
            channelOriginY += btnHeight + hSpace;
        }
        GoodButton *btn = [GoodButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(originX, channelOriginY, flexibleWidth, btnHeight);
        btn.ID = model.channelID;
        [btn setButtonAttrWithTitle:model.channelName];
        if ([model.channelID isEqualToString:_detailModel.defaultChannel.channelID]) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:btn];
        originX += flexibleWidth + hSpace;
    }
//    int rows = (int)([_detailModel.channelItem count] - 1) / 3 + 1;
//    originY += rows * (btnHeight + hSpace);
    originY += channelRows * (btnHeight + hSpace);
    
    if (_supplyType == SupplyGoodsProcurement) {
        //购买方式
        UILabel *buyTypeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, btnHeight)];
        [self setLabel:buyTypeTitleLabel withTitle:@"购买方式" font:[UIFont systemFontOfSize:13.f]];
        _buyButton.frame = CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, btnWidth, btnHeight);
        [_mainScrollView addSubview:_buyButton];
        _rentButton.frame = CGRectMake(_buyButton.frame.origin.x + _buyButton.frame.size.width + hSpace, originY, btnWidth, btnHeight);
        [_mainScrollView addSubview:_rentButton];
        if (_detailModel.canRent) {
            _rentButton.hidden = NO;
        }
        else {
            _rentButton.hidden = YES;
        }
        originY += btnHeight;
    }
    
    //厂家信息
    originY += hSpace;
//    UILabel *factoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, 90.f, labelHeight)];
//    factoryLabel.backgroundColor = [UIColor clearColor];
//    factoryLabel.font = [UIFont systemFontOfSize:12.f];
//    factoryLabel.text = @"查看厂家信息";
//    [_mainScrollView addSubview:factoryLabel];
//    
//    //厂家按钮
//    UIButton *factoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [factoryBtn setBackgroundImage:kImageName(@"info.png") forState:UIControlStateNormal];
//    factoryBtn.frame = CGRectMake(factoryLabel.frame.origin.x + factoryLabel.frame.size.width + vSpace, originY, labelHeight, labelHeight);
//    [factoryBtn addTarget:self action:@selector(scanFactoryInfo:) forControlEvents:UIControlEventTouchUpInside];
//    [_mainScrollView addSubview:factoryBtn];
//    
//    //划线
//    originY += labelHeight + vSpace;
//    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
//    firstLine.backgroundColor = kMainColor;
//    [_mainScrollView addSubview:firstLine];
//    
//    //支付通道厂家图片
//    originY += vSpace + 1;
//    UIImageView *factoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
//    [factoryImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.defaultChannel.channelFactoryLogo]];
//    [_mainScrollView addSubview:factoryImageView];
//    //厂家网址
//    UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth, originY, kScreenWidth - leftLabelWidth - leftSpace, labelHeight)];
//    websiteLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpForWebsite:)];
//    [websiteLabel addGestureRecognizer:websiteTap];
//    [self setLabel:websiteLabel withTitle:_detailModel.defaultChannel.channelFactoryURL font:[UIFont systemFontOfSize:13.f]];
//    
//    //厂家简介
//    originY += vSpace + labelHeight;
//    CGFloat summaryHeight = [StringFormat heightForComment:_detailModel.defaultChannel.channelFactoryDescription
//                                                  withFont:[UIFont systemFontOfSize:13.f]
//                                                     width:kScreenWidth - leftSpace - rightSpace];
//    summaryHeight = summaryHeight < labelHeight ? labelHeight : summaryHeight;
//    UILabel *factorySummaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, summaryHeight)];
//    factorySummaryLabel.numberOfLines = 0;
//    [self setLabel:factorySummaryLabel withTitle:_detailModel.defaultChannel.channelFactoryDescription font:[UIFont systemFontOfSize:13.f]];
//    factorySummaryLabel.textColor = kColor(102, 102, 102, 1);
    
    //按钮view
//    originY += summaryHeight + 10;
    UIView *handleView = [self handleViewWithOriginY:originY];
    [_mainScrollView addSubview:handleView];
    
    //pos信息
    originY += handleView.frame.size.height + 10;
    UILabel *posTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:posTitleLabel withTitle:@"POS信息" font:[UIFont systemFontOfSize:14.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    secondLine.backgroundColor = kMainColor;
    [_mainScrollView addSubview:secondLine];
    
    //品牌型号
    originY += vSpace + 1;
    NSString *brandModel = [NSString stringWithFormat:@"%@%@",_detailModel.goodBrand,_detailModel.goodModel];
    CGFloat brandHeight = [self addLabelWithTitle:@"品牌型号" content:brandModel offsetY:originY];
    //外壳
    originY += vSpace + brandHeight;
    CGFloat outTypeHeight = [self addLabelWithTitle:@"外壳类型" content:_detailModel.goodMaterial offsetY:originY];
    //电池
    originY += vSpace + outTypeHeight;
    CGFloat battyHeight = [self addLabelWithTitle:@"电池信息" content:_detailModel.goodBattery offsetY:originY];
    //签购单
    originY += vSpace + battyHeight;
    CGFloat signHeight = [self addLabelWithTitle:@"签购单打印方式" content:_detailModel.goodSignWay offsetY:originY];
    //加密卡
    originY += vSpace + signHeight;
    CGFloat encryptHeight = [self addLabelWithTitle:@"加密卡方式" content:_detailModel.goodEncryptWay offsetY:originY];
    
    //支付通道信息
    originY += encryptHeight + 10;
    UILabel *cTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:cTitleLabel withTitle:@"支付通道信息" font:[UIFont systemFontOfSize:13.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    thirdLine.backgroundColor = kMainColor;
    [_mainScrollView addSubview:thirdLine];
    
    //支持区域
    originY += vSpace + 1;
    NSString *area = [_detailModel.defaultChannel.supportAreaItem componentsJoinedByString:@" "];
    NSString *titleString = @"支持支付区域";
    if (!_detailModel.defaultChannel.supportType) {
        titleString = @"不支持支付区域";
    }
    CGFloat areaHeight = [self addLabelWithTitle:titleString content:area offsetY:originY];
    //注销
    originY += vSpace + areaHeight;
    NSString *cancelString = nil;
    if (_detailModel.defaultChannel.canCanceled) {
        cancelString = @"支持";
    }
    else {
        cancelString = @"不支持";
    }
    [self addLabelWithTitle:@"是否支持注销" content:cancelString offsetY:originY];
    
    //标准手续费
    originY += labelHeight + 10;
    CGFloat standFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.standRateItem count]
                                                  hasTitle:YES];
    FormView *standForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, standFormHeight)];
    [standForm setGoodDetailDataWithFormTitle:@"刷卡交易标准手续费"
                                      content:_detailModel.defaultChannel.standRateItem
                                   titleArray:[NSArray arrayWithObjects:@"商户类",@"费率",@"说明",nil]];
    [_mainScrollView addSubview:standForm];
    
    //资金服务费
    originY += standFormHeight + 10;
    CGFloat dateFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.dateRateItem count]
                                                 hasTitle:YES];
    FormView *dateForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, dateFormHeight)];
    [dateForm setGoodDetailDataWithFormTitle:@"资金服务费"
                                     content:_detailModel.defaultChannel.dateRateItem
                                  titleArray:[NSArray arrayWithObjects:@"结算周",@"费率",@"说明", nil]];
    [_mainScrollView addSubview:dateForm];
    
    //其它交易费率
    originY += dateFormHeight + 10;
    CGFloat otherFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.otherRateItem count]
                                                  hasTitle:YES];
    FormView *otherForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, otherFormHeight)];
    [otherForm setGoodDetailDataWithFormTitle:@"其它交易费率"
                                      content:_detailModel.defaultChannel.otherRateItem
                                   titleArray:[NSArray arrayWithObjects:@"交易类",@"费率",@"说明", nil]];
    [_mainScrollView addSubview:otherForm];
    
    //申请开通条件
    originY += otherFormHeight + 10;
    UILabel *openTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:openTitleLabel withTitle:@"申请开通条件" font:[UIFont systemFontOfSize:13.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *forthLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    forthLine.backgroundColor = kMainColor;
    [_mainScrollView addSubview:forthLine];
    
    //申请开通条件内容
    originY += vSpace + 1;
    CGFloat openHeight = [StringFormat heightForComment:_detailModel.defaultChannel.openRequirement
                                               withFont:[UIFont systemFontOfSize:13.f]
                                                  width:kScreenWidth - leftSpace - rightSpace];
    openHeight = openHeight < labelHeight ? labelHeight : openHeight;
    UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, openHeight)];
    openLabel.numberOfLines = 0;
    [self setLabel:openLabel withTitle:_detailModel.defaultChannel.openRequirement font:[UIFont systemFontOfSize:13.f]];
    
    //商品详细说明
    originY += openHeight + 20;
    UILabel *descriptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:descriptionTitleLabel withTitle:@"商品详细说明" font:[UIFont systemFontOfSize:13.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *fifthLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    fifthLine.backgroundColor = kMainColor;
    [_mainScrollView addSubview:fifthLine];
    
    //说明
    originY += vSpace + 1;
    CGFloat descriptionHeight = [StringFormat heightForComment:_detailModel.goodDescription
                                                      withFont:[UIFont systemFontOfSize:13.f]
                                                         width:kScreenWidth - leftSpace - rightSpace];;
    descriptionHeight = descriptionHeight < labelHeight ? labelHeight : descriptionHeight;
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, descriptionHeight)];
    descriptionLabel.numberOfLines = 0;
    [self setLabel:descriptionLabel withTitle:_detailModel.goodDescription font:[UIFont systemFontOfSize:13.f]];
    
    //感兴趣的
    originY += descriptionHeight + 20;
//    UIView *sixthLine = [[UIView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, 1)];
//    sixthLine.backgroundColor = kColor(200, 198, 199, 1);
//    [_mainScrollView addSubview:sixthLine];
//    UILabel *interestLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 80) / 2, originY - 10, 80, labelHeight)];
//    [self setLabel:interestLabel withTitle:@"您感兴趣的" font:[UIFont systemFontOfSize:13.f]];
//    interestLabel.textAlignment = NSTextAlignmentCenter;
//    interestLabel.backgroundColor = kColor(244, 243, 243, 1);
//    
//    originY += 20;
//    CGFloat middleSpace = 10.f;
//    CGFloat relateViewWidth = (kScreenWidth - leftSpace - rightSpace - middleSpace) / 2;
//    CGFloat relateViewHeight = relateViewWidth + 40 + 20 + 10;
//    CGRect rect = CGRectMake(leftSpace, originY, relateViewWidth, relateViewHeight);
//    for (int i = 0; i < [_detailModel.relativeItem count]; i++) {
//        if (i % 2 == 0 && i != 0) {
//            rect.origin.x = leftSpace;
//            rect.origin.y += relateViewHeight + middleSpace;
//        }
//        InterestView *interestView = [[InterestView alloc] initWithFrame:rect];
//        RelativeGood *relativeGood = [_detailModel.relativeItem objectAtIndex:i];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedRelativeGood:)];
//        [interestView addGestureRecognizer:tap];
//        [interestView setRelationData:relativeGood];
//        [_mainScrollView addSubview:interestView];
//        rect.origin.x += relateViewWidth + middleSpace;
//    }
//    if ([_detailModel.relativeItem count] > 0) {
//        int relateRow = (int)([_detailModel.relativeItem count] - 1) / 2 + 1;
//        originY += relateRow * (relateViewHeight + middleSpace);
//    }
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, originY);
}

- (UIView *)handleViewWithOriginY:(CGFloat)originY {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, 135)];
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 3; i++ ) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45 * i - 1, kScreenWidth, 0.5f)];
        line.backgroundColor = kColor(201, 201, 201, 1);
        [view addSubview:line];
    }
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(0, 0, kScreenWidth / 2, 45);
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [commentBtn setTitle:[NSString stringWithFormat:@"查看评论(%d)",_detailModel.goodComment]
                forState:UIControlStateNormal
     ];
    [commentBtn addTarget:self action:@selector(scanComment:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commentBtn];
    UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rateButton.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, 45);
    [rateButton setTitle:@"交易费率" forState:UIControlStateNormal];
    [rateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rateButton addTarget:self action:@selector(scanRate:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rateButton];
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.frame = CGRectMake(0, 45, kScreenWidth, 45);
    [openButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [openButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [openButton setTitle:@"开通所需材料" forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(scanOpenInfo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:openButton];
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(0, 90, kScreenWidth, 45);
    [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [imageButton setTitle:@"图文详情" forState:UIControlStateNormal];
    [imageButton setImage:kImageName(@"arrow_right.png") forState:UIControlStateNormal];
    imageButton.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth - 30, 0, 0);
    [imageButton addTarget:self action:@selector(scanGoodImage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:imageButton];
    //竖线
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 10, 0.5f, 25)];
    firstLine.backgroundColor = kColor(201, 201, 201, 1);
    [view addSubview:firstLine];
    return view;
}

//POS信息

- (CGFloat)addLabelWithTitle:(NSString *)title
                  content:(NSString *)content
                  offsetY:(CGFloat)offsetY {
    CGFloat leftSpace = 20.f;
    CGFloat titleLabelWidth = 100.f;
    CGFloat labelHeight = 20.f;
    CGFloat middleLeftSpace = leftSpace + titleLabelWidth + 5;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, offsetY, titleLabelWidth, labelHeight)];
    [self setLabel:titleLabel withTitle:title font:[UIFont systemFontOfSize:14.f]];
    [_mainScrollView addSubview:titleLabel];
    
    CGFloat contentHeight = [StringFormat heightForComment:content
                                                  withFont:[UIFont systemFontOfSize:14.f]
                                                     width:kScreenWidth - middleLeftSpace];
    contentHeight = contentHeight < labelHeight ? labelHeight : contentHeight;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleLeftSpace, offsetY, kScreenWidth - middleLeftSpace, contentHeight)];
    contentLabel.numberOfLines = 0;
    [self setLabel:contentLabel withTitle:content font:[UIFont systemFontOfSize:14.f]];
    contentLabel.textColor = kColor(144, 143, 143, 1);
    return contentHeight;
}

- (void)setLabel:(UILabel *)label withTitle:(NSString *)title font:(UIFont *)font{
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = title;
    [_mainScrollView addSubview:label];
}

- (void)setPrimaryPriceWithString:(NSString *)price {
    NSString *priceString = [NSString stringWithFormat:@"原价￥%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:13.f],NSFontAttributeName,
                                [UIColor blackColor],NSForegroundColorAttributeName,
                                [NSNumber numberWithInt:1],NSStrikethroughStyleAttributeName,
                                nil];
    [attrString addAttributes:normalAttr range:NSMakeRange(0, [attrString length])];
    _primaryPriceLabel.attributedText = attrString;
}

- (void)setPriceWithString:(NSString *)price {
    NSString *titleString = @"批购价格";
    if (_supplyType != SupplyGoodsWholesale) {
        titleString = @"价格";
    }
    NSString *priceString = [NSString stringWithFormat:@"%@￥%@",titleString,price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:13.f],NSFontAttributeName,
                                [UIColor blackColor],NSForegroundColorAttributeName,
                                nil];
    NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
                               kColor(255, 102, 36, 1),NSForegroundColorAttributeName,
                               nil];
    [attrString addAttributes:normalAttr range:NSMakeRange(0, [titleString length])];
    [attrString addAttributes:priceAttr range:NSMakeRange([titleString length], [attrString length] - [titleString length])];
    _actualPriceLabel.attributedText = attrString;
}


#pragma mark - Request

- (void)downloadGoodDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getGoodDetailWithCityID:delegate.cityID agentID:delegate.agentID goodID:_goodID supplyType:_supplyType finished:^(BOOL success, NSData *response) {
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
                    [self parseGoodDetailDateWithDictionary:object];
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

//切换支付通道
- (void)getChannelDetailWithChannelID:(NSString *)channelID {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getChannelDetailWithToken:delegate.token channelID:channelID finished:^(BOOL success, NSData *response) {
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
                    [self parseChannelDetailWithDictionary:object];
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

- (void)parseGoodDetailDateWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *detailDict = [dict objectForKey:@"result"];
    _detailModel = [[GoodDetailModel alloc] initWithParseDictionary:detailDict];
    [self initAndLayoutUI];
    [_topScorllView downloadImageWithURLs:_detailModel.goodImageList target:self action:@selector(touchPicture:) scaleImage:NO];
    self.totalPage = [_detailModel.goodImageList count];
    self.imagesScrollView.contentSize = CGSizeMake(self.totalPage * self.view.bounds.size.width, self.view.bounds.size.height);
}

//解析支付通道
- (void)parseChannelDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *channelDict = [dict objectForKey:@"result"];
    ChannelModel *newChannel = [[ChannelModel alloc] initWithParseDictionary:channelDict];
    newChannel.isAlreadyLoad = YES;
    NSInteger oldIndex = -1;
    for (ChannelModel *model in _detailModel.channelItem) {
        oldIndex++;
        if ([model.channelID isEqualToString:newChannel.channelID]) {
            break;
        }
    }
    [_detailModel.channelItem replaceObjectAtIndex:oldIndex withObject:newChannel];
    [self changeDefaultChannelWithChannel:newChannel];
}

//更换新的支付通道信息
- (void)changeDefaultChannelWithChannel:(ChannelModel *)newChannel {
    _detailModel.defaultChannel = newChannel;
    for (UIView *view in _mainScrollView.subviews) {
        if (![view isEqual:_topScorllView]) {
            [view removeFromSuperview];
        }
    }
    [self initSubViews];
}

#pragma mark - Action

- (IBAction)buyGood:(id)sender {
    NSLog(@"buy ");
    _buyButton.selected = YES;
    _rentButton.selected = NO;
    if (_supplyType == SupplyGoodsProcurement) {
        [_goOrderBtn setTitle:@"立即采购" forState:UIControlStateNormal];
    }
    [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.procurementPrice + _detailModel.defaultChannel.openCost]];
}

- (IBAction)rentGood:(id)sender {
    NSLog(@"rent");
    _buyButton.selected = NO;
    _rentButton.selected = YES;
    if (_supplyType == SupplyGoodsProcurement) {
        [_goOrderBtn setTitle:@"立即租赁" forState:UIControlStateNormal];
    }
    [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.deposit + _detailModel.defaultChannel.openCost]];
}

- (IBAction)goBuy:(id)sender {
    if (_supplyType == SupplyGoodsWholesale) {
        //批购
        WholesaleOrderController *orderC = [[WholesaleOrderController alloc] init];
        orderC.supplyType = _supplyType;
        orderC.confirmType = OrderConfirmTypeWholesale;
        orderC.goodDetail = _detailModel;
        [self.navigationController pushViewController:orderC animated:YES];
    }
    else {
        if (_buyButton.isSelected) {
            //代购买
            ProcurementBuyOrderController *orderC = [[ProcurementBuyOrderController alloc] init];
            orderC.supplyType = _supplyType;
            orderC.confirmType = OrderConfirmTypeProcurementBuy;
            orderC.goodDetail = _detailModel;
            [self.navigationController pushViewController:orderC animated:YES];
        }
        else {
            //代租赁
            ProcurementRentController *orderC = [[ProcurementRentController alloc] init];
            orderC.supplyType = _supplyType;
            orderC.confirmType = OrderConfirmTypeProcurementRent;
            orderC.goodDetail = _detailModel;
            [self.navigationController pushViewController:orderC animated:YES];
        }
    }
}

- (IBAction)jumpForWebsite:(id)sender {
    ChannelWebsiteController *websiteC = [[ChannelWebsiteController alloc] init];
    websiteC.title = @"支付通道";
    websiteC.urlString = _detailModel.defaultChannel.channelFactoryURL;
    [self.navigationController pushViewController:websiteC animated:YES];
}

- (IBAction)selectedChannel:(id)sender {
    GoodButton *btn = (GoodButton *)sender;
    btn.selected = YES;
    if ([_detailModel.defaultChannel.channelID isEqualToString:btn.ID]) {
        NSLog(@"!");
    }
    else {
        NSLog(@"~~~");
        ChannelModel *newModel = nil;
        for (ChannelModel *model in _detailModel.channelItem) {
            if ([model.channelID isEqualToString:btn.ID]) {
                newModel = model;
                break;
            }
        }
        if (newModel.isAlreadyLoad) {
            [self changeDefaultChannelWithChannel:newModel];
        }
        else {
            [self getChannelDetailWithChannelID:btn.ID];
        }
    }
}

- (IBAction)scanFactoryInfo:(id)sender {
    FactoryDetailController *factoryC = [[FactoryDetailController alloc] init];
    factoryC.goodDetail = _detailModel;
    [self.navigationController pushViewController:factoryC animated:YES];
}

- (IBAction)scanComment:(id)sender {
    CommentViewController *commentC = [[CommentViewController alloc] init];
    commentC.goodID = _detailModel.goodID;
    commentC.commentCount = _detailModel.goodComment;
    [self.navigationController pushViewController:commentC animated:YES];
}

- (IBAction)scanRate:(id)sender {
    TradeRateViewController *rateC = [[TradeRateViewController alloc] init];
    rateC.tradeRateItem = _detailModel.defaultChannel.dateRateItem;
    [self.navigationController pushViewController:rateC animated:YES];
}

- (IBAction)scanOpenInfo:(id)sender {
    OpenInfoViewController *openC = [[OpenInfoViewController alloc] init];
    openC.channelData = _detailModel.defaultChannel;
    [self.navigationController pushViewController:openC animated:YES];
}

- (IBAction)scanRent:(id)sender {
    RentDescriptionController *descC = [[RentDescriptionController alloc] init];
    descC.goodDetail = _detailModel;
    [self.navigationController pushViewController:descC animated:YES];
}

- (IBAction)scanGoodImage:(id)sender {
    GoodImageController *imageC = [[GoodImageController alloc] init];
    imageC.goodID = _goodID;
    [self.navigationController pushViewController:imageC animated:YES];
}

- (IBAction)selectedRelativeGood:(UITapGestureRecognizer *)sender {
    InterestView *view = (InterestView *)[sender view];
    GoodDetailController *detailC = [[GoodDetailController alloc] init];
    detailC.goodID = view.relativeGood.relativeID;
    detailC.supplyType = _supplyType;
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - 图片点击

- (IBAction)touchPicture:(UITapGestureRecognizer *)tap {
    [self.view bringSubviewToFront:self.scrollPanel];
    self.scrollPanel.alpha = 1.0;
    
    UIImageView *imageView = (UIImageView *)[tap view];
    self.currentIndex = imageView.tag;
    
    CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
    CGPoint contentOffset = self.imagesScrollView.contentOffset;
    contentOffset.x = (self.currentIndex - 1) * self.view.bounds.size.width;
    self.imagesScrollView.contentOffset = contentOffset;
    
    [self addImageScrollViewForController:self];
    
    ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:(CGRect){contentOffset,self.imagesScrollView.bounds.size}];
    [imagescroll setContentWithFrame:convertRect];
    [imagescroll setImage:imageView.image];
    [self.imagesScrollView addSubview:imagescroll];
    imagescroll.tapDelegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:imagescroll afterDelay:0.1f];
}

#pragma mark - 大图

- (void)addImageScrollViewForController:(UIViewController *)controller {
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 1; i <= self.totalPage; i++) {
        if (i == self.currentIndex) {
            continue;
        }
        UIImageView *imageView = (UIImageView *)[_topScorllView viewWithTag:i];
        CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
        ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:(CGRect){(i - 1) * self.imagesScrollView.bounds.size.width,0,self.imagesScrollView.bounds.size}];
        [imagescroll setContentWithFrame:convertRect];
        [imagescroll setImage:imageView.image];
        [self.imagesScrollView addSubview:imagescroll];
        imagescroll.tapDelegate = (id<ImageScrollViewDelegate>)controller;
        [imagescroll setAnimationRect];
    }
}

- (void)setOriginFrame:(ImageScrollView *)sender {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex,self.totalPage];
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.navigationBarHidden = YES;
        [sender setAnimationRect];
        self.markView.alpha = 1.0;
    }];
}

#pragma mark - ImageScrollViewDelegate

- (void)tapImageViewWithObject:(ImageScrollView *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.markView.alpha = 0;
        [sender rechangeInitRdct];
    } completion:^(BOOL finished) {
        self.scrollPanel.alpha = 0;
    }];
}

#pragma mark - scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _imagesScrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1,_totalPage];
    }
}


@end
