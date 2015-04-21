//
//  TradeTypeModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*分润获取消费类型*/
#import <Foundation/Foundation.h>

@interface TradeTypeModel : NSObject

@property (nonatomic, strong) NSString *tradeName;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *channelName;

@property (nonatomic, assign) CGFloat percent;

//分润列表解析类型
- (id)initWithGetListParseDictionary:(NSDictionary *)dict;
//支付通道获取消费类型
- (id)initWithGetTypeParseDictionary:(NSDictionary *)dict;

@end
