//
//  StockTerminalController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
#import "StockAgentModel.h"
#import "StockListModel.h"

@interface StockTerminalController : RefreshViewController

@property (nonatomic, strong) StockAgentModel *stockAgent;

@property (nonatomic, strong) StockListModel *stockModel;

@end
