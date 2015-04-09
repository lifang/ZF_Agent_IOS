//
//  OpenApplyCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kOpenApplyCellHeight 112.f

#import <UIKit/UIKit.h>
#import "TerminalModel.h"

@protocol OpenApplyCellDelegate;

static NSString *UnOpenedApplyIdentifier = @"UnOpenedApplyIdentifier";
static NSString *PartOpenedApplyIdentifier = @"PartOpenedApplyIdentifier";

@interface OpenApplyCell : UITableViewCell

@property (nonatomic, assign) id<OpenApplyCellDelegate>delegate;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) TerminalModel *cellData;

- (void)setContentsWithData:(TerminalModel *)data;

@end

@protocol OpenApplyCellDelegate <NSObject>

- (void)openApplyCellOpenWithData:(TerminalModel *)data;

- (void)openApplyCellReopenWithData:(TerminalModel *)data;

@end