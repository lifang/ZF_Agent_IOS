//
//  SerialSearchCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialModel.h"

@protocol SerialCellDelegate <NSObject>

//点击后刷新选中的个数
- (void)serialCellShouldRefreshSelectedCount;

@end

@interface SerialSearchCell : UITableViewCell

@property (nonatomic, assign) id<SerialCellDelegate>delegate;

@property (nonatomic, strong) UIImageView *selectedImageView;

@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) SerialModel *cellData;

- (void)setContentsWithData:(SerialModel *)model;

- (void)selectedCell;

@end
