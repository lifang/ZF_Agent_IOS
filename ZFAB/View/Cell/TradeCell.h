//
//  TradeCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/27.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kTradeCellHeight  92.f

#import <UIKit/UIKit.h>
#import "TradeModel.h"
#import "NetworkInterface.h"

@interface TradeCell : UITableViewCell

@property (nonatomic, strong) UILabel *tradeTimeLabel;
@property (nonatomic, strong) UILabel *payFromLabel;
@property (nonatomic, strong) UILabel *payToLabel;
@property (nonatomic, strong) UILabel *terminalLabel;

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *priceLabel;

- (void)setContentWithData:(TradeModel *)tradeModel
             withTradeType:(TradeType)tradeType;

@end
