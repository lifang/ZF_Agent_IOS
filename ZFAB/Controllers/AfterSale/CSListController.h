//
//  CSListController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
#import "NetworkInterface.h"

@interface CSListController : RefreshViewController

//售后类型 1.售后单记录 2.更新资料记录 3.注销记录
@property (nonatomic, assign) CSType csType;

@end
