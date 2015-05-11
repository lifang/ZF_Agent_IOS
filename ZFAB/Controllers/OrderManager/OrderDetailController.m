//
//  OrderDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailController.h"
#import "AppDelegate.h"
#import "OrderDetailModel.h"
#import "RecordView.h"
#import "StringFormat.h"
#import "OrderDetailCell.h"
#import "OrderManagerController.h"
#import "RegularFormat.h"
#import "GoodDetailController.h"
#import "GoodListController.h"
#import "OrderTerminalListController.h"

typedef enum {
    OrderDetailBtnStyleFirst = 1,
    OrderDetailBtnStyleSecond,
}OrderDetailBtnStyle; //按钮样式

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OrderDetailModel *orderDetail;

@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_supplyType == SupplyGoodsWholesale) {
        self.title = @"批购订单详情";
    }
    else {
        self.title = @"采购订单详情";
    }
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self downloadDetail];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"back.png")
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(goPervious:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    //追踪记录
    if ([_orderDetail.recordList count] > 0) {
        CGFloat leftSpace = 20.f;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 20, kScreenWidth - leftSpace * 2 , 14)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"追踪记录：";
        RecordView *recordView = [[RecordView alloc] initWithRecords:_orderDetail.recordList
                                                               width:(kScreenWidth - leftSpace * 2)];
        CGFloat recordHeight = [recordView getHeight];
        recordView.frame = CGRectMake(leftSpace, 34, kScreenWidth - leftSpace * 2, recordHeight);
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, recordHeight + 40)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:tipLabel];
        [footerView addSubview:recordView];
        _tableView.tableFooterView = footerView;
        [recordView initAndLayoutUI];
    }
}

- (void)footerViewAddSubview {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = kColor(135, 135, 135, 1);
    [_detailFooterView addSubview:line];
    CGFloat middleSpace = 10.f;
    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
    CGFloat btnHeight = 36.f;
    if (_supplyType == SupplyGoodsWholesale) {
        //批购
        if (_orderDetail.orderStatus == WholesaleStatusUnPaid) {
            //未付款
            if (_orderDetail.payStatus == DepositPaid) {
                //已付定金
                UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesaleOrder:) style:OrderDetailBtnStyleFirst];
                cancelBtn.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
                UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payWholesaleOrder:) style:OrderDetailBtnStyleSecond];
                payBtn.frame = CGRectMake(btnWidth + 3 * middleSpace, 12, btnWidth, btnHeight);
                [_detailFooterView addSubview:cancelBtn];
                [_detailFooterView addSubview:payBtn];
                
            }
            else {
                //未付定金
                UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesaleOrder:) style:OrderDetailBtnStyleFirst];
                cancelBtn.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
                UIButton *depositBtn = [self buttonWithTitle:@"支付定金" action:@selector(payDeposit:) style:OrderDetailBtnStyleSecond];
                depositBtn.frame = CGRectMake(btnWidth + 3 * middleSpace, 12, btnWidth, btnHeight);
                [_detailFooterView addSubview:cancelBtn];
                [_detailFooterView addSubview:depositBtn];
            }
        }
