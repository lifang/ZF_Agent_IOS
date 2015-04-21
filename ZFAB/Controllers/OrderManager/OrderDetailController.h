//
//  OrderDetailController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"
#import "OrderModel.h"
#import "PayWayViewController.h"

typedef enum {
    AlertTagCancel = 1,  //取消订单tag
    AlertTagPayMoney,    //付款tag
}AlertTag;

@interface OrderDetailController : CommonViewController

//再次批购 代购需要此字段
@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, assign) SupplyGoodsType supplyType;

@property (nonatomic, assign) PayWayFromType fromType;  //是否从支付跳转

@end
