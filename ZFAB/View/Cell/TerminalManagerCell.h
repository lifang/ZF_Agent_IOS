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

static NSString *TMMiddleHeightIdentifier = @"TMMiddleHeightIdentifier";
static NSString *TMShortHeightIdentifier = @"TMShortHeightIdentifier";

@interface TerminalManagerCell : UITableViewCell

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) UIImageView *arrowView;  //箭头

- (void)setContentsWithData:(TerminalModel *)data;

@end
