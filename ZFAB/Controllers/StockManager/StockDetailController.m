//
//  StockDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StockDetailController.h"
#import "UIImageView+WebCache.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "StockAgentCell.h"
#import "StockTerminalController.h"
#import "StockRenameController.h"

@interface StockDetailController ()<UISearchBarDelegate>

/*header view 控件*/
@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

@property (nonatomic, strong) UILabel *historyCountLabel;

@property (nonatomic, strong) UILabel *openCountLabel;

@property (nonatomic, strong) UILabel *agentCountLabel;

@property (nonatomic, strong) UILabel *totalCountLabel;

@property (nonatomic, strong) UIButton *nameButton;
/*******/

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) NSString *searchAgentName; //搜索的代理商名

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation StockDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"库存详情";
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
    [self setDataForUI];
}

- (void)setHeaderAndFooterView {
    [self setHeaderView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)setHeaderView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 192)];
    self.tableView.tableHeaderView = backgroundView;
    UIView *stockView = [self addStockDetailViewForView:backgroundView];
    //分类标题
    UIView *columnView = [[UIView alloc] init];
    columnView.translatesAutoresizingMaskIntoConstraints = NO;
    columnView.backgroundColor = kColor(218, 217, 217, 1);
    [backgroundView addSubview:columnView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:columnView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:columnView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:stockView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:columnView
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:columnView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:0.0
                                                            constant:40.f]];
    [self addTitleViewForView:columnView];
}

//头部库存商品信息
- (UIView *)addStockDetailViewForView:(UIView *)backgroundView {
    UIView *headerView = [[UIView alloc] init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    headerView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:headerView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:152]];
    
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
    [headerView addSubview:_pictureView];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:topSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:0.0
                                                            constant:pictureSize]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
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
    [headerView addSubview:_titleLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_pictureView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:hSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:topSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:-rightSpace - btnWidth]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
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
    [headerView addSubview:_brandLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_pictureView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:hSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_titleLabel
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:10.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:-rightSpace - btnWidth]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
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
    [headerView addSubview:_channelLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_pictureView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:hSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_brandLabel
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:vSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:-rightSpace - btnWidth]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:0.0
                                                            constant:20.f]];
//    _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _nameButton.translatesAutoresizingMaskIntoConstraints = NO;
//    _nameButton.layer.cornerRadius = 4;
//    _nameButton.layer.masksToBounds = YES;
//    _nameButton.layer.borderWidth = 1.f;
//    _nameButton.layer.borderColor = kMainColor.CGColor;
//    [_nameButton setTitleColor:kMainColor forState:UIControlStateNormal];
//    [_nameButton setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
//    _nameButton.titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
//    [_nameButton setTitle:@"商品更名" forState:UIControlStateNormal];
//    [_nameButton addTarget:self action:@selector(changeName:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:_nameButton];
//    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                           attribute:NSLayoutAttributeRight
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:headerView
//                                                           attribute:NSLayoutAttributeRight
//                                                          multiplier:1.0
//                                                            constant:-rightSpace]];
//    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                           attribute:NSLayoutAttributeTop
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:headerView
//                                                           attribute:NSLayoutAttributeTop
//                                                          multiplier:1.0
//                                                            constant:topSpace]];
//    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                           attribute:NSLayoutAttributeWidth
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:nil
//                                                           attribute:NSLayoutAttributeNotAnAttribute
//                                                          multiplier:1.0
//                                                            constant:btnWidth]];
//    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_nameButton
//                                                           attribute:NSLayoutAttributeHeight
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:nil
//                                                           attribute:NSLayoutAttributeNotAnAttribute
//                                                          multiplier:0.0
//                                                            constant:24.f]];
    
    CGFloat backHeight = 42.f;
    UIImageView *backView = [[UIImageView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.image = [kImageName(@"cellback.png") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [headerView addSubview:backView];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_pictureView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:20.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:0.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:backView
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
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:backView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:backView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:backView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
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
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:backView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:-kLineHeight]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:backView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:backView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
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
    return headerView;
}

//中间栏目标题
- (void)addTitleViewForView:(UIView *)backgroundView {
    CGFloat leftSpace = 10.f;
    CGFloat topSpace = 5.f;
    CGFloat btnWidth = 20.f;
    
    _searchButton = [[UIButton alloc] init];
    _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchButton setImage:kImageName(@"stocksearch.png") forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(showSearch:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:_searchButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backgroundView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backgroundView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace + 5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:btnWidth]];
    //下级代理商
    UILabel *agentNameLabel = [[UILabel alloc] init];
    agentNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    agentNameLabel.backgroundColor = [UIColor clearColor];
    agentNameLabel.font = [UIFont systemFontOfSize:13.f];
//    agentNameLabel.textAlignment = NSTextAlignmentCenter;
    agentNameLabel.text = @"下级代理商";
    [backgroundView addSubview:agentNameLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agentNameLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backgroundView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace + btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agentNameLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backgroundView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agentNameLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.4
                                                           constant:-btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agentNameLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:30.f]];
    //配货
    UILabel *prepareLabel = [[UILabel alloc] init];
    prepareLabel.translatesAutoresizingMaskIntoConstraints = NO;
    prepareLabel.backgroundColor = [UIColor clearColor];
    prepareLabel.font = [UIFont systemFontOfSize:13.f];
    prepareLabel.textAlignment = NSTextAlignmentCenter;
    prepareLabel.text = @"配货总量";
    [backgroundView addSubview:prepareLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:prepareLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:agentNameLabel
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:prepareLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:backgroundView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:prepareLabel
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:0.3
                                                                constant:-leftSpace * 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:prepareLabel
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:0.0
                                                                constant:30.f]];
    //已开通量
    UILabel *openLabel = [[UILabel alloc] init];
    openLabel.translatesAutoresizingMaskIntoConstraints = NO;
    openLabel.backgroundColor = [UIColor clearColor];
    openLabel.font = [UIFont systemFontOfSize:13.f];
    openLabel.textAlignment = NSTextAlignmentCenter;
    openLabel.text = @"已开通量";
    [backgroundView addSubview:openLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:prepareLabel
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:backgroundView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openLabel
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:0.3
                                                                constant:-leftSpace * 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openLabel
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:0.0
                                                                constant:30.f]];
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    _searchBar.enablesReturnKeyAutomatically = NO;
    _searchBar.placeholder = @"代理商名称";
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.backgroundColor = [UIColor blackColor];
    _searchBar.hidden = YES;
    [backgroundView addSubview:_searchBar];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:backgroundView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.f]];
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

