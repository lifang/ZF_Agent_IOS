//
//  BenefitListController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

static NSString *RefreshBenefitListNotification = @"RefreshBenefitListNotification";

@interface BenefitListController : CommonViewController

@property (nonatomic, strong) NSString *subAgentID;

@end
