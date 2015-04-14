//
//  GoodAgentListController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "GoodAgentModel.h"

@protocol GoodAgentSelectedDelegate <NSObject>

- (void)getSelectedGoodAgent:(GoodAgentModel *)model;

@end

@interface GoodAgentListController : CommonViewController

@property (nonatomic, assign) id<GoodAgentSelectedDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *agentList;

@end
