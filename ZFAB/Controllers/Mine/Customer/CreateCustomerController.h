//
//  CreateCustomerController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*员工创建、详情*/
#import "CommonViewController.h"
#import "CustomerModel.h"

typedef enum {
    CustomerTypeCreate = 0,   //新建
    CustomerTypeModify,       //修改
}CustomerType;

@interface CreateCustomerController : CommonViewController

@property (nonatomic, assign) CustomerType type;

@property (nonatomic, strong) CustomerModel *customer;

@end
