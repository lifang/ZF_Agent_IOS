//
//  OrderConfirmController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "OrderDetailCell.h"
#import "AddressModel.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "UserModel.h"

typedef enum {
    BillTypeCompany,
    BillTypePerson,
}BillType;

typedef enum {
    OrderConfirmTypeProcurementBuy = 3, //代购买
    OrderConfirmTypeProcurementRent,    //代租赁
    OrderConfirmTypeWholesale,          //批购
}OrderConfirmType;

@interface OrderConfirmController : CommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) SupplyGoodsType supplyType; //批购还是代购

@property (nonatomic, assign) OrderConfirmType confirmType;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *addressView;   //地址view

@property (nonatomic, strong) UILabel *nameLabel;  //收件人

@property (nonatomic, strong) UILabel *phoneLabel;  //手机

@property (nonatomic, strong) UILabel *addressLabel;  //地址

@property (nonatomic, strong) UIButton *billBtn;   //是否需要发票按钮

@property (nonatomic, strong) UITextField *billField;  //发票抬头

@property (nonatomic, assign) BillType billType;

@property (nonatomic, strong) AddressModel *defaultAddress;

@property (nonatomic, strong) UserModel *defaultUser;

@property (nonatomic, strong) UITextField *reviewField;  //留言

@property (nonatomic, strong) UILabel *userLabel;

@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) UILabel *deliveryLabel;

@end
