//
//  OrderCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"
#import "OrderModel.h"
#import "UIImageView+WebCache.h"

#define kOrderShortCellHeight 122.f
#define kOrderLongCellHeight 169.f
//批购高度加30.f
#define kFlexibleHeight 30.f

@protocol OrderCellDelegate <NSObject>

- (void)orderCellCancelWholesaleOrder:(OrderModel *)model;
- (void)orderCellPayDepositOrder:(OrderModel *)model;
- (void)orderCellPayWholesaleOrder:(OrderModel *)model;
- (void)orderCellWholesaleRepeat:(OrderModel *)model;
- (void)orderCellCancelProcurementOrder:(OrderModel *)model;
- (void)orderCellPayProcurementOrder:(OrderModel *)model;
- (void)orderCellProcurementRepeat:(OrderModel *)model;

@end

@interface OrderCell : UITableViewCell

@property (nonatomic, assign) id<OrderCellDelegate>delegate;

@property (nonatomic, strong) UILabel *orderNoLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *primaryPriceLabel; //原价

@property (nonatomic, strong) UILabel *actualPriceLabel; //现价

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *brandLabel;

@property (nonatomic, strong) UILabel *channelLabel;

//批购 定金label，代购 归属用户label
@property (nonatomic, strong) UILabel *firstLabel;
//批购 发货数量， 代购 配送费
@property (nonatomic, strong) UILabel *secondLabel;
//批购 剩余金额，代购 实付
@property (nonatomic, strong) UILabel *thirdLabel;
//批购 合计
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) SupplyGoodsType supplyType; //批购、代购类型

@property (nonatomic, strong) OrderModel *cellData;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         supplyType:(SupplyGoodsType)supplyType;

- (void)setContentsWithData:(OrderModel *)data;

@end
