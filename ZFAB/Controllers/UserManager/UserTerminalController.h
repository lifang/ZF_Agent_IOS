//
//  UserTerminalController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
#import "UserModel.h"

static NSString *RefreshUserListNotification = @"RefreshUserListNotification";

static NSString *userForDelete = @"userForDelete"; //删除的用户

@interface UserTerminalController : RefreshViewController

@property (nonatomic, strong) UserModel *userModel;

@end
