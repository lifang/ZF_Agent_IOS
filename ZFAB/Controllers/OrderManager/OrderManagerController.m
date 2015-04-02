//
//  OrderManagerController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderManagerController.h"
#import "NetworkInterface.h"
#import "KxMenu.h"

@interface OrderManagerController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, assign) SupplyGoodsType supplyType; //批购还是代购订单

@property (nonatomic, assign) OrderStatus currentStatus;  //筛选的订单状态
@property (nonatomic, assign) OrderType currentType;      //筛选的订单类型

@property (nonatomic, strong) UIButton *typeButton;   //订单类型
@property (nonatomic, strong) UIButton *statusButton; //订单状态

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation OrderManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单管理";
    [self initAndLayoutUI];
    self.supplyType = SupplyGoodsWholesale;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0];
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"批购订单",
                          @"代购订单",
                          nil];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:nameArray];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = kMainColor;
    [_segmentControl addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
                              nil];
    [_segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    
    //控件初始化
    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(10, 0, 110, 30);
    _typeButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_typeButton setTitle:@"选择订单类型" forState:UIControlStateNormal];
    [_typeButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(showOrderType:) forControlEvents:UIControlEventTouchUpInside];
    _typeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
    _typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(10, 0, 110, 30);
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusButton setTitle:@"选择订单状态" forState:UIControlStateNormal];
    [_statusButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(showOrderStatus:) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
    _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.font = [UIFont systemFontOfSize:13.f];
    _typeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderType:)];
    [_typeLabel addGestureRecognizer:typeTap];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:13.f];
    _statusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *statusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderStatus:)];
    [_statusLabel addGestureRecognizer:statusTap];
}

- (void)setHeaderAndFooterView {
    CGFloat headerHeight = 85.f;
    if (_supplyType == SupplyGoodsProcurement) {
        headerHeight = 120.f;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    CGFloat h_space = 20.f;
    CGFloat v_space = 10.f;
    _segmentControl.frame = CGRectMake(h_space, v_space, kScreenWidth - h_space * 2, 30);
    [headerView addSubview:_segmentControl];
    
    if (_supplyType == SupplyGoodsWholesale) {
        UIView *statusBackView = [self getHeaderBackView];
        CGRect rect = statusBackView.frame;
        rect.origin.y = 50.f;
        statusBackView.frame = rect;
        [headerView addSubview:statusBackView];
        
        _statusButton.frame = CGRectMake(10, 0, 110, 30);
        CGFloat originX = _statusButton.frame.origin.x + _statusButton.frame.size.width + 10;
        _statusLabel.frame = CGRectMake(originX, 0, kScreenWidth - originX, 30);
        [statusBackView addSubview:_statusButton];
        [statusBackView addSubview:_statusLabel];
    }
    else if (_supplyType == SupplyGoodsProcurement) {
        UIView *typeBackView = [self getHeaderBackView];
        CGRect rect = typeBackView.frame;
        rect.origin.y = 50.f;
        typeBackView.frame = rect;
        [headerView addSubview:typeBackView];
        
        _typeLabel.frame = CGRectMake(10, 0, 110, 30);
        CGFloat originX = _typeLabel.frame.origin.x + _typeLabel.frame.size.width + 10;
        _typeLabel.frame = CGRectMake(originX, 0, kScreenWidth - originX, 30);
        [typeBackView addSubview:_typeButton];
        [typeBackView addSubview:_typeLabel];
        
        UIView *statusBackView = [self getHeaderBackView];
        rect = statusBackView.frame;
        rect.origin.y = typeBackView.frame.origin.y + typeBackView.frame.size.height + 5;
        statusBackView.frame = rect;
        [headerView addSubview:statusBackView];
        
        _statusButton.frame = CGRectMake(10, 0, 110, 30);
        _statusLabel.frame = CGRectMake(originX, 0, kScreenWidth - originX, 30);
        [statusBackView addSubview:_statusButton];
        [statusBackView addSubview:_statusLabel];
    }
}

- (UIView *)getHeaderBackView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:firstLine];
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30 - kLineHeight, kScreenWidth, kLineHeight)];
    secondLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:secondLine];
    return backView;
}

#pragma mark - Set

- (void)setSupplyType:(SupplyGoodsType)supplyType {
    _supplyType = supplyType;
    self.currentStatus = OrderStatusAll;
    self.currentType = OrderTypeAll;
    [self setHeaderAndFooterView];
    [self firstLoadData];
    NSLog(@"orderManager %d load data",supplyType);
}

- (void)setCurrentStatus:(OrderStatus)currentStatus {
    _currentStatus = currentStatus;
    _statusLabel.text = [self stringForOrderStatus:_currentStatus];
}

- (void)setCurrentType:(OrderType)currentType {
    _currentType = currentType;
    _typeLabel.text = [self stringForOrderType:_currentType];
}

#pragma mark - Request

- (void)firstLoadData {
    
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    
}

#pragma mark - Data

- (NSString *)stringForOrderStatus:(OrderStatus)status {
    NSString *title = nil;
    switch (status) {
        case OrderStatusAll:
            title = @"全部";
            break;
        case OrderStatusUnPaid:
            title = @"未付款";
            break;
        case OrderStatusPaid:
            title = @"已付款";
            break;
        case OrderStatusSend:
            title = @"已发货";
            break;
        case OrderStatusReview:
            title = @"已评价";
            break;
        case OrderStatusCancel:
            title = @"已取消";
            break;
        case OrderStatusClosed:
            title = @"交易关闭";
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)stringForOrderType:(OrderType)type {
    NSString *title = nil;
    switch (type) {
        case OrderTypeAll:
            title = @"全部";
            break;
        case OrderTypeUserBuy:
            title = @"用户购买";
            break;
        case OrderTypeUserRent:
            title = @"用户租赁";
            break;
        case OrderTypeAgentProcurement:
            title = @"代理商代购";
            break;
        case OrderTypeAgentRent:
            title = @"代理商代租赁";
            break;
        case OrderTypeWholesale:
            title = @"代理商批购";
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    self.supplyType = (SupplyGoodsType)([_segmentControl selectedSegmentIndex] + 1);
}

- (IBAction)showOrderType:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeAll]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeAll],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeUserBuy]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeUserBuy],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeUserRent]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeUserRent],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeAgentProcurement]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeAgentProcurement],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeAgentRent]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeAgentRent],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeWholesale]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeWholesale],
                                 nil];
    
    CGRect convertRect = [_typeButton convertRect:_typeButton.frame toView:self.view];
    CGRect rect = CGRectMake(_typeButton.frame.origin.x + _typeButton.frame.size.width / 2, convertRect.origin.y + convertRect.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)showOrderStatus:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderStatus:OrderStatusAll]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderStatusAll],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:OrderStatusUnPaid]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderStatusUnPaid],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:OrderStatusPaid]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderStatusPaid],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:OrderStatusSend]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderStatusSend],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:OrderStatusReview]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderStatusReview],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:OrderStatusCancel]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderStatusCancel],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:OrderStatusClosed]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderStatusClosed],
                                 nil];
    CGRect convertRect = [_statusButton convertRect:_statusButton.frame toView:self.view];
    CGRect rect = CGRectMake(_statusButton.frame.origin.x + _statusButton.frame.size.width / 2, convertRect.origin.y + convertRect.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectStatus:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentStatus = (OrderStatus)item.tag;
    NSLog(@"status %d load data",self.currentStatus);
    [self firstLoadData];
}

- (IBAction)selectType:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentType = (OrderType)item.tag;
    NSLog(@"type %d load data",self.currentType);
    [self firstLoadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"123";
    return cell;
}

@end
