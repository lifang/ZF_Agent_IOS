//
//  GoodListModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

/*商品列表对象*/
@interface GoodListModel : NSObject

///商品ID
@property (nonatomic, strong) NSString *goodID;
///商品名
@property (nonatomic, strong) NSString *goodName;
///商品品牌
@property (nonatomic, strong) NSString *goodBrand;
///商品型号
@property (nonatomic, strong) NSString *goodModel;
///商品支付通道
@property (nonatomic, strong) NSString *goodChannel;
///是否可租赁
@property (nonatomic, assign) BOOL isRent;
///商品原价
@property (nonatomic, assign) CGFloat goodPrimaryPrice;
///商品批购价
@property (nonatomic, assign) CGFloat goodWholesalePrice;
///商品评分
@property (nonatomic, strong) NSString *goodScore;
///商品图片URL
@property (nonatomic, strong) NSString *goodImagePath;
///商品已售数量
@property (nonatomic, assign) int goodSaleNumber;
///最小批购量
@property (nonatomic, assign) int minWholesaleNumber;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
