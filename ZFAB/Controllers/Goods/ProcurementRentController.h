//
//  ProcurementRentController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderConfirmController.h"
#import "GoodDetailModel.h"

@interface ProcurementRentController : OrderConfirmController

@property (nonatomic, strong) GoodDetailModel *goodDetail;

@end
