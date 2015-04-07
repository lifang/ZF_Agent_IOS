//
//  SubAgentCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"
#import "SubAgentModel.h"

#define kSubAgentCellHeight 80.f

@interface SubAgentCell : UITableViewCell

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *saleCountLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *stockCountLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *openCountLabel;

- (void)setContentWithData:(SubAgentModel *)model;

@end
