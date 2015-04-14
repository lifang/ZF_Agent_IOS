//
//  StockTerminalModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StockTerminalStatusNone = 0,
    StockTerminalStatusOpened,       //已开通
    StockTerminalStatusPartOpened,   //部分开通
    StockTerminalStatusUnOpened,     //未开通
    StockTerminalStatusCanceled,     //已注销
    StockTerminalStatusStopped,      //已停用
}StockTerminalStatus;

/*库存终端列表*/
@interface StockTerminalModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *terminalBrand;

@property (nonatomic, strong) NSString *terminalModel;

@property (nonatomic, strong) NSString *terminalNumber;

@property (nonatomic, assign) StockTerminalStatus openStatus;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getOpenStatusString;

@end
