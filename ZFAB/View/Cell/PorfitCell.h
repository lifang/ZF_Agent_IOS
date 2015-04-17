//
//  PorfitCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfitModel.h"

#define kProfitCellHeight 60.f

@interface PorfitCell : UITableViewCell

@property (nonatomic, strong) UILabel *agentLabel;

@property (nonatomic, strong) UILabel *payProfitLabel;

@property (nonatomic, strong) UILabel *getProfitLabel;

- (void)setContentWithData:(ProfitModel *)model;

@end
