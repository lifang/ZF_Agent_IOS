//
//  StockAgentCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockAgentModel.h"

#define kStockAgentCellHeight 60.f

@interface StockAgentCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *totalCountLabel;

@property (nonatomic, strong) UILabel *openCountLabel;

@property (nonatomic, strong) UILabel *prepareTimeLabel;

@property (nonatomic, strong) UILabel *openTimeLabel;

@property (nonatomic, strong) UIImageView *arrowView;

- (void)setContentWithData:(StockAgentModel *)model;

@end
