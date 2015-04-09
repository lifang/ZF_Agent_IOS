//
//  MerchantDetailModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MerchantDetailModel.h"

@implementation MerchantDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _merchantID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"title"]) {
            _merchantName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        }
        if ([dict objectForKey:@"legal_person_name"]) {
            _merchantPersonName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"legal_person_name"]];
        }
        if ([dict objectForKey:@"legal_person_card_id"]) {
            _merchantPersonID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"legal_person_card_id"]];
        }
        if ([dict objectForKey:@"business_license_no"]) {
            _merchantBusinessID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"business_license_no"]];
        }
        if ([dict objectForKey:@"tax_registered_no"]) {
            _merchantTaxID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tax_registered_no"]];
        }
        if ([dict objectForKey:@"organization_code_no"]) {
            _merchantOrganizationID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"organization_code_no"]];
        }
        if ([dict objectForKey:@"account_bank_name"]) {
            _merchantBank = [NSString stringWithFormat:@"%@",[dict objectForKey:@"account_bank_name"]];
        }
        if ([dict objectForKey:@"bank_open_account"]) {
            _merchantBankID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bank_open_account"]];
        }
        if ([dict objectForKey:@"city_id"]) {
            _merchantCityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_id"]];
        }
        if ([dict objectForKey:@"card_id_front_photo_path"]) {
            _frontPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"card_id_front_photo_path"]];
        }
        if ([dict objectForKey:@"card_id_back_photo_path"]) {
            _backPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"card_id_back_photo_path"]];
        }
        if ([dict objectForKey:@"body_photo_path"]) {
            _bodyPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"body_photo_path"]];
        }
        if ([dict objectForKey:@"license_no_pic_path"]) {
            _licensePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"license_no_pic_path"]];
        }
        if ([dict objectForKey:@"tax_no_pic_path"]) {
            _taxPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tax_no_pic_path"]];
        }
        if ([dict objectForKey:@"org_code_no_pic_path"]) {
            _organizationPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"org_code_no_pic_path"]];
        }
        if ([dict objectForKey:@"account_pic_path"]) {
            _bankPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"account_pic_path"]];
        }
    }
    return self;
}

@end
