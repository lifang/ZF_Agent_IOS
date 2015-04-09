//
//  ChannelSelectedController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "ChannelListModel.h"

@protocol ChannelSelectedDelegate <NSObject>

- (void)getChannelList:(ChannelListModel *)model
             billModel:(BillingModel *)billModel;

@end

@interface ChannelSelectedController : CommonViewController

@property (nonatomic, assign) id<ChannelSelectedDelegate>delegate;

@end
