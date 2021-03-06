//
//  SelectedAddressController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "AddressCell.h"

static NSString *RefreshSelectedAddressNotification = @"RefreshSelectedAddressNotification";

@protocol SelectedAddressDelegate <NSObject>

- (void)getSelectedAddress:(AddressModel *)addressModel;

@end

@interface SelectedAddressController : CommonViewController

@property (nonatomic, assign) id<SelectedAddressDelegate>delegate;

@property (nonatomic, strong) NSString *addressID; //当前选择的地址id

@property (nonatomic, strong) NSMutableArray *addressItems;

@property (nonatomic, strong) NSString *userID;  //获取哪一个用户的地址

@end
