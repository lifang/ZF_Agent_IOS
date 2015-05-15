//
//  ModifyViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/5/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "PersonModel.h"

typedef enum {
    ModifyUserMobile = 1,
    ModifyUserEmail,
}ModifyUserType;

typedef enum {
    EditViewModify = 1,
    EditViewNew,
}EditViewType;

@interface ModifyViewController : CommonViewController

@property (nonatomic, strong) PersonModel *userInfo;

@property (nonatomic, assign) ModifyUserType type;

@property (nonatomic, assign) EditViewType editType;  //修改还是新增

@end
