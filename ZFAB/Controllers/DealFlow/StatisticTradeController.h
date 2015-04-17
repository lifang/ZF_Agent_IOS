//
//  StatisticTradeController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"

@interface StatisticTradeController : CommonViewController

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, assign) TradeType tradeType;
@property (nonatomic, strong) NSString *terminalNumber;
@property (nonatomic, strong) NSString *subAgentID;

@end
