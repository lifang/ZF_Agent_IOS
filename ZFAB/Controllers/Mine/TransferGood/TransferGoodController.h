//
//  TransferGoodController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

static NSString *TGSelectedTerminalNotification = @"TGSelectedTerminalNotification";

static NSString *kTGTerminal = @"kTGTerminal";

@interface TransferGoodController : CommonViewController

@property (nonatomic, strong) NSMutableArray *agentList;

@end
