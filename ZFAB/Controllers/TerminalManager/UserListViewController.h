//
//  UserListViewController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
#import "UserModel.h"

@protocol SelectedUserDelegate <NSObject>

- (void)selectedUser:(UserModel *)model;

@end

@interface UserListViewController : RefreshViewController

@property (nonatomic, assign) id<SelectedUserDelegate>delegate;

@end
