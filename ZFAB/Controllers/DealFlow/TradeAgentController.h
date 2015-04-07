//
//  TradeAgentController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "TradeAgentModel.h"

@protocol TradeAgentDelegate <NSObject>

- (void)getSelectedAgent:(TradeAgentModel *)agentModel;

@end

@interface TradeAgentController : CommonViewController

@property (nonatomic, assign) id<TradeAgentDelegate>delegate;

//代理商数组
@property (nonatomic, strong) NSMutableArray *agentItem;

@end
