//
//  MessageDetailController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "MessageModel.h"

static NSString *RefreshMessageListNotification = @"RefreshMessageListNotification";

static NSString *messageForDelete = @"messageForDelete";

@interface MessageDetailController : CommonViewController

@property (nonatomic, strong) MessageModel *message;

@end
