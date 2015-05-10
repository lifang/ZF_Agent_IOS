//
//  PGTerminalListController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"

typedef enum {
    FilterTypeNone = 0,
    FilterTypePrepareGood,   //配货
    FilterTypeTransferGood,  //调货
}FilterType;

@interface PGTerminalListController : RefreshViewController

//搜索条件
@property (nonatomic, strong) NSMutableArray *terminalFilter;

@property (nonatomic, strong) NSString *POSID;

@property (nonatomic, strong) NSString *channelID;

@property (nonatomic, assign) FilterType filterType;

@property (nonatomic, strong) NSString *selectedAgentID;

@end
