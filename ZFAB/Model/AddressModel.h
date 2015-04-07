//
//  AddressModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, strong) NSString *addressID;

@property (nonatomic, strong) NSString *addressReceiver;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *addressPhone;

@property (nonatomic, strong) NSString *isDefault;

@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) NSString *zipCode;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
