//
//  GoodAgentListController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "GoodAgentModel.h"

typedef enum {
    AgentStyleNone = 0,
    AgentStyleFrom,
    AgentStyleTo,
}AgentStyle; //用于调货

@protocol GoodAgentSelectedDelegate <NSObject>

- (void)getSelectedGoodAgent:(GoodAgentModel *)model style:(AgentStyle)style;

@end

@interface GoodAgentListController : CommonViewController

@property (nonatomic, assign) id<GoodAgentSelectedDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *agentList;

@property (nonatomic, assign) AgentStyle style;

@end
