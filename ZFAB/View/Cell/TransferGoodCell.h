//
//  TransferGoodCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferGoodModel.h"

#define kTransferGoodCellHeight 80.f

@interface TransferGoodCell : UITableViewCell

@property (nonatomic, strong) UILabel *fromLabel;

@property (nonatomic, strong) UILabel *toLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *countLabel;

- (void)setContentWithData:(TransferGoodModel *)model;

@end
