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

typedef enum {
    OrderDetailBtnStyleFirst = 1,
    OrderDetailBtnStyleSecond,
}OrderDetailBtnStyle; //按钮样式

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OrderDetailModel *orderDetail;

@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downloadDetail];
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

- (void)initAndLayoutUI {
    CGFloat footerHeight = 0.f;
    int status = _orderDetail.orderStatus;
    if ((_supplyType == SupplyGoodsWholesale && _orderDetail.orderStatus != WholesaleStatusCancel) ||
        (_supplyType == SupplyGoodsProcurement && _orderDetail.orderStatus != ProcurementStatusPaid)) {
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
//        [self footerViewAddSubview];
        
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

//- (UIButton *)buttonWithTitle:(NSString *)titleName
//                       action:(SEL)action
//                        style:(NSString *)style{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.layer.cornerRadius = 4;
//    button.layer.masksToBounds = YES;
//    if ([style isEqualToString:orderBtnStyleFirst]) {
//        button.layer.borderWidth = 1.f;
//        button.layer.borderColor = kMainColor.CGColor;
//        [button setTitleColor:kMainColor forState:UIControlStateNormal];
//        [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
//    }
//    else {
//        [button setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
//    }
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
//    [button setTitle:titleName forState:UIControlStateNormal];
//    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}

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
//                    [self parseOrderDetailDataWithDictionary:object];
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

@end