//        else if (_orderDetail.orderStatus == WholesaleStatusPartPaid) {
//            //已付定金
//            UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesaleOrder:) style:OrderDetailBtnStyleFirst];
//            cancelBtn.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
//            UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payWholesaleOrder:) style:OrderDetailBtnStyleSecond];
//            payBtn.frame = CGRectMake(btnWidth + 3 * middleSpace, 12, btnWidth, btnHeight);
//            [_detailFooterView addSubview:cancelBtn];
//            [_detailFooterView addSubview:payBtn];
//        }
        else if (_orderDetail.orderStatus == WholesaleStatusFinish) {
            //再次批购
            UIButton *repeatBtn = [self buttonWithTitle:@"再次批购" action:@selector(repeatWholesale:) style:OrderDetailBtnStyleSecond];
            repeatBtn.frame = CGRectMake(middleSpace, 12, kScreenWidth - 2 * middleSpace, btnHeight);
            [_detailFooterView addSubview:repeatBtn];
        }
    }
    else {
        //代购
        if (_orderDetail.orderStatus == ProcurementStatusUnPaid) {
            //未付款
            UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelProcurementOrder:) style:OrderDetailBtnStyleFirst];
            cancelBtn.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
            UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payProcurementOrder:) style:OrderDetailBtnStyleSecond];
            payBtn.frame = CGRectMake(btnWidth + 3 * middleSpace, 12, btnWidth, btnHeight);
            [_detailFooterView addSubview:cancelBtn];
            [_detailFooterView addSubview:payBtn];
        }
        else if (_orderDetail.orderStatus == ProcurementStatusSend ||
                 _orderDetail.orderStatus == ProcurementStatusCancel ||
                 _orderDetail.orderStatus == ProcurementStatusClosed) {
            //再次批购
            UIButton *repeatBtn = [self buttonWithTitle:@"再次采购" action:@selector(repeatProcurement:) style:OrderDetailBtnStyleSecond];
            repeatBtn.frame = CGRectMake(middleSpace, 12, kScreenWidth - 2 * middleSpace, btnHeight);
            [_detailFooterView addSubview:repeatBtn];
        }
    }
}

