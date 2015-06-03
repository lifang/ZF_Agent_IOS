//
//  TradeRateViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "ChannelModel.h"

//交易费率

@interface TradeRateViewController : CommonViewController

@property (nonatomic, strong) NSArray *tradeRateItem;

@property (nonatomic, strong) ChannelModel *defaultChannel;

@end
