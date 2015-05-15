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

//重新申请开通
static NSString *unOpenedApplyFirstIdentifier = @"unOpenedApplyFirstIdentifier";
//申请开通 视频认证弹出提示
static NSString *unOpenedApplySecondIdentifier = @"unOpenedApplySecondIdentifier";
static NSString *partOpenedApplyIdentifier = @"partOpenedApplyIdentifier";

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

- (void)openApplyCellReopenWithData:(TerminalModel *)data identifier:(NSString *)identifier;

@end