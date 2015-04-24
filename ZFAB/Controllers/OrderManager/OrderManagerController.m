//
//  OrderManagerController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderManagerController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "OrderModel.h"
#import "OrderCell.h"
#import "KxMenu.h"
#import "OrderDetailController.h"
#import "GoodListController.h"
#import "PayWayViewController.h"
#import "GoodDetailController.h"
#import "RegularFormat.h"

@interface OrderManagerController ()<OrderCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, assign) SupplyGoodsType supplyType; //批购还是代购订单

@property (nonatomic, assign) int currentStatus;  //筛选的订单状态
@property (nonatomic, assign) OrderType currentType;      //筛选的订单类型

@property (nonatomic, strong) UIButton *typeButton;   //订单类型
@property (nonatomic, strong) UIButton *statusButton; //订单状态

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSMutableArray *orderItem;

@property (nonatomic, strong) OrderModel *selectedOrder;

@end

@implementation OrderManagerController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单管理";
    _orderItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    self.supplyType = SupplyGoodsWholesale;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshOrderList:)
                                                 name:RefreshOrderListNotification
                                               object:nil];
    self.historyType = HistoryTypeOrder;
    [self initNavigationBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initNavigationBarView {
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 24, 24);
    [deleteButton setBackgroundImage:kImageName(@"cart.png") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(goGood:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 24, 24);
    [addButton setBackgroundImage:kImageName(@"good_search.png") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -5;
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,deleteItem,addItem, nil];
}


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
    if (supplyType == SupplyGoodsProcurement) {
        self.currentStatus = ProcurementStatusAll;
        self.currentType = OrderTypeProcurement;
    }
    else {
        self.currentStatus = WholesaleStatusAll;
        self.currentType = OrderTypeWholesale;
    }
    [self setHeaderAndFooterView];
    [self firstLoadData];
}

- (void)setCurrentStatus:(int)currentStatus {
    _currentStatus = currentStatus;
    _statusLabel.text = [self stringForOrderStatus:_currentStatus];
}

- (void)setCurrentType:(OrderType)currentType {
    _currentType = currentType;
    _typeLabel.text = [self stringForOrderType:_currentType];
}

#pragma mark - Request

- (void)firstLoadData {
    NSString *type = nil;
    if (_currentType == OrderTypeProcurement) {
        type = @"代购所有类型";
    }
    else if (_currentType == OrderTypeProcurementBuy) {
        type = @"代购买类型";
    }
    else if (_currentType == OrderTypeProcurementRent) {
        type = @"代租赁类型";
    }
    else {
        type = @"批购类型";
    }
    NSLog(@"%@加载状态%d订单",type,_currentStatus);
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getOrderListWithAgentUserID:delegate.agentUserID token:delegate.token orderType:_currentType keyword:self.searchInfo status:_currentStatus page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_orderItem removeAllObjects];
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
                    [self parseOrderListWithDictionary:object];
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

//取消批购订单
- (void)cancelWholesaleOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelWholesaleOrderWithToken:delegate.token orderID:_selectedOrder.orderID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];
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

//取消代购订单
- (void)cancelProcurementOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelProcurementOrderWithToken:delegate.token orderID:_selectedOrder.orderID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];
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