- (void)initAndLayoutUI {
    CGFloat footerHeight = 0.f;
    if ((_supplyType == SupplyGoodsWholesale && (_orderDetail.orderStatus == WholesaleStatusUnPaid  ||
                                                 _orderDetail.orderStatus == WholesaleStatusFinish)) ||
        (_supplyType == SupplyGoodsProcurement && (_orderDetail.orderStatus == ProcurementStatusUnPaid ||
                                                   _orderDetail.orderStatus == ProcurementStatusSend ||
                                                   _orderDetail.orderStatus == ProcurementStatusCancel ||
                                                   _orderDetail.orderStatus == ProcurementStatusClosed))) {
        footerHeight = 60.f;
        //底部按钮
        _detailFooterView = [[UIView alloc] init];
        _detailFooterView.translatesAutoresizingMaskIntoConstraints = NO;
        _detailFooterView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_detailFooterView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:-footerHeight]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0]];
        [self footerViewAddSubview];
        
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    if (kDeviceVersion >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-footerHeight]];
}

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action
                        style:(OrderDetailBtnStyle)style {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    if (style == OrderDetailBtnStyleFirst) {
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = kMainColor.CGColor;
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    }
    else {
        [button setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setLabel:(UILabel *)label withString:(NSString *)string {
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.text = string;
}

#pragma mark - Request

- (void)downloadDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getOrderDetailWithToken:delegate.token orderType:_supplyType orderID:_orderID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseOrderDetailWithDictionary:object];
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

//取消批购订单
- (void)cancelWholesaleOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelWholesaleOrderWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    [self goPervious:nil];
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
    [NetworkInterface cancelProcurementOrderWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    [self goPervious:nil];
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

- (void)parseOrderDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _orderDetail = [[OrderDetailModel alloc] initWithParseDictionary:[dict objectForKey:@"result"]];
    [self initAndLayoutUI];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 3;
            break;
        case 1:
            row = [_orderDetail.goodList count] + 2;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    CGFloat originX = 20.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, 18, 18)];
                    statusView.image = kImageName(@"order.png");
                    [cell.contentView addSubview:statusView];
                    //状态
                    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 30, 10, kScreenWidth / 2, 20.f)];
                    statusLabel.backgroundColor = [UIColor clearColor];
                    statusLabel.font = [UIFont boldSystemFontOfSize:16.f];
                    statusLabel.text = [_orderDetail getStatusStringWithSupplyType:_supplyType];
                    [cell.contentView addSubview:statusLabel];
                    //批购
                    if (_supplyType == SupplyGoodsWholesale) {
                        //实付
                        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, kScreenWidth - originX * 2, 20.f)];
                        [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额：￥%.2f",_orderDetail.actualPrice]];
                        [cell.contentView addSubview:payLabel];
                        //定金总额
                        UILabel *totalDepositLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, kScreenWidth / 2 - originX, 20.f)];
                        [self setLabel:totalDepositLabel withString:[NSString stringWithFormat:@"定金总额：￥%.2f",_orderDetail.totalDeposit]];
                        [cell.contentView addSubview:totalDepositLabel];
                        //已发货数量
                        UILabel *shipmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 50, kScreenWidth / 2 - originX, 20)];
                        [self setLabel:shipmentLabel withString:[NSString stringWithFormat:@"已发货数量：%d",_orderDetail.shipmentCount]];
                        [cell.contentView addSubview:shipmentLabel];
                        //已付定金
                        UILabel *paidDepositLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 70, kScreenWidth / 2 - originX, 20)];
                        [self setLabel:paidDepositLabel withString:[NSString stringWithFormat:@"已付定金：￥%.2f",_orderDetail.paidDeposit]];
                        [cell.contentView addSubview:paidDepositLabel];
                        //剩余货品数量
                        UILabel *remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 70, kScreenWidth / 2 - originX, 20)];
                        [self setLabel:remainLabel withString:[NSString stringWithFormat:@"剩余货品总数：%d",_orderDetail.totalCount - _orderDetail.shipmentCount]];
                        [cell.contentView addSubview:remainLabel];
                    }
                    else {
                        //实付
                        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, kScreenWidth * 0.6 - originX, 20.f)];
                        [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额：￥%.2f",_orderDetail.actualPrice]];
                        [cell.contentView addSubview:payLabel];
                        
                        UIImageView *vLine = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.6, 15, 1, 30)];
                        vLine.image = kImageName(@"gray.png");
                        [cell.contentView addSubview:vLine];
                        
                        //归属用户
                        UILabel *belongLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.6 + 5, 10, kScreenWidth * 0.4 - originX, 20)];
                        [self setLabel:belongLabel withString:@"归属用户："];
                        [cell.contentView addSubview:belongLabel];
                        
                        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.6 + 5, 30, kScreenWidth * 0.4 - originX, 20)];
                        [self setLabel:userLabel withString:_orderDetail.belongUser];
                        [cell.contentView addSubview:userLabel];
                    }
                }
                    break;
                case 1: {
                    //60
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //收件人
                    UILabel *receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:receiverLabel withString:[NSString stringWithFormat:@"收件人：%@  %@",_orderDetail.receiver,_orderDetail.phoneNumber]];
                    [cell.contentView addSubview:receiverLabel];
                    //地址
                    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:addressLabel withString:[NSString stringWithFormat:@"收件地址：%@",_orderDetail.address]];
                    [cell.contentView addSubview:addressLabel];
                }
                    break;
                case 2: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //留言
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.comment];
                    CGFloat height = [StringFormat heightForComment:comment withFont:[UIFont systemFontOfSize:13.f] width:kScreenWidth - originX * 2];
                    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth - originX *2, height)];
                    commentLabel.numberOfLines = 0;
                    [self setLabel:commentLabel withString:comment];
                    [cell.contentView addSubview:commentLabel];
                    //发票
                    UILabel *invoceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10 + height, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:invoceTypeLabel withString:[NSString stringWithFormat:@"发票类型：%@",_orderDetail.invoceType]];
                    [cell.contentView addSubview:invoceTypeLabel];
                    UILabel *invoceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30 + height, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:invoceTitleLabel withString:[NSString stringWithFormat:@"发票抬头：%@",_orderDetail.invoceTitle]];
                    
                    [cell.contentView addSubview:invoceTitleLabel];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                //100
                CGFloat btnWidth = 80.f;
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                //订单
                UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth - originX * 2 - btnWidth, 20)];
                orderLabel.backgroundColor = [UIColor clearColor];
                orderLabel.font = [UIFont systemFontOfSize:12.f];
                orderLabel.textColor = kColor(116, 116, 116, 1);
                orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderDetail.orderNumber];
                [cell.contentView addSubview:orderLabel];
                //订单类型
                NSString *orderType = @"批购";
                if (_supplyType == SupplyGoodsProcurement) {
                    orderType = @"代购";
                }
                UILabel *orderTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, kScreenWidth - originX * 2 - btnWidth, 20)];
                orderTypeLabel.backgroundColor = [UIColor clearColor];
                orderTypeLabel.font = [UIFont systemFontOfSize:12.f];
                orderTypeLabel.textColor = kColor(116, 116, 116, 1);
                orderTypeLabel.text = [NSString stringWithFormat:@"订单类型：%@",orderType];
                [cell.contentView addSubview:orderTypeLabel];
                //支付方式
                UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, kScreenWidth - originX * 2 - btnWidth, 20.f)];
                typeLabel.backgroundColor = [UIColor clearColor];
                typeLabel.font = [UIFont systemFontOfSize:12.f];
                typeLabel.textColor = kColor(116, 116, 116, 1);
                typeLabel.text = [NSString stringWithFormat:@"支付方式：%@",_orderDetail.payType];
                [cell.contentView addSubview:typeLabel];
                //订单日期
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 70, kScreenWidth - originX * 2 - btnWidth, 20)];
                dateLabel.backgroundColor = [UIColor clearColor];
                dateLabel.font = [UIFont systemFontOfSize:12.f];
                dateLabel.textColor = kColor(116, 116, 116, 1);
                dateLabel.text = [NSString stringWithFormat:@"订单日期：%@",_orderDetail.createTime];
                [cell.contentView addSubview:dateLabel];
                
                int status = _orderDetail.orderStatus;
                if ((_supplyType == SupplyGoodsProcurement &&
                     (status == ProcurementStatusSend ||
                      status == ProcurementStatusReview)) ||
                    (_supplyType == SupplyGoodsWholesale &&
                     ((status == WholesaleStatusUnPaid && _orderDetail.payStatus == DepositPaid) ||
                      status == WholesaleStatusPaid ||
                      status == WholesaleStatusFinish ||
                      status == WholesaleStatusReview))) {
                    UIButton *terminalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    terminalBtn.frame = CGRectMake(kScreenWidth - btnWidth - 10, 10, btnWidth, 30);
                    terminalBtn.layer.cornerRadius = 4;
                    terminalBtn.layer.masksToBounds = YES;
                    terminalBtn.layer.borderWidth = 1.f;
                    terminalBtn.layer.borderColor = kMainColor.CGColor;
                    [terminalBtn setTitleColor:kMainColor forState:UIControlStateNormal];
                    [terminalBtn setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
                    terminalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
                    [terminalBtn setTitle:@"查看终端号" forState:UIControlStateNormal];
                    [terminalBtn addTarget:self action:@selector(scanTerminalNumber:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:terminalBtn];
                }
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                int goodCount = _orderDetail.totalCount;
                if (_supplyType == SupplyGoodsProcurement) {
                    goodCount = _orderDetail.proTotalCount;
                }
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth / 2 - originX, 20)];
                totalLabel.backgroundColor = [UIColor clearColor];
                totalLabel.font = [UIFont systemFontOfSize:13.f];
                totalLabel.textAlignment = NSTextAlignmentRight;
                totalLabel.text = [NSString stringWithFormat:@"共计%d件商品",goodCount];
                [cell.contentView addSubview:totalLabel];
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 10, kScreenWidth / 2 - originX, 20)];
                priceLabel.backgroundColor = [UIColor clearColor];
                priceLabel.font = [UIFont systemFontOfSize:13.f];
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.text = [NSString stringWithFormat:@"实付金额:￥%.2f",_orderDetail.actualPrice];
                [cell.contentView addSubview:priceLabel];
            }
            else {
                static NSString *orderIdentifier = @"orderIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
                if (cell == nil) {
                    cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier supplyType:_supplyType];
                }
                OrderGoodModel *model = [_orderDetail.goodList objectAtIndex:indexPath.row - 1];
                [(OrderDetailCell *)cell setContentsWithData:model];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    height = 100.f;
                    if (_supplyType == SupplyGoodsProcurement) {
                        height = 60.f;
                    }
                }
                    break;
                case 1:
                    height = 60.f;
                    break;
                case 2: {
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.comment];
                    CGFloat commentHeight = [StringFormat heightForComment:comment withFont:[UIFont systemFontOfSize:13.f] width:kScreenWidth - 40];
                    height = commentHeight + 60;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                height = 100.f;
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                height = 40.f;
            }
            else {
                height = kOrderDetailCellHeight;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 16.f;
    }
    else {
        return 5.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Action

- (IBAction)scanTerminalNumber:(id)sender {
    NSArray *terminalList = [_orderDetail.terminals componentsSeparatedByString:@","];
    if ([terminalList count] <= 0 || [_orderDetail.terminals isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有终端";
        return;
    }
    else {
        OrderTerminalListController *listC = [[OrderTerminalListController alloc] init];
        listC.terminalList = terminalList;
        [self.navigationController pushViewController:listC animated:YES];
    }
}

- (IBAction)goPervious:(id)sender {
    if (_fromType == PayWayFromNone) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_fromType == PayWayFromOrderProcurement ||
             _fromType == PayWayFromOrderWholesale) {
        UIViewController *controller = nil;
        for (UIViewController *listC in self.navigationController.childViewControllers) {
            if ([listC isMemberOfClass:[OrderManagerController class]]) {
                controller = listC;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (_fromType == PayWayFromGoodWholesale ||
             _fromType == PayWayFromGoodProcurementBuy ||
             _fromType == PayWayFromGoodProcurementRent) {
        UIViewController *controller = nil;
        for (UIViewController *listC in self.navigationController.childViewControllers) {
            if ([listC isMemberOfClass:[GoodListController class]]) {
                controller = listC;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

//批购
- (IBAction)cancelWholesaleOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确认取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = AlertTagCancel;
    [alert show];
}

//支付定金
- (IBAction)payDeposit:(id)sender {
    PayWayViewController *payC = [[PayWayViewController alloc] init];
    payC.orderID = _orderDetail.orderID;
    payC.totalPrice = _orderDetail.totalDeposit;
    payC.fromType = PayWayFromOrderWholesale;
    payC.goodID = _goodID;
    payC.goodName = _goodName;
    [self.navigationController pushViewController:payC animated:YES];
}

//付款
- (IBAction)payWholesaleOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"填写付款金额"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = AlertTagPayMoney;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

//再次批购
- (IBAction)repeatWholesale:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthWholesale]] boolValue]) {
        GoodDetailController *detailC = [[GoodDetailController alloc] init];
        detailC.supplyType = SupplyGoodsWholesale;
        detailC.goodID = _goodID;
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
- (IBAction)cancelProcurementOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确认取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = AlertTagCancel;
    [alert show];
}

//付款
- (IBAction)payProcurementOrder:(id)sender {
    PayWayViewController *payC = [[PayWayViewController alloc] init];
    payC.orderID = _orderDetail.orderID;
    payC.totalPrice = _orderDetail.actualPrice;
    payC.fromType = PayWayFromOrderProcurement;
    payC.goodID = _goodID;
    payC.goodName = _goodName;
    [self.navigationController pushViewController:payC animated:YES];
}

//再次代购
- (IBAction)repeatProcurement:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthProcurement]] boolValue]) {
        GoodDetailController *detailC = [[GoodDetailController alloc] init];
        detailC.supplyType = SupplyGoodsProcurement;
        detailC.goodID = _goodID;
        [self.navigationController pushViewController:detailC animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有采购权限";
    }
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == AlertTagPayMoney) {
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
            if ([textField.text floatValue] > _orderDetail.remainingMoney) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"金额必须小于付款金额";
                return;
            }
            PayWayViewController *payC = [[PayWayViewController alloc] init];
            payC.orderID = _orderDetail.orderID;
            payC.goodID = _goodID;
            payC.goodName = _goodName;
            payC.totalPrice = [textField.text floatValue];
            payC.fromType = PayWayFromOrderWholesale;
            payC.isPayPartMoney = YES; //部分付款
            [self.navigationController pushViewController:payC animated:YES];
        }
        else if (alertView.tag == AlertTagCancel) {
            if (_supplyType == SupplyGoodsWholesale) {
                [self cancelWholesaleOrder];
            }
            else {
                [self cancelProcurementOrder];
            }
        }
    }
}

@end
