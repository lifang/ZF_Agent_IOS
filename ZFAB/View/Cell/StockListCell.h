//
//  StockListCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "StockListModel.h"

@protocol StockCellDelegate <NSObject>

- (void)stockCellRenameForGood:(StockListModel *)model;

- (void)stockCellGoWholesale:(StockListModel *)model;

@end

#define kStockCellHeight 152.f

@interface StockListCell : UITableViewCell

@property (nonatomic, assign) id<StockCellDelegate>delegate;

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

@property (nonatomic, strong) UILabel *historyCountLabel;

@property (nonatomic, strong) UILabel *openCountLabel;

@property (nonatomic, strong) UILabel *agentCountLabel;

@property (nonatomic, strong) UILabel *totalCountLabel;

@property (nonatomic, strong) UIButton *nameButton;

@property (nonatomic, strong) UIButton *wholesaleButton;

@property (nonatomic, strong) StockListModel *stockModel;

- (void)setContentWithData:(StockListModel *)model;

@end
