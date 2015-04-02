//
//  ModuleView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/***********模块按钮***********/

typedef enum {
    ModuleNone = 0,
    ///我要进货
    ModuleBuy,
    ///订单管理
    ModuleOrderManager,
    ///库存管理
    ModuleStockManager,
    ///交易流水
    ModuletDealFlow,
    ///终端管理
    ModuleTerminalManager,
    ///用户管理
    ModuleUserManager,
    ///售后记录
    ModuleAfterSale,
    ///申请开通
    ModuleOpenApply,
}ModuleViewTag;

#import <UIKit/UIKit.h>

@interface ModuleView : UIButton

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *titleName;

- (void)setTitleName:(NSString *)titleName
           imageName:(NSString *)imageName;

@end
