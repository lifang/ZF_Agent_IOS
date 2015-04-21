//
//  MerchantSelectedController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
#import "OpenApplyModel.h"
#import "MerchantDetailModel.h"

@protocol ApplyMerchantSelectedDelegate <NSObject>

- (void)getSelectedMerchant:(MerchantDetailModel *)model;

@end

@interface MerchantSelectedController : RefreshViewController

@property (nonatomic, assign) id<ApplyMerchantSelectedDelegate>delegate;

@property (nonatomic, strong) NSString *terminalID;

@end
