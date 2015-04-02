//
//  StockDetailController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
#import "StockListModel.h"

@interface StockDetailController : RefreshViewController

@property (nonatomic, strong) StockListModel *stockModel;

@end
