//
//  OrderDetailModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "RecordModel.h"

@interface OrderDetailModel : NSObject

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *receiver;    //收件人

@property (nonatomic, strong) NSString *phoneNumber; //手机号

@property (nonatomic, strong) NSString *address;     //地址

@property (nonatomic, strong) NSString *comment;     //留言

@property (nonatomic, strong) NSString *invoceType;  //发票类型

@property (nonatomic, strong) NSString *invoceTitle; //发票抬头

@property (nonatomic, strong) NSString *orderNumber; //订单号

@property (nonatomic, strong) NSString *payType;     //支付类型

@property (nonatomic, strong) NSString *createTime;  //订单日期

@property (nonatomic, assign) int orderStatus;

@property (nonatomic, assign) CGFloat actualPrice;   //实付金额

/*批购字段*/
@property (nonatomic, assign) CGFloat totalDeposit;  //定金总额

@property (nonatomic, assign) CGFloat paidDeposit;   //已付定金

@property (nonatomic, assign) int totalCount;        //总数量

@property (nonatomic, assign) int shipmentCount;     //已发货数量
/*******************************/

/*代购字段*/
@property (nonatomic, strong) NSString *belongUser;  //归属用户

@property (nonatomic, assign) int proTotalCount;   //代购总数量
/***************/

@property (nonatomic, strong) NSMutableArray *goodList;

@property (nonatomic, strong) NSMutableArray *recordList;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getStatusStringWithSupplyType:(SupplyGoodsType)supplyType;

@end
