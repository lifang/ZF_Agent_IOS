//
//  TradeModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//


/*交易流水*/

#import <Foundation/Foundation.h>

typedef enum {
    TradeStatusUnPaid = 1,   //待付款
    TradeStatusFinish,       //交易完成
    TradeStatusFail,         //交易失败
}TradeStatus; //交易流水状态

@interface TradeModel : NSObject

//交易流水id
@property (nonatomic, strong) NSString *tradeID;
//交易状态（1.待付款 2.交易完成 3.交易失败）
@property (nonatomic, strong) NSString *tradeStatus;
//终端号
@property (nonatomic, strong) NSString *terminalNumber;
//总额
@property (nonatomic, assign) CGFloat amount;
//交易时间
@property (nonatomic, strong) NSString *tradeTime;

/*1.转账字段  3.还款字段*/
@property (nonatomic, strong) NSString *payIntoAccount; //收款账号
@property (nonatomic, strong) NSString *payFromAccount; //付款账号

/*2.消费字段*/
@property (nonatomic, strong) NSString *payedTime;  //结算时间
@property (nonatomic, assign) CGFloat poundage;   //手续费

/*4.生活充值字段*/
@property (nonatomic, strong) NSString *accountName;   //账户名
@property (nonatomic, strong) NSString *accountNumber; //账户号码

/*5.话费充值字段*/
@property (nonatomic, strong) NSString *phoneNumber; //手机号码


- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
