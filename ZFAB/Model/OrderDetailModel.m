
//
//  OrderDetailModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"order_id"]) {
            _orderID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agentId"]];
        }
        if ([dict objectForKey:@"order_receiver"]) {
            _receiver = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_receiver"]];
        }
        else {
            _receiver = @"";
        }
        if ([dict objectForKey:@"order_receiver_phone"]) {
            _phoneNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_receiver_phone"]];
        }
        else {
            _phoneNumber = @"";
        }
        if ([dict objectForKey:@"order_address"]) {
            _address = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_address"]];
        }
        else {
            _address = @"";
        }
        if ([dict objectForKey:@"order_comment"]) {
            _comment = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_comment"]];
        }
        else {
            _comment = @"";
        }
        if ([dict objectForKey:@"order_invoce_type"]) {
            _invoceType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_comment"]];
        }
        if ([dict objectForKey:@"order_invoce_info"]) {
            _invoceTitle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_invoce_info"]];
        }
        if ([dict objectForKey:@"order_number"]) {
            _orderNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_number"]];
        }
        else {
            _orderNumber = @"";
        }
        if ([dict objectForKey:@"order_payment_type"]) {
            _payType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_payment_type"]];
        }
        else {
            _payType = @"";
        }
        if ([dict objectForKey:@"order_createTime"]) {
            _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_createTime"]];
        }
        else {
            _createTime = @"";
        }
        _orderStatus = [[dict objectForKey:@"order_status"] intValue];
        _actualPrice = [[dict objectForKey:@"order_totalPrice"] floatValue] / 100;
        _totalDeposit = [[dict objectForKey:@"total_dingjin"] floatValue] / 100;
        _paidDeposit = [[dict objectForKey:@"zhifu_dingjin"] floatValue] / 100;
        _totalCount = [[dict objectForKey:@"total_quantity"] intValue];
        _shipmentCount = [[dict objectForKey:@"shipped_quantity"] intValue];
        
        if ([dict objectForKey:@"guishu_user"]) {
            _belongUser = [NSString stringWithFormat:@"%@",[dict objectForKey:@"guishu_user"]];
        }
        else {
            _belongUser = @"";
        }
        
        id recordObject = [[dict objectForKey:@"comments"] objectForKey:@"content"];
        if ([recordObject isKindOfClass:[NSArray class]]) {
            _recordList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [recordObject count]; i++) {
                id recordDict = [recordObject objectAtIndex:i];
                if ([recordDict isKindOfClass:[NSDictionary class]]) {
                    RecordModel *model = [[RecordModel alloc] initWithParseDictionary:recordDict];
                    [_recordList addObject:model];
                }
            }
        }
        id goodObject = [dict objectForKey:@"order_goodsList"];
        if ([goodObject isKindOfClass:[NSArray class]]) {
            _goodList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [goodObject count]; i++) {
                id goodDict = [goodObject objectAtIndex:i];
                if ([goodDict isKindOfClass:[NSDictionary class]]) {
                    OrderGoodModel *model = [[OrderGoodModel alloc] initWithParseDictionary:goodDict];
                    [_goodList addObject:model];
                }
            }
        }
    }
    return self;
}
@end
