//
//  PGFilterChannelController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "ChannelListModel.h"

@protocol PGFilterChannelDelegate <NSObject>

- (void)getSelectedPGChannelDelegate:(ChannelListModel *)model;

@end

@interface PGFilterChannelController : CommonViewController

@property (nonatomic, assign) id<PGFilterChannelDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *channelList;

@property (nonatomic, strong) NSString *selectedAgentID;

@end
