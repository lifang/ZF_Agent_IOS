//
//  TMFilterChannelController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "ChannelListModel.h"

@protocol TMFilterChannelDelegate <NSObject>

- (void)getSelectedChannel:(ChannelListModel *)channel
              billingModel:(BillingModel *)billing;

@end

@interface TMFilterChannelController : CommonViewController

@property (nonatomic, assign) id<TMFilterChannelDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *channelItems;

@end
