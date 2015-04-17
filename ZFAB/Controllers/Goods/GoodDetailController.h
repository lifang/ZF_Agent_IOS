//
//  GoodDetailController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"

@interface GoodDetailController : CommonViewController

@property (nonatomic, strong) NSString *goodID;

@property (nonatomic, assign) SupplyGoodsType supplyType;

@end
