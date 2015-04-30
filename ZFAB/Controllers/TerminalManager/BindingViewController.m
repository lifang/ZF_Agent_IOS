//
//  BindingViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "BindingViewController.h"
#import "UserListViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface BindingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,SelectedUserDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UserModel *selectedUser;

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"为用户绑定";
    [self initAndLauoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(userBinding:) forControlEvents:UIControlEventTouchUpInside];
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
    _inputField = [[UITextField alloc] init];
    _inputField.borderStyle = UITextBorderStyleNone;
    _inputField.backgroundColor = [UIColor clearColor];
    _inputField.delegate = self;
    _inputField.placeholder = @"填写终端号";
    _inputField.font = [UIFont systemFontOfSize:15.f];
    UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    _inputField.leftView = placeView;
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Request

- (void)bindingForUser {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface bindingTerminalWithAgentID:delegate.agentID token:delegate.token userID:_selectedUser.userID terminalNumber:_inputField.text finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"绑定成功";
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

#pragma mark - Action

- (IBAction)userBinding:(id)sender {
    if (!_selectedUser) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择用户";
        return;
    }
    if (!_inputField.text || [_inputField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写终端号";
        return;
    }
    [self bindingForUser];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];;
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.textLabel.text = @"选择用户";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.text = _selectedUser.userName;
        }
            break;
        case 1: {
            //填写终端
            _inputField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_inputField];
        }
            break;
        default:
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UserListViewController *listC = [[UserListViewController alloc] init];
        listC.delegate = self;
        [self.navigationController pushViewController:listC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SelectedUserDelegate

- (void)selectedUser:(UserModel *)model {
    _selectedUser = model;
    [_tableView reloadData];
}

@end
