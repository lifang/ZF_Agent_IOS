//
//  TMFilterPOSController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "POSModel.h"

@protocol TMFilterPOSDelegate <NSObject>

- (void)getSelectedPOS:(POSModel *)model;

@end

@interface TMFilterPOSController : CommonViewController

@property (nonatomic, assign) id<TMFilterPOSDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *goodList;

@end
