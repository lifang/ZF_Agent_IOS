//
//  CustomerModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *loginName;

@property (nonatomic, strong) NSString *realName;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
