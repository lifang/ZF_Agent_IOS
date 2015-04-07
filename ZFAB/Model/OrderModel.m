//
//  OrderModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderGoodModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"good_id"]) {
            _goodID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_id"]];
        }
        if ([dict objectForKey:@"good_name"]) {
            _goodName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_name"]];
        }
        else {
            _goodName = @"";
        }
        if ([dict objectForKey:@"good_brand"]) {
            _goodBrand = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_brand"]];
        }
        else {
            _goodBrand = @"";
        }
        if ([dict objectForKey:@"good_channel"]) {
            _goodChannel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_channel"]];
        }
        else {
            _goodChannel = @"";
        }
        if ([dict objectForKey:@"good_logo"]) {
            _goodImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_logo"]];
        }
        _goodPrimaryPrice = [[dict objectForKey:@"good_price"] floatValue] / 100;
        _goodActualPirce = [[dict objectForKey:@"good_batch_price"] floatValue] / 100;
        _goodCount = [[dict objectForKey:@"good_num"] intValue];
    }
    return self;
}

@end

@implementation OrderModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"order_id"]) {
            _orderID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_id"]];
        }
        if ([dict objectForKey:@"order_number"]) {
            _orderNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_number"]];
        }
        else {
            _orderNumber = @"";
        }
        if ([dict objectForKey:@"order_createTime"]) {
            _orderTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_createTime"]];
        }
        else {
            _orderTime = @"";
        }
        _status = [[dict objectForKey:@"order_status"] intValue];
        
        id goodList = [dict objectForKey:@"order_goodsList"];
        if ([goodList isKindOfClass:[NSArray class]] && [goodList count] > 0) {
            id goodDict = [goodList firstObject];
            if ([goodDict isKindOfClass:[NSDictionary class]]) {
                _orderGood = [[OrderGoodModel alloc] initWithParseDictionary:goodDict];
            }
        }
        
        //批购字段
        _shipmentCount = [[dict objectForKey:@"quantity"] intValue];
        _orderDeposit = [[dict objectForKey:@"zhifu_dingjin"] floatValue] / 100;
        _remainingMoney = [[dict objectForKey:@"shengyu_price"] floatValue] / 100;
        _totalMoney = [[dict objectForKey:@"actual_price"] floatValue] / 100;
        
        //代购字段
        if ([dict objectForKey:@"guishu_user"]) {
            _belongUser = [NSString stringWithFormat:@"%@",[dict objectForKey:@"guishu_user"]];
        }
        else {
            _belongUser = @"";
        }
        _deliveryMoney = [[dict objectForKey:@"order_psf"] floatValue] / 100;
        _actualMoney = [[dict objectForKey:@"order_totalPrice"] floatValue] / 100;
    }
    return self;
}

- (NSString *)getCellIdentifierWithSupplyType:(SupplyGoodsType)supplyType {
    NSString *identifier = nil;
    if (supplyType == SupplyGoodsWholesale) {
        switch (_status) {
            case WholesaleStatusUnPaid:
                identifier = wholesaleUnpaidIdentifier;
                break;
            case WholesaleStatusPartPaid:
                identifier = wholesaleDepositIdentifier;
                break;
            case WholesaleStatusFinish:
                identifier = wholesaleFinishIdentifier;
                break;
            case WholesaleStatusCancel:
                identifier = wholesaleCancelIdentifier;
                break;
            default:
                break;
        }
    }
    else if (supplyType == SupplyGoodsProcurement) {
        switch (_status) {
            case ProcurementStatusUnPaid:
                identifier = procurementFirstIdentifier;
                break;
            case ProcurementStatusPaid:
                identifier = procurementThirdIdentifier;
                break;
            case ProcurementStatusSend:
                identifier = procurementSecondIdentifier;
                break;
            case ProcurementStatusReview:
                identifier = procurementSecondIdentifier;
                break;
            case ProcurementStatusCancel:
                identifier = procurementSecondIdentifier;
                break;
            case ProcurementStatusClosed:
                identifier = procurementSecondIdentifier;
                break;
            default:
                break;
        }
    }
    return identifier;
}

- (NSString *)getStatusStringWithSupplyType:(SupplyGoodsType)supplyType {
    NSString *statusString = nil;
    if (supplyType == SupplyGoodsWholesale) {
        switch (_status) {
            case WholesaleStatusUnPaid:
                statusString = @"未付款";
                break;
            case WholesaleStatusPartPaid:
                statusString = @"已付定金";
                break;
            case WholesaleStatusFinish:
                statusString = @"已完成";
                break;
            case WholesaleStatusCancel:
                statusString = @"已取消";
                break;
            default:
                break;
        }
    }
    else if (supplyType == SupplyGoodsProcurement) {
        switch (_status) {
            case ProcurementStatusUnPaid:
                statusString = @"未付款";
                break;
            case ProcurementStatusPaid:
                statusString = @"已付款";
                break;
            case ProcurementStatusSend:
                statusString = @"已发货";
                break;
            case ProcurementStatusReview:
                statusString = @"已评价";
                break;
            case ProcurementStatusCancel:
                statusString = @"已取消";
                break;
            case ProcurementStatusClosed:
                statusString = @"交易关闭";
                break;
            default:
                break;
        }
    }
    return statusString;
}

@end
