//
//  SettingViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/4/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SettingViewController.h"
#import "SDImageCache.h"
#import "BPush.h"
#import "NetworkInterface.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemNames;

@property (nonatomic, strong) UISwitch *switchButton;

@property (nonatomic, strong) NSString *updateURL;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    //初始化静态数据
    [self initStaticData];
    [self initAndLauoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18 * kScaling)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    CGFloat borderSpace = 20.f;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, 0, kScreenWidth - borderSpace * 2, 40)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:13.f];
    tipLabel.textColor = kColor(109, 109, 114, 1);
    tipLabel.text = @"若需要开启推送，请同时确保在iPhone的“设置”-“通知”中也开启推送通知！";
    tipLabel.numberOfLines = 0;
    [footerView addSubview:tipLabel];
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
    _switchButton = [[UISwitch alloc] init];
    _switchButton.onTintColor = kMainColor;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isOn = NO;
    if (![userDefault objectForKey:@"PushStatus"]) {
        isOn = YES;
    }
    else {
        isOn = [[userDefault objectForKey:@"PushStatus"] boolValue];
    }
    _switchButton.on = isOn;
    [_switchButton addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Request

- (void)checkVersion {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在检测...";
    [NetworkInterface checkVersionFinished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"%@",object);
                    id infoDict = [object objectForKey:@"result"];
                    if ([infoDict isKindOfClass:[NSDictionary class]]) {
                        int serviceVersion = [[infoDict objectForKey:@"versions"] intValue];
                        _updateURL = [infoDict objectForKey:@"down_url"];
                        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                        if ([localVersion intValue] >= serviceVersion) {
                            hud.labelText = @"已经是最新版本";
                        }
                        else {
                            hud.hidden = YES;
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                                message:@"发现新版本，是否前往下载？"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"取消"
                                                                      otherButtonTitles:@"前往下载", nil];
                            [alertView show];
                        }
                        
                    }
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)initStaticData {
    _itemNames = [NSArray arrayWithObjects:
                  @"接收新通知",
                  @"检测版本更新",
                  @"清除缓存",
                  nil];
}

- (void)clearDisk {
    [[SDImageCache sharedImageCache] clearDisk];
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)changeValue:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:_switchButton.isOn] forKey:@"PushStatus"];
    [userDefault synchronize];
    NSString *message = @"";
    if (_switchButton.isOn) {
        [BPush bindChannel];
        message = @"您已成功开启消息推送，请确保在iPhone的“设置”-“通知”中也开启推送通知！";
    }
    else {
        [BPush unbindChannel];
        message = @"您已成功关闭消息推送，在应用进入后台后您将不会收到推送消息！";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
   // return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.row == 0) {
        _switchButton.frame = CGRectMake(kScreenWidth - 60, 6, 40, 30);
        [cell.contentView addSubview:_switchButton];
    }
    
    else if (indexPath.row == 1) {
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@",localVersion];
    }
    
    else if (indexPath.row == 2) {
        NSUInteger bitSize = [[SDImageCache sharedImageCache] getSize];
        long MB = 1024 * 1024;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",((float)bitSize / MB)];
    }
    if (indexPath.row <= [_itemNames count]) {
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.textLabel.text = [_itemNames objectAtIndex:indexPath.row];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
        }
            break;
            
        case 1: {
            [self checkVersion];
        }
            break;
            
        case 2: {
            [self clearDisk];
        }
            break;
        default:
            break;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
    }
}

@end

