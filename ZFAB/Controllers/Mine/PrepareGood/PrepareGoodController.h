//
//  PrepareGoodController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

static NSString *PGSelectedTerminalNotification = @"PGSelectedTerminalNotification";

static NSString *kPGTerminal = @"kPGTerminal";

static NSString *kPGChannel = @"kPGChannel";

static NSString *kPGGood = @"kPGGood";

@interface PrepareGoodController : CommonViewController

@property (nonatomic, strong) NSMutableArray *agentList;

@end
