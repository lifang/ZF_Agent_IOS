//
//  StockListModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

/*库存列表对象*/
@interface StockListModel : NSObject

//商品名
@property (nonatomic, strong) NSString *stockTitle;
//商品id
@property (nonatomic, strong) NSString *stockGoodID;
//商品品牌
@property (nonatomic, strong) NSString *stockGoodBrand;
//商品型号
@property (nonatomic, strong) NSString *stockGoodModel;
//支付通道
@property (nonatomic, strong) NSString *stockChannel;
//支付通道id
@property (nonatomic, strong) NSString *stockChannelID;
//图片地址
@property (nonatomic, strong) NSString *stockImagePath;
//历史进货量
@property (nonatomic, assign) int historyCount;
//总库存
@property (nonatomic, assign) int totalCount;
//开通数量
@property (nonatomic, assign) int openCount;
//代理商库存
@property (nonatomic, assign) int agentCount;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
