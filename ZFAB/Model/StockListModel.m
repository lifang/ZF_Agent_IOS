//
//  StockListModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StockListModel.h"

@implementation StockListModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"good_id"]) {
            _stockGoodID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_id"]];
        }
        if ([dict objectForKey:@"goodname"]) {
            _stockTitle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"goodname"]];
        }
        else {
            _stockTitle = @"";
        }
        if ([dict objectForKey:@"good_brand"]) {
            _stockGoodBrand = [NSString stringWithFormat:@"%@",[dict objectForKey:@"good_brand"]];
        }
        else {
            _stockGoodBrand = @"";
        }
        if ([dict objectForKey:@"Model_number"]) {
            _stockGoodModel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Model_number"]];
        }
        else {
            _stockGoodModel = @"";
        }
        if ([dict objectForKey:@"paychannel"]) {
            _stockChannel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"paychannel"]];
        }
        else {
            _stockChannel = @"";
        }
        if ([dict objectForKey:@"paychannel_id"]) {
            _stockChannelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"paychannel_id"]];
        }
        if ([dict objectForKey:@"picurl"]) {
            _stockImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"picurl"]];
        }
        _historyCount = [[dict objectForKey:@"hoitoryCount"] intValue];
        _totalCount = [[dict objectForKey:@"totalCount"] intValue];
        _openCount = [[dict objectForKey:@"openCount"] intValue];
        _agentCount = [[dict objectForKey:@"agentCount"] intValue];
    }
    return self;
}

@end
