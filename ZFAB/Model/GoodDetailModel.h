//
//  GoodDetailModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelModel.h"

//相关商品
@interface RelativeGood : NSObject

@property (nonatomic, strong) NSString *relativeID;

@property (nonatomic, strong) NSString *pictureURL;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) int saleNumber;

@end

@interface GoodDetailModel : NSObject

@property (nonatomic, strong) NSString *goodID;

@property (nonatomic, strong) NSString *goodName;

@property (nonatomic, strong) NSString *detailName;

@property (nonatomic, strong) NSString *goodBrand;

@property (nonatomic, strong) NSString *goodModel;

@property (nonatomic, strong) NSString *goodCategory;

@property (nonatomic, assign) CGFloat primaryPrice;       //商品原价

@property (nonatomic, assign) CGFloat wholesalePrice;     //批购价

@property (nonatomic, assign) CGFloat procurementPrice;   //代购价

@property (nonatomic, assign) int goodComment;   //评论数

@property (nonatomic, strong) NSString *goodMaterial;  //外壳材料

@property (nonatomic, strong) NSString *goodBattery;   //电池

@property (nonatomic, strong) NSString *goodSignWay;   //签购单

@property (nonatomic, strong) NSString *goodEncryptWay;  //加密方式

@property (nonatomic, assign) int goodSaleNumber;  //销售数量

@property (nonatomic, strong) NSString *goodDescription;   //详细说明

@property (nonatomic, assign) int minWholesaleNumber; //最小批购数

@property (nonatomic, assign) int maxTime;   //租赁最长时间
@property (nonatomic, assign) int minTime;   //租赁最短时间
@property (nonatomic, assign) CGFloat deposit;     //押金
@property (nonatomic, assign) CGFloat leasePrice;  //租赁价格
@property (nonatomic, strong) NSString *leaseDescription;  //租赁说明
@property (nonatomic, strong) NSString *leaseProtocol;     //租赁协议

@property (nonatomic, assign) BOOL canRent;

@property (nonatomic, strong) NSMutableArray *goodImageList;

@property (nonatomic, strong) ChannelModel *defaultChannel;

@property (nonatomic, strong) NSMutableArray *channelItem;

@property (nonatomic, strong) NSMutableArray *relativeItem;

//厂家信息
@property (nonatomic, strong) NSString *factoryName;

@property (nonatomic ,strong) NSString *factoryWebsite;

@property (nonatomic, strong) NSString *factorySummary;

@property (nonatomic, strong) NSString *factoryImagePath;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
