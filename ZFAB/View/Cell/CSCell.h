//
//  CSCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDataHandle.h"

#define kCSCellShortHeight 65.f
#define kCSCellLongHeight  121.f

@protocol CSCellDelegate <NSObject>

- (void)CSCellCancelApplyWithData:(CSModel *)model;

- (void)CSCellRepeatApplyWithData:(CSModel *)model;

@end

@interface CSCell : UITableViewCell

@property (nonatomic, assign) id<CSCellDelegate>delegate;

@property (nonatomic, strong) UILabel *csNumberLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, assign) CSType csType;   //售后类型

@property (nonatomic, strong) CSModel *cellData;

- (void)setContentsWithData:(CSModel *)data;

- (id)initWithCSType:(CSType)csType
     reuseIdentifier:(NSString *)reuseIdentifier;

@end
