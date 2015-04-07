//
//  OrderModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkInterface.h"

typedef enum {
    ProcurementStatusAll = -1,
    ProcurementStatusUnPaid = 1,//未付款
    ProcurementStatusPaid,      //已付款
    ProcurementStatusSend,      //已发货
    ProcurementStatusReview,    //已评价
    ProcurementStatusCancel,    //已取消
    ProcurementStatusClosed,    //交易关闭
}ProcurementOrderStatus;  //代购订单状态

typedef enum {
    WholesaleStatusAll = -1,
    WholesaleStatusUnPaid = 1,   //未付款
    WholesaleStatusPartPaid,     //已付定金
    WholesaleStatusFinish,       //已完成
    WholesaleStatusCancel,       //已取消
}WholesaleOrderStatus;  //批购订单状态

//批购 取消订单+支付定金
static NSString *wholesaleUnpaidIdentifier = @"wholesaleUnpaidIdentifier";
//批购 取消订单+付款
static NSString *wholesaleDepositIdentifier = @"wholesaleDepositIdentifier";
//批购 再次批购
static NSString *wholesaleFinishIdentifier = @"wholesaleFinishIdentifier";
//批购 无操作
static NSString *wholesaleCancelIdentifier = @"wholesaleCancelIdentifier";
//代购 取消订单+付款
static NSString *procurementFirstIdentifier = @"procurementFirstIdentifier";
//代购 再次代购
static NSString *procurementSecondIdentifier = @"procurementSecondIdentifier";
//代购 无操作
static NSString *procurementThirdIdentifier = @"procurementThirdIdentifier";

@interface OrderGoodModel : NSObject

@property (nonatomic, strong) NSString *goodID;

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, strong) NSString *goodBrand;

@property (nonatomic, strong) NSString *goodChannel;

@property (nonatomic, strong) NSString *goodImagePath;

@property (nonatomic, assign) CGFloat goodPrimaryPrice; //原价

@property (nonatomic, assign) CGFloat goodActualPirce;  //现价

@property (nonatomic, assign) int goodCount;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

@interface OrderModel : NSObject

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *orderNumber;

@property (nonatomic, strong) NSString *orderTime;

@property (nonatomic, assign) int status;

@property (nonatomic, strong) OrderGoodModel *orderGood;

/*批购字段*/
@property (nonatomic, assign) int shipmentCount;  //发货数量
@property (nonatomic, assign) CGFloat orderDeposit; //定金
@property (nonatomic, assign) CGFloat remainingMoney; //剩余金额
@property (nonatomic, assign) CGFloat totalMoney;   //合计

/*代购字段*/
@property (nonatomic, strong) NSString *belongUser; //归属用户
@property (nonatomic, assign) CGFloat deliveryMoney;     //配送费
@property (nonatomic, assign) CGFloat actualMoney;    //实付金额

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getCellIdentifierWithSupplyType:(SupplyGoodsType)supplyType;
- (NSString *)getStatusStringWithSupplyType:(SupplyGoodsType)supplyType;

@end
