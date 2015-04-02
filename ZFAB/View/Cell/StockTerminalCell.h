//
//  StockTerminalCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockTerminalModel.h"

#define kStockTermainalCellHeight 44.f

@interface StockTerminalCell : UITableViewCell

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *statusLabel;

- (void)setContentWithData:(StockTerminalModel *)model;

@end
