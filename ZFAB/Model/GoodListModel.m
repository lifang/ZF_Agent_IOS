//
//  GoodListModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodListModel.h"

@implementation GoodListModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _goodID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"Title"]) {
            _goodName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]];
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
        if ([dict objectForKey:@"Model_number"]) {
            _goodModel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Model_number"]];
        }
        else {
            _goodModel = @"";
        }
        if ([dict objectForKey:@"pay_channe"]) {
            _goodChannel = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pay_channe"]];
        }
        else {
            _goodChannel = @"";
        }
        if ([dict objectForKey:@"total_score"]) {
            _goodScore = [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_score"]];
        }
        if ([dict objectForKey:@"url_path"]) {
            _goodImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url_path"]];
        }
        _isRent = [[dict objectForKey:@"has_lease"] boolValue];
        _goodPrimaryPrice = [[dict objectForKey:@"retail_price"] floatValue] / 100;
        _goodWholesalePrice = [[dict objectForKey:@"purchase_price"] floatValue] / 100;
        _goodSaleNumber = [[dict objectForKey:@"volume_number"] intValue];
        _minWholesaleNumber = [[dict objectForKey:@"floor_purchase_quantity"] intValue];
    }
    return self;
}

@end
