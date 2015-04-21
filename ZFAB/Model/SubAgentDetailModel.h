//
//  SubAgentDetailModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubAgentDetailModel : NSObject

@property (nonatomic, assign) int agentType;

@property (nonatomic, assign) BOOL hasProfit;

@property (nonatomic, strong) NSString *companyName;

@property (nonatomic, strong) NSString *licenseNumber;

@property (nonatomic, strong) NSString *taxNumber;

@property (nonatomic, strong) NSString *personName;

@property (nonatomic, strong) NSString *personID;

@property (nonatomic, strong) NSString *mobilePhone;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *provinceName;

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *cardImagePath;

@property (nonatomic, strong) NSString *licenseImagePath;

@property (nonatomic, strong) NSString *taxImagePath;

@property (nonatomic, strong) NSString *loginName;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, assign) int saleCount;

@property (nonatomic, assign) int remainCount;

@property (nonatomic, assign) int openCount;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
