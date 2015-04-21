//
//  EditBenefitController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "BenefitModel.h"

typedef enum {
    BenefitPercentModity = 0,       //修改设置分润比例
    BenefitPercentCreate,           //新增设置分润比例
}BenefitPercentType;

@interface EditBenefitController : CommonViewController

@property (nonatomic, assign) BenefitPercentType type;

@property (nonatomic, strong) NSString *subAgentID;

@property (nonatomic, strong) NSString *channelID;

@property (nonatomic, strong) TradeTypeModel *tradeModel;

@end
