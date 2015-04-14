//
//  PGInputTerminalController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

@protocol PGTerminalDelegate <NSObject>

- (void)getTerminalListString:(NSString *)terminalListString;

@end

@interface PGInputTerminalController : CommonViewController

@property (nonatomic, assign) id<PGTerminalDelegate>delegate;

@end