- (void)parseOrderListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id orderList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([orderList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [orderList count]; i++) {
            id orderDict = [orderList objectAtIndex:i];
            if ([orderDict isKindOfClass:[NSDictionary class]]) {
                OrderModel *model = [[OrderModel alloc] initWithParseDictionary:orderDict];
                [_orderItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

- (NSString *)stringForOrderStatus:(int)status {
    NSString *title = nil;
    if (_supplyType == SupplyGoodsProcurement) {
        //代购
        switch (status) {
            case ProcurementStatusAll:
                title = @"全部";
                break;
            case ProcurementStatusUnPaid:
                title = @"未付款";
                break;
            case ProcurementStatusPaid:
                title = @"已付款";
                break;
            case ProcurementStatusSend:
                title = @"已发货";
                break;
            case ProcurementStatusReview:
                title = @"已评价";
                break;
            case ProcurementStatusCancel:
                title = @"已取消";
                break;
            case ProcurementStatusClosed:
                title = @"交易关闭";
                break;
            default:
                break;
        }
    }
    else {
        //批购
        switch (status) {
            case WholesaleStatusAll:
                title = @"全部";
                break;
            case WholesaleStatusUnPaid:
                title = @"未付款";
                break;
            case WholesaleStatusPartPaid:
                title = @"已付定金";
                break;
            case WholesaleStatusFinish:
                title = @"已完成";
                break;
            case WholesaleStatusCancel:
                title = @"已取消";
                break;
            default:
                break;
        }
    }
    return title;
}

- (NSString *)stringForOrderType:(OrderType)type {
    NSString *title = nil;
    switch (type) {
        case OrderTypeProcurement:
            title = @"全部";
            break;
        case OrderTypeProcurementBuy:
            title = @"代购买";
            break;
        case OrderTypeProcurementRent:
            title = @"代租赁";
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - Action

- (IBAction)goGood:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if (_supplyType == SupplyGoodsWholesale &&
        ![[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthWholesale]] boolValue]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有批购权限";
    }
    else if (_supplyType == SupplyGoodsProcurement &&
             ![[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthProcurement]] boolValue]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有代购权限";
    }
    else {
        GoodListController *listC = [[GoodListController alloc] init];
        listC.supplyType = _supplyType;
        [self.navigationController pushViewController:listC animated:YES];
    }
}

- (IBAction)typeChanged:(id)sender {
    self.supplyType = (SupplyGoodsType)([_segmentControl selectedSegmentIndex] + 1);
}

- (IBAction)showOrderType:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeProcurement]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_typeLabel.text
                                                  tag:OrderTypeProcurement],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeProcurementBuy]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_typeLabel.text
                                                  tag:OrderTypeProcurementBuy],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeProcurementRent]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_typeLabel.text
                                                  tag:OrderTypeProcurementRent],
                                 nil];
    
    CGRect convertRect = [_typeButton convertRect:_typeButton.frame toView:self.view];
    CGRect rect = CGRectMake(_typeButton.frame.origin.x + _typeButton.frame.size.width / 2, convertRect.origin.y + convertRect.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)showOrderStatus:(id)sender {
    NSMutableArray *listArray = nil;
    if (_supplyType == SupplyGoodsProcurement) {
        listArray = [NSMutableArray arrayWithObjects:
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusAll]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.text
                                      tag:ProcurementStatusAll],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusUnPaid]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.text
                                      tag:ProcurementStatusUnPaid],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusPaid]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.text
                                      tag:ProcurementStatusPaid],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusSend]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.text
                                      tag:ProcurementStatusSend],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusCancel]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.text
                                      tag:ProcurementStatusCancel],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusClosed]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.text
                                      tag:ProcurementStatusClosed],
                     nil];
    }
    else {
        listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusAll]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:WholesaleStatusAll],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusUnPaid]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:WholesaleStatusUnPaid],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusPartPaid]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:WholesaleStatusPartPaid],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusFinish]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:WholesaleStatusFinish],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusCancel]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:WholesaleStatusCancel],
                                 nil];

    }
    CGRect convertRect = [_statusButton convertRect:_statusButton.frame toView:self.view];
    CGRect rect = CGRectMake(_statusButton.frame.origin.x + _statusButton.frame.size.width / 2, convertRect.origin.y + convertRect.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectStatus:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentStatus = (int)item.tag;
    [self firstLoadData];
}

