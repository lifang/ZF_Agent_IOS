//
//  TradeDetailController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"

@interface TradeDetailController : CommonViewController

@property (nonatomic, strong) NSString *tradeID;
@property (nonatomic, assign) TradeType tradeType;

@end
