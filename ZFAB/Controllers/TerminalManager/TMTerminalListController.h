//
//  TMTerminalListController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

//选中的终端通知
static NSString *getSelectedTerminalsNotification = @"getSelectedTerminalsNotification";

static NSString *kTMTermainalList = @"kTMTermainalList";

@interface TMTerminalListController : CommonViewController

@property (nonatomic, strong) NSMutableArray *terminalList;

@end
