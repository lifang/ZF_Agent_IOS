//
//  RateModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*终端管理 表格中的比率*/
#import <Foundation/Foundation.h>

typedef enum {
    RateStatusNone = 0,
    RateStatusOpened,
    RateStatusUnOpened,
}RateStatus;

typedef enum {
    RateTypeNone = 0,
    RateTypeConsume,   //消费
}RateType;

#import <Foundation/Foundation.h>

@interface RateModel : NSObject

@property (nonatomic, strong) NSString *rateID;
@property (nonatomic, strong) NSString *rateName;
@property (nonatomic, assign) CGFloat rateService;
@property (nonatomic, assign) CGFloat rateTerminal;
@property (nonatomic, assign) CGFloat rateBase;
@property (nonatomic, assign) RateStatus rateStatus;
@property (nonatomic, assign) RateType rateType;    //消费类型

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)statusString;

@end
