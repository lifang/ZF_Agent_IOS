//
//  PersonModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

/*我的信息*/
@interface PersonModel : NSObject

@property (nonatomic, strong) NSString *personID;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *companyName;

@property (nonatomic, strong) NSString *licenseNumber;

@property (nonatomic, strong) NSString *taxNumber;

@property (nonatomic, strong) NSString *personName;

@property (nonatomic, strong) NSString *personCardID;

@property (nonatomic, strong) NSString *mobileNumber;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *cardImagePath;

@property (nonatomic, strong) NSString *licenseImagePath;

@property (nonatomic, strong) NSString *taxImagePath;
///用户名
@property (nonatomic, strong) NSString *userName;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