- (IBAction)selectType:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentType = (OrderType)item.tag;
    [self firstLoadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_orderItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = [_orderItem objectAtIndex:indexPath.section];
    NSString *identifier = [model getCellIdentifierWithSupplyType:_supplyType];
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell =[[ OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier supplyType:_supplyType];
    }
    cell.delegate = self;
    [cell setContentsWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = [_orderItem objectAtIndex:indexPath.section];
    OrderDetailController *detailC = [[OrderDetailController alloc] init];
    detailC.supplyType = _supplyType;
    detailC.orderID = model.orderID;
    detailC.goodID = model.orderGood.goodID;
    detailC.goodName = model.orderGood.goodName;
    detailC.fromType = PayWayFromNone;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = [_orderItem objectAtIndex:indexPath.section];
    NSString *identifier = [model getCellIdentifierWithSupplyType:_supplyType];
    if ([identifier isEqualToString:wholesaleCancelIdentifier]) {
        return kOrderShortCellHeight + kFlexibleHeight;
    }
    else if ([identifier isEqualToString:wholesaleDepositIdentifier] ||
             [identifier isEqualToString:wholesaleFinishIdentifier] ||
             [identifier isEqualToString:wholesaleUnpaidIdentifier]) {
        return kOrderLongCellHeight + kFlexibleHeight;
    }
    else if ([identifier isEqualToString:procurementThirdIdentifier]) {
        return kOrderShortCellHeight;
    }
    else if ([identifier isEqualToString:procurementFirstIdentifier] ||
             [identifier isEqualToString:procurementSecondIdentifier]) {
        return kOrderLongCellHeight;
    }
    //下面两种情况防止返回订单状态为其他枚举值
    else if (_supplyType == SupplyGoodsWholesale) {
        return kOrderShortCellHeight + kFlexibleHeight;
    }
    return kOrderShortCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - CellDelegate

//批购
- (void)orderCellCancelWholesaleOrder:(OrderModel *)model {
    _selectedOrder = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = AlertTagCancel;
    [alert show];
}

- (void)orderCellPayWholesaleOrder:(OrderModel *)model {
    _selectedOrder = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"填写付款金额"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = AlertTagPayMoney;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)orderCellPayDepositOrder:(OrderModel *)model {
    PayWayViewController *payC = [[PayWayViewController alloc] init];
    payC.orderID = model.orderID;
    payC.totalPrice = model.totalDeposit;
    payC.fromType = PayWayFromOrderWholesale;
    payC.goodID = model.orderGood.goodID;
    payC.goodName = model.orderGood.goodName;
    [self.navigationController pushViewController:payC animated:YES];
}

- (void)orderCellWholesaleRepeat:(OrderModel *)model {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthWholesale]] boolValue]) {
        GoodDetailController *detailC = [[GoodDetailController alloc] init];
        detailC.supplyType = SupplyGoodsWholesale;
        detailC.goodID = model.orderGood.goodID;
        [self.navigationController pushViewController:detailC animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有批购权限";
    }
}

//代购
- (void)orderCellCancelProcurementOrder:(OrderModel *)model {
    _selectedOrder = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = AlertTagCancel;
    [alert show];
}

- (void)orderCellPayProcurementOrder:(OrderModel *)model {
    PayWayViewController *payC = [[PayWayViewController alloc] init];
    payC.orderID = model.orderID;
    payC.totalPrice = model.actualMoney;
    payC.fromType = PayWayFromOrderProcurement;
    payC.goodID = model.orderGood.goodID;
    payC.goodName = model.orderGood.goodName;
    [self.navigationController pushViewController:payC animated:YES];
}

- (void)orderCellProcurementRepeat:(OrderModel *)model {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthProcurement]] boolValue]) {
        GoodDetailController *detailC = [[GoodDetailController alloc] init];
        detailC.supplyType = SupplyGoodsProcurement;
        detailC.goodID = model.orderGood.goodID;
        [self.navigationController pushViewController:detailC animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有代购权限";
    }
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == AlertTagCancel) {
            //取消订单
            if (_supplyType == SupplyGoodsWholesale) {
                //批购
                [self cancelWholesaleOrder];
            }
            else {
                //代购
                [self cancelProcurementOrder];
            }
        }
        else if (alertView.tag == AlertTagPayMoney) {
            //支付
            UITextField *textField = [alertView textFieldAtIndex:0];
            if (![RegularFormat isFloat:textField.text]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"请输入数字";
                return;
            }
            if ([textField.text floatValue] <= 0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"输入金额必须大于0";
                return;
            }
            if ([textField.text floatValue] > _selectedOrder.totalMoney) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"金额必须小于付款金额";
                return;
            }
            PayWayViewController *payC = [[PayWayViewController alloc] init];
            payC.orderID = _selectedOrder.orderID;
            payC.totalPrice = [textField.text floatValue];
            payC.fromType = PayWayFromOrderWholesale;
            payC.goodID = _selectedOrder.orderGood.goodID;
            payC.goodName = _selectedOrder.orderGood.goodName;
            payC.isPayPartMoney = YES;  //部分付款
            [self.navigationController pushViewController:payC animated:YES];
        }
    }
}

#pragma mark - NSNotification

- (void)refreshOrderList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - 搜索

- (void)getSearchKeyword:(NSString *)keyword {
    self.searchInfo = keyword;
    [self firstLoadData];
}

@end
