//
//  StockRenameController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "StockListModel.h"

static NSString *EditStockGoodNameNotification = @"EditStockGoodNameNotification";

@interface StockRenameController : CommonViewController

@property (nonatomic, strong) StockListModel *stockModel;

@end
