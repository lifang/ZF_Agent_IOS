//
//  TradeModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TradeModel.h"

@implementation TradeModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _tradeID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _tradeStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tradedStatus"]];
        _terminalNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"terminalNumber"]];
        _amount = [[dict objectForKey:@"amount"] floatValue] / 100;
        _tradeTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tradedTimeStr"]];
        if ([dict objectForKey:@"payIntoAccount"]) {
            _payIntoAccount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payIntoAccount"]];
        }
        else {
            _payIntoAccount = @"";
        }
        if ([dict objectForKey:@"payFromAccount"]) {
            _payFromAccount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payFromAccount"]];
        }
        else {
            _payFromAccount = @"";
        }
        if ([dict objectForKey:@"payedTimeStr"]) {
            _payedTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payedTimeStr"]];
        }
        else {
            _payedTime = @"";
        }
        if ([dict objectForKey:@"poundage"]) {
            _poundage = [[dict objectForKey:@"poundage"] floatValue] / 100;
        }
        if ([dict objectForKey:@"account_name"]) {
            _accountName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"account_name"]];
        }
        else {
            _accountName = @"";
        }
        if ([dict objectForKey:@"account_number"]) {
            _accountNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"account_number"]];
        }
        else {
            _accountNumber = @"";
        }
        if ([dict objectForKey:@"phone"]) {
            _phoneNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }
        else {
            _phoneNumber = @"";
        }
    }
    return self;
}

@end
