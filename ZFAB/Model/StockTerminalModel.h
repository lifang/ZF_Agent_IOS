//
//  StockTerminalModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TerminalStatusNone = 0,
    TerminalStatusOpened,       //已开通
    TerminalStatusPartOpened,   //部分开通
    TerminalStatusUnOpened,     //未开通
    TerminalStatusCanceled,     //已注销
    TerminalStatusStopped,      //已停用
}TerminalStatus;

/*库存终端列表*/
@interface StockTerminalModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *terminalBrand;

@property (nonatomic, strong) NSString *terminalModel;

@property (nonatomic, strong) NSString *terminalNumber;

@property (nonatomic, assign) TerminalStatus openStatus;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getOpenStatusString;

@end
