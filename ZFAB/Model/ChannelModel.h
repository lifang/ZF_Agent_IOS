//
//  ChannelModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GoodRateNone = 0,
    GoodRateDate,      //资金服务费
    GoodRateStand,     //刷卡交易标准手续费
    GoodRateOther,     //其它交易费率
}GoodRateType;

@interface OpenMaterialModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *introduction;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

@interface GoodRateModel : NSObject

@property (nonatomic, strong) NSString *rateID;

@property (nonatomic, strong) NSString *rateName;

@property (nonatomic, assign) CGFloat ratePercent;

@property (nonatomic, strong) NSString *rateDescription;

- (id)initWithParseDictionary:(NSDictionary *)dict
                     rateType:(GoodRateType)type;

@end

@interface ChannelModel : NSObject

//支付通道id
@property (nonatomic, strong) NSString *channelID;
//支付通道name
@property (nonatomic, strong) NSString *channelName;
//申请开通条件
@property (nonatomic, strong) NSString *openRequirement;
//支付通道开通费用
@property (nonatomic, assign) CGFloat openCost;
//YES 支持区域  NO 不支持区域
@property (nonatomic, assign) BOOL supportType;
//支付通道支持区域
@property (nonatomic, strong) NSMutableArray *supportAreaItem;
//资金服务费
@property (nonatomic, strong) NSMutableArray *dateRateItem;
//标准手续费
@property (nonatomic, strong) NSMutableArray *standRateItem;
//其它交易费
@property (nonatomic, strong) NSMutableArray *otherRateItem;
//开通对私材料
@property (nonatomic, strong) NSString *privateInfo;
//开通对公材料
@property (nonatomic, strong) NSString *publicInfo;
//申请开通资料（代替开通对公对私材料）
@property (nonatomic, strong) NSString *openInfo;

//支付通道厂家信息
@property (nonatomic, strong) NSString *channelFactoryDescription;
@property (nonatomic, strong) NSString *channelFactoryURL;
@property (nonatomic, strong) NSString *channelFactoryLogo;

@property (nonatomic, assign) BOOL canCanceled;

//是否已经加载过详情
@property (nonatomic, assign) BOOL isAlreadyLoad;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