#pragma mark - Set

- (void)setSearchAgentName:(NSString *)searchAgentName {
    _searchAgentName = searchAgentName;
    [self firstLoadData];
}

#pragma mark - Data

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

- (void)setDataForUI {
    _titleLabel.text = _stockModel.stockTitle;
    NSString *brandString = [NSString stringWithFormat:@"品牌型号   %@%@",_stockModel.stockGoodBrand,_stockModel.stockGoodModel];
    _brandLabel.attributedText = [self attrStringWithString:brandString];
    NSString *channelString = [NSString stringWithFormat:@"支付平台   %@",_stockModel.stockChannel];
    _channelLabel.attributedText = [self attrStringWithString:channelString];
    _historyCountLabel.text = [NSString stringWithFormat:@"%d件",_stockModel.historyCount];
    _openCountLabel.text = [NSString stringWithFormat:@"%d件",_stockModel.openCount];
    _agentCountLabel.text = [NSString stringWithFormat:@"%d件",_stockModel.agentCount];
    _totalCountLabel.text = [NSString stringWithFormat:@"%d件",_stockModel.totalCount];
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:_stockModel.stockImagePath]];
}

- (void)parseStockDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id agentList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([agentList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [agentList count]; i++) {
            id agentDict = [agentList objectAtIndex:i];
            StockAgentModel *model = [[StockAgentModel alloc] initWithParseDictionary:agentDict];
            [_dataItem addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Request

- (void)firstLoadData {
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getStockDetailWithAgentID:delegate.agentID token:delegate.token channelID:_stockModel.stockChannelID goodID:_stockModel.stockGoodID agentName:_searchAgentName page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_dataItem removeAllObjects];
                    }
                    id list = nil;
                    if ([[object objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                        list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    }
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseStockDetailWithDictionary:object];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}


#pragma mark - Action 

- (IBAction)changeName:(id)sender {
    StockRenameController *renameC = [[StockRenameController alloc] init];
    renameC.stockModel = _stockModel;
    [self.navigationController pushViewController:renameC animated:YES];
}

- (IBAction)showSearch:(id)sender {
    _searchBar.hidden = NO;
    [_searchBar becomeFirstResponder];
}

#pragma mark - UITabelView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *stockAgentIdentifier = @"stockAgentIdentifier";
    StockAgentCell *cell = [tableView dequeueReusableCellWithIdentifier:stockAgentIdentifier];
    if (cell == nil) {
        cell = [[StockAgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stockAgentIdentifier];
    }
    StockAgentModel *model = [_dataItem objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kStockAgentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StockAgentModel *model = [_dataItem objectAtIndex:indexPath.row];
    StockTerminalController *terminalC = [[StockTerminalController alloc] init];
    terminalC.stockModel = _stockModel;
    terminalC.stockAgent = model;
    [self.navigationController pushViewController:terminalC animated:YES];
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    _searchBar.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    _searchBar.hidden = YES;
    self.searchAgentName = _searchBar.text;
}

@end
