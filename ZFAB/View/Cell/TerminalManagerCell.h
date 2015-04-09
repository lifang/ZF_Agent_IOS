//
//  TerminalManagerCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kTMShortCellHeight  56.f
#define kTMMiddleCellHeight 76.f

#import <UIKit/UIKit.h>
#import "TerminalModel.h"

//已开通状态一
static NSString *OpenedFirstStatusIdentifier = @"OpenedFirstStatusIdentifier";
//已开通状态二
static NSString *OpenedSecondStatusIdentifier = @"OpenedSecondStatusIdentifier";
//部分开通
static NSString *PartOpenedStatusIdentifier = @"PartOpenedStatusIdentifier";
//未开通状态一
static NSString *UnOpenedFirstStatusIdentifier = @"UnOpenedFirstStatusIdentifier";
//未开通状态二
static NSString *UnOpenedSecondStatusIdentifier = @"UnOpenedSecondStatusIdentifier";
//已注销
static NSString *CanceledStatusIdentifier = @"CanceledStatusIdentifier";
//已停用
static NSString *StoppedStatusIdentifier = @"StoppedStatusIdentifier";

@interface TerminalManagerCell : UITableViewCell

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) UIImageView *arrowView;  //箭头

- (void)setContentsWithData:(TerminalModel *)data;

@end
