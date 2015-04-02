//
//  CityHandle.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface CityHandle : NSObject

+ (NSArray *)shareIndexList;       //索引数组
+ (NSArray *)shareSectionCityList; //tableview 数据源

+ (NSArray *)shareProvinceList;  //省份数组
+ (NSArray *)shareCityList;      //城市数组

//根据城市id获取城市名
+ (NSString *)getCityNameWithCityID:(NSString *)cityID;

//根据城市id获取省份的index
+ (NSInteger)getProvinceIndexWithCityID:(NSString *)cityID;
+ (NSInteger)getCityIndexWithCityID:(NSString *)cityID;

@end
