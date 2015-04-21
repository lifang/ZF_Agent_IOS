//
//  SubAgentDetailModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SubAgentDetailModel.h"

@implementation SubAgentDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _agentType = [[dict objectForKey:@"types"] intValue];
        int benefit = [[dict objectForKey:@"is_have_profit"] intValue];
        if (benefit == 2) {
            _hasProfit = YES;
        }
        if ([dict objectForKey:@"company_name"]) {
            _companyName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"company_name"]];
        }
        if ([dict objectForKey:@"business_license"]) {
            _licenseNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"business_license"]];
        }
        if ([dict objectForKey:@"tax_registered_no"]) {
            _taxNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tax_registered_no"]];
        }
        if ([dict objectForKey:@"name"]) {
            _personName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"card_id"]) {
            _personID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"card_id"]];
        }
        if ([dict objectForKey:@"phone"]) {
            _mobilePhone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }
        if ([dict objectForKey:@"email"]) {
            _email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];
        }
        if ([dict objectForKey:@"provinceName"]) {
            _provinceName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"provinceName"]];
        }
        if ([dict objectForKey:@"cityName"]) {
            _cityName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cityName"]];
        }
        if ([dict objectForKey:@"cityId"]) {
            _cityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cityId"]];
        }
        if ([dict objectForKey:@"address"]) {
            _address = [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]];
        }
        if ([dict objectForKey:@"cardpath"]) {
            _cardImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cardpath"]];
        }
        if ([dict objectForKey:@"licensepath"]) {
            _licenseImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"licensepath"]];
        }
        if ([dict objectForKey:@"taxpath"]) {
            _taxImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"taxpath"]];
        }
        if ([dict objectForKey:@"loginId"]) {
            _loginName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"loginId"]];
        }
        if ([dict objectForKey:@"created_at"]) {
            _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"created_at"]];
        }
        _saleCount = [[dict objectForKey:@"soldnum"] intValue];
        _remainCount = [[dict objectForKey:@"allQty"] intValue];
        _openCount = [[dict objectForKey:@"opennum"] intValue];
    }
    return self;
}

@end
