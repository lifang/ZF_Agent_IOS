//
//  TradeTerminalController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

@protocol TradeTerminalDelegate <NSObject>

- (void)getSelectTerminalNumber:(NSString *)terminalNumber;

@end

@interface TradeTerminalController : CommonViewController

@property (nonatomic, assign) id<TradeTerminalDelegate>delegate;

@property (nonatomic, strong) NSString *terminalNumber;

@end
