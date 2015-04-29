//
//  TMTerminalListController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"

//选中的终端通知
static NSString *getSelectedTerminalsNotification = @"getSelectedTerminalsNotification";

static NSString *kTMTermainalList = @"kTMTermainalList";

@interface TMTerminalListController : RefreshViewController

@property (nonatomic, strong) NSMutableArray *terminalList;

//是否是根据输入终端号查询
@property (nonatomic, assign) BOOL fromInput;

//筛选条件
@property (nonatomic, strong) NSString *POSName;
@property (nonatomic, strong) NSString *channellID;
@property (nonatomic, assign) CGFloat maxPrice;
@property (nonatomic, assign) CGFloat minPrice;

@end
