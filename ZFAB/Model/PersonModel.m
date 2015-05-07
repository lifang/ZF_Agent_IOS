//
//  PersonModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _personID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"types"]) {
            _type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"types"]];
        }
        if ([dict objectForKey:@"company_name"]) {
            _companyName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"company_name"]];
        }
        else {
            _companyName = @"";
        }
        if ([dict objectForKey:@"business_license"]) {
            _licenseNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"business_license"]];
        }
        else {
            _licenseNumber = @"";
        }
        if ([dict objectForKey:@"tax_registered_no"]) {
            _taxNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tax_registered_no"]];
        }
        else {
            _taxNumber = @"";
        }
        if ([dict objectForKey:@"name"]) {
            _personName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        else {
            _personName = @"";
        }
        if ([dict objectForKey:@"card_id"]) {
            _personCardID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"card_id"]];
        }
        else {
            _personCardID = @"";
        }
        if ([dict objectForKey:@"phone"]) {
            _mobileNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }
        else {
            _mobileNumber = @"";
        }
        if ([dict objectForKey:@"email"]) {
            _email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];
        }
        else {
            _email = @"";
        }
        if ([dict objectForKey:@"city_id"]) {
            _cityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_id"]];
        }
        if ([dict objectForKey:@"address"]) {
            _address = [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]];
        }
        else {
            _address = @"";
        }
        if ([dict objectForKey:@"card_id_photo_path"]) {
            _cardImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"card_id_photo_path"]];
        }
        if ([dict objectForKey:@"license_no_pic_path"]) {
            _licenseImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"license_no_pic_path"]];
        }
        if ([dict objectForKey:@"tax_no_pic_path"]) {
            _taxImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tax_no_pic_path"]];
        }
        if ([dict objectForKey:@"username"]) {
            _userName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
        }
        else {
            _userName = @"";
        }
    }
    return self;
}

@end
