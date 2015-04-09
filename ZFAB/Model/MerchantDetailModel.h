//
//  MerchantDetailModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantDetailModel : NSObject

@property (nonatomic, strong) NSString *merchantID;

@property (nonatomic, strong) NSString *merchantName;

@property (nonatomic, strong) NSString *merchantPersonName;

@property (nonatomic, strong) NSString *merchantPersonID;

@property (nonatomic, strong) NSString *merchantBusinessID;

@property (nonatomic, strong) NSString *merchantTaxID;

@property (nonatomic, strong) NSString *merchantOrganizationID;

@property (nonatomic, strong) NSString *merchantCityID;

@property (nonatomic, strong) NSString *merchantBank;

@property (nonatomic, strong) NSString *merchantBankID;

@property (nonatomic, strong) NSString *frontPath;  //身份证正面照

@property (nonatomic, strong) NSString *backPath;   //反面照

@property (nonatomic, strong) NSString *bodyPath;   //上半身照

@property (nonatomic, strong) NSString *licensePath;  //营业执照

@property (nonatomic, strong) NSString *taxPath;     //税务证照

@property (nonatomic, strong) NSString *organizationPath;  //组织机构代码照

@property (nonatomic, strong) NSString *bankPath;   //开户银行照

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
