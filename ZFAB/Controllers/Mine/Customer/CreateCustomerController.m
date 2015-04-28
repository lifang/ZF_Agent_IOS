//
//  CreateCustomerController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CreateCustomerController.h"
#import "SelectedModel.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "CustomerManagerController.h"

@interface CreateCustomerController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *realnameField;

@property (nonatomic, strong) UITextField *usernameField;

@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UITextField *confirmField;

@property (nonatomic, strong) NSMutableArray *authorityItem;

//详情字段
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *authString;

@end

@implementation CreateCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setStatisticData];
    [self initAndLauoutUI];
    if (_type == CustomerTypeModify) {
        self.title = @"员工详情";
        [self getCustomerDetail];
        _realnameField.userInteractionEnabled = NO;
        _usernameField.userInteractionEnabled = NO;
//        _passwordField.userInteractionEnabled = NO;
//        _confirmField.userInteractionEnabled = NO;
    }
    else {
        self.title = @"创建员工账号";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(createCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLauoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    _realnameField = [[UITextField alloc] init];
    [self setAttrForTextField:_realnameField withPlaceholder:@"姓名"];
    _usernameField = [[UITextField alloc] init];
    [self setAttrForTextField:_usernameField withPlaceholder:@"登录ID"];
    _passwordField = [[UITextField alloc] init];
    [self setAttrForTextField:_passwordField withPlaceholder:@"密码"];
    _passwordField.secureTextEntry = YES;
    _confirmField = [[UITextField alloc] init];
    [self setAttrForTextField:_confirmField withPlaceholder:@"确认密码"];
    _confirmField.secureTextEntry = YES;

}

- (void)setAttrForTextField:(UITextField *)textField withPlaceholder:(NSString *)placeholder {
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:15.f];
    UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = placeView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Request

- (void)createCustomer {
    NSArray *authList = [self getSelectedAuthority];
    NSString *authString = [authList componentsJoinedByString:@","];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface createCustomerWithAgentID:delegate.agentID token:delegate.token realName:_realnameField.text loginName:_usernameField.text passoword:_passwordField.text confirmPwd:_confirmField.text authority:authString finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    hud.labelText = @"创建员工成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCustomerListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

- (void)getCustomerDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getCustomerDetailWitgAgentID:delegate.agentID token:delegate.token employeeID:_customer.ID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    id detailDict = [object objectForKey:@"result"];
                    if ([detailDict isKindOfClass:[NSDictionary class]]) {
                        _realName = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"name"]];
                        _loginName = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"loginId"]];
                        _authString = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"rolesStr"]];
                        [self fillDetailInfo];
                    }
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

- (void)modifyCustomer {
    NSArray *authList = [self getSelectedAuthority];
    NSString *authString = [authList componentsJoinedByString:@","];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyCustomerWithToken:delegate.token employeeID:_customer.ID authority:authString password:_passwordField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"保存成功";
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)fillDetailInfo {
    _realnameField.text = _realName;
    _usernameField.text = _loginName;
    NSArray *authList = [_authString componentsSeparatedByString:@","];
    for (NSString *auth in authList) {
        for (SelectedModel *model in _authorityItem) {
            if ([auth isEqualToString:model.ID]) {
                model.isSelected = YES;
                break;
            }
        }
    }
    [_tableView reloadData];
}

- (NSArray *)getSelectedAuthority {
    NSMutableArray *IDs = [[NSMutableArray alloc] init];
    for (SelectedModel *model in _authorityItem) {
        if (model.isSelected) {
            [IDs addObject:model.ID];
        }
    }
    return IDs;
}

- (void)setStatisticData {
    _authorityItem = [[NSMutableArray alloc] initWithObjects:
                      [[SelectedModel alloc] initWithName:@"批购" AndID:@"1"],
                      [[SelectedModel alloc] initWithName:@"代购" AndID:@"2"],
                      [[SelectedModel alloc] initWithName:@"终端管理/售后记录" AndID:@"3"],
                      [[SelectedModel alloc] initWithName:@"交易分润/POS分润" AndID:@"4"],
                      [[SelectedModel alloc] initWithName:@"管理下级代理商" AndID:@"5"],
                      [[SelectedModel alloc] initWithName:@"管理用户" AndID:@"6"],
                      [[SelectedModel alloc] initWithName:@"员工账号" AndID:@"7"],
                      [[SelectedModel alloc] initWithName:@"代理商资料" AndID:@"8"],
                      [[SelectedModel alloc] initWithName:@"库存" AndID:@"9"],
                      nil];
    
}

#pragma mark - Action

- (IBAction)createCustomer:(id)sender {
    if (!_realnameField.text || [_realnameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"姓名不能为空";
        return;
    }
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"登录ID不能为空";
        return;
    }
    if (_type == CustomerTypeCreate) {
        if (!_confirmField.text || [_passwordField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请输入密码";
            return;
        }
        if (!_confirmField.text || [_confirmField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请再次输入密码";
            return;
        }
        if (![_confirmField.text isEqualToString:_passwordField.text]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"两次输入的密码不一致";
            return;
        }
        if ([_passwordField.text length] < 6 || [_passwordField.text length] > 20) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"密码长度为6-20位字符";
            return;
        }
        [_realnameField becomeFirstResponder];
        [_realnameField resignFirstResponder];
        [self createCustomer];
    }
    else {
        [_passwordField becomeFirstResponder];
        [_passwordField resignFirstResponder];
        if ((_passwordField.text && ![_passwordField.text isEqualToString:@""]) ||
            (_confirmField.text && ![_confirmField.text isEqualToString:@""])) {
            if (![_confirmField.text isEqualToString:_passwordField.text]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"两次输入的密码不一致";
                return;
            }
            if ([_passwordField.text length] < 6 || [_passwordField.text length] > 20) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"密码长度为6-20位字符";
                return;
            }
        }
        [self modifyCustomer];
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 4;
            break;
        case 1:
            row = [_authorityItem count];
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            switch (indexPath.row) {
                case 0: {
                    //姓名
                    _realnameField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_realnameField];
                }
                    break;
                case 1: {
                    //登录名
                    _usernameField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_usernameField];
                }
                    break;
                case 2: {
                    //密码
                    _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_passwordField];
                }
                    break;
                case 3: {
                    //确认密码
                    _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_confirmField];
                }
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 1: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            SelectedModel *model = [_authorityItem objectAtIndex:indexPath.row];
            if (model.isSelected) {
                cell.imageView.image = kImageName(@"btn_selected.png");
            }
            else {
                cell.imageView.image = kImageName(@"btn_unselected.png");
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.textLabel.text = model.itemName;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        SelectedModel *model = [_authorityItem objectAtIndex:indexPath.row];
        model.isSelected = !model.isSelected;
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (model.isSelected) {
            cell.imageView.image = kImageName(@"btn_selected.png");
        }
        else {
            cell.imageView.image = kImageName(@"btn_unselected.png");
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 25.f;
    }
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        footView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.text = @"选择员工权限：";
        [footView addSubview:titleLabel];
        return footView;
    }
    return nil;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
