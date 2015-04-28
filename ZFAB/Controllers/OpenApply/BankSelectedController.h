//
//  BankSelectedController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
#import "BankModel.h"

@protocol BankSelectedDelegate <NSObject>

- (void)getSelectedBank:(BankModel *)model;

@end

@interface BankSelectedController : RefreshViewController

@property (nonatomic, assign) id<BankSelectedDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) NSString *terminalID;

@property (nonatomic, strong) NSString *key;

@end
