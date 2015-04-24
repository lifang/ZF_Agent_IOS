//
//  MineViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MineViewController.h"
#import "PersonInfoController.h"
#import "AgentManagerController.h"
#import "CustomerManagerController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "SettingViewController.h"

static NSString *s_phoneNumber = @"4000908076";

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    [self initAndLauoutUI];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"setting.png")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(goSetting:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20 * kScaling)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame = CGRectMake(80, 80, kScreenWidth - 160, 40);
    signOut.layer.cornerRadius = 4;
    signOut.layer.masksToBounds = YES;
    signOut.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [signOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [signOut setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [signOut addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signOut];
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
}

#pragma mark - Action

- (IBAction)goSetting:(id)sender {
    SettingViewController *settingC = [[SettingViewController alloc] init];
    settingC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingC animated:YES];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 3;
            break;
        case 1:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSString *titleName = nil;
    NSString *imageName = nil;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    titleName = @"我的信息";
                    break;
                case 1:
                    titleName = @"下级代理商管理";
                    break;
                case 2:
                    titleName = @"员工管理";
                    break;
                default:
                    break;
            }
            imageName = [NSString stringWithFormat:@"mine%ld.png",indexPath.row + 1];
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                titleName = @"呼叫掌富400-090-8076";
                imageName = @"mine4.png";
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.text = titleName;
    cell.imageView.image = kImageName(imageName);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    //我的信息
                    AppDelegate *delegate = [AppDelegate shareAppDelegate];
                    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthAR]] boolValue]) {
                        PersonInfoController *personC = [[PersonInfoController alloc] init];
                        personC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:personC animated:YES];
                    }
                    else {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.customView = [[UIImageView alloc] init];
                        hud.mode = MBProgressHUDModeCustomView;
                        [hud hide:YES afterDelay:1.f];
                        hud.labelText = @"没有代理商资料权限";
                    }
                }
                    break;
                case 1: {
                    //下级代理商管理
                    AppDelegate *delegate = [AppDelegate shareAppDelegate];
                    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthSubAgent]] boolValue]) {
                        AgentManagerController *agentC = [[AgentManagerController alloc] init];
                        agentC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:agentC animated:YES];
                    }
                    else {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.customView = [[UIImageView alloc] init];
                        hud.mode = MBProgressHUDModeCustomView;
                        [hud hide:YES afterDelay:1.f];
                        hud.labelText = @"没有管理下级代理商权限";
                    }
                }
                    break;
                case 2: {
                    //我的员工
                    AppDelegate *delegate = [AppDelegate shareAppDelegate];
                    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthEA]] boolValue]) {
                        CustomerManagerController *customerC = [[CustomerManagerController alloc] init];
                        customerC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:customerC animated:YES];
                    }
                    else {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.customView = [[UIImageView alloc] init];
                        hud.mode = MBProgressHUDModeCustomView;
                        [hud hide:YES afterDelay:1.f];
                        hud.labelText = @"没有员工账号权限";
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话？"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:s_phoneNumber
                                                      otherButtonTitles:nil];
            [sheet showFromTabBar:self.tabBarController.tabBar];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action

- (IBAction)signOut:(id)sender {
//    [[AppDelegate shareAppDelegate] loginOut];
    [[[AppDelegate shareAppDelegate] rootViewController] showLoginViewController];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",s_phoneNumber]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}

@end
