//
//  OrderDetailController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"

@interface OrderDetailController : CommonViewController

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, assign) SupplyGoodsType supplyType;

@end
