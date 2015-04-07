//
//  AddressEditController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "AddressModel.h"

typedef enum {
    AddressModify = 1,  //修改
    AddressAdd,         //添加
}AddressFunction;

static NSString *RefreshAddressListNotification = @"RefreshAddressListNotification";

@interface AddressEditController : CommonViewController

@property (nonatomic, assign) AddressFunction type;

@property (nonatomic, strong) AddressModel *address;

@end
