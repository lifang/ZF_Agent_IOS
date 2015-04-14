//
//  PrepareGoodCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrepareGoodModel.h"

#define kPrepareGoodCellHeight 80.f

@interface PrepareGoodCell : UITableViewCell

@property (nonatomic, strong) UILabel *agentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *countLabel;

- (void)setContentWithData:(PrepareGoodModel *)model;

@end
