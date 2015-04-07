//
//  CreateViewController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/**************************

注册界面和创建下级代理商父类

**************************/

#import "ScanImageViewController.h"
#import "NetworkInterface.h"

static NSString *key_company = @"key_company";
static NSString *key_license = @"key_license";
static NSString *key_tax = @"key_tax";

static NSString *key_person = @"key_person";
static NSString *key_personCardID = @"key_personCardID";
static NSString *key_phone = @"key_phone";
static NSString *key_email = @"key_email";
static NSString *key_city = @"key_city";
static NSString *key_address = @"key_address";

static NSString *key_cardImage = @"key_cardImage";
static NSString *key_licenseImage = @"key_licenseImage";
static NSString *key_taxImage = @"key_taxImage";

@interface CreateViewController : ScanImageViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmField;

//代理商类型
@property (nonatomic, assign) AgentType agentType;

@property (nonatomic, strong) UISegmentedControl *segmentControl;
//保存用户注册输入字段的内容，key为头文件中定义的static字符串
@property (nonatomic, strong) NSMutableDictionary *registerDict;

- (IBAction)typeChanged:(id)sender;
- (void)dataValidation; //数据验证

@end
