//
//  AlipayHelper.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/21.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AlipayHelper.h"
#import "Order.h"
#import "DataSigner.h"

@implementation AlipayHelper

+ (void)alipayWithOrderNumber:(NSString *)orderNumber
                     goodName:(NSString *)goodName
                   totalPrice:(CGFloat)totalPrice
                  isWholesale:(BOOL)isWholesale
                    payResult:(CompletionBlock)payResult {
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = orderNumber; //订单ID
    order.productName = goodName; //商品标题
    order.productDescription = goodName; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",totalPrice]; //商品价格
    if (isWholesale) {
        order.notifyURL = kWhalesaleCallBackURL; //回调URL
    }
    else {
        order.notifyURL = kProcurementCallBackURL;
    }
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipayZFAB";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"%@",orderSpec);
    id<DataSigner> signer = CreateRSADataSigner(PartnerPriveKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:payResult];
    }

}

@end
