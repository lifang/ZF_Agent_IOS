//
//  PGFilterPOSController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "POSModel.h"

@protocol PGFilterPOSDelegate <NSObject>

- (void)getSelectedPGPOS:(POSModel *)model;

@end

@interface PGFilterPOSController : CommonViewController

@property (nonatomic, assign) id<PGFilterPOSDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *goodList;

@property (nonatomic, strong) NSString *selectedAgentID;

@end
