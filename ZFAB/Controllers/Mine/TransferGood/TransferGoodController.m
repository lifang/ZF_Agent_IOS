//
//  TransferGoodController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TransferGoodController.h"
#import "GoodAgentListController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "SerialModel.h"
#import "PGSelectedTerminalController.h"

@interface TransferGoodController ()<UITableViewDataSource,UITableViewDelegate,GoodAgentSelectedDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GoodAgentModel *fromAgent;
@property (nonatomic, strong) GoodAgentModel *toAgent;

//选中的终端号数组 通过通知传递
@property (nonatomic, strong) NSArray *selectedTerminalList;

@end

@implementation TransferGoodController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"调货";
    [self initAndLauoutUI];
    if ([_agentList count] <= 0) {
        [self getSubAgent];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTGFilterTerminal:)
                                                 name:TGSelectedTerminalNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitTransderGood:) forControlEvents:UIControlEventTouchUpInside];
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
}

#pragma mark - Request

//下级代理商列表
- (void)getSubAgent {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getGoodSubAgentWithAgentID:delegate.agentID token:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    [self parseSubAgentListWithDictionary:object];
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

//调货
- (void)submitTransferGood {
    NSMutableArray *terminalNumbers = [[NSMutableArray alloc] init];
    for (SerialModel *model in _selectedTerminalList) {
        [terminalNumbers addObject:model.serialNumber];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface transferGoodWithUserID:delegate.userID token:delegate.token fromAgentID:_fromAgent.ID toAgentID:_toAgent.ID terminalList:terminalNumbers finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"调货成功";
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

#pragma mark - Data

- (void)parseSubAgentListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_agentList removeAllObjects];
    NSArray *agentList = [dict objectForKey:@"result"];
    for (int i = 0; i < [agentList count] ; i++) {
        id agentDict = [agentList objectAtIndex:i];
        if ([agentDict isKindOfClass:[NSDictionary class]]) {
            GoodAgentModel *model = [[GoodAgentModel alloc] initWithParseDictionary:agentDict];
            [_agentList addObject:model];
        }
    }
}

- (NSString *)terminalStringWithArray:(NSArray *)terminalList {
    NSString *names = @"";
    for (int i = 0; i < [terminalList count]; i++) {
        SerialModel *model = [terminalList objectAtIndex:i];
        names = [names stringByAppendingString:model.serialNumber];
        if (i != [terminalList count] - 1) {
            names = [names stringByAppendingString:@","];
        }
    }
    return names;
}

#pragma mark - Action

- (IBAction)submitTransderGood:(id)sender {
    if (!_fromAgent.ID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择被调货代理商";
        return;
    }
    if (!_toAgent.ID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择调货代理商";
        return;
    }
    if (!_selectedTerminalList || [_selectedTerminalList count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择终端号";
        return;
    }
    [self submitTransferGood];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSString *title = nil;
    switch (indexPath.section) {
        case 0: {
            title = @"选择从";
            cell.detailTextLabel.text = _fromAgent.name;
        }
            break;
        case 1: {
            title = @"选择到";
            cell.detailTextLabel.text = _toAgent.name;
        }
            break;
        case 2: {
            title = @"选择终端号";
            cell.detailTextLabel.text = [self terminalStringWithArray:_selectedTerminalList];
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.text = title;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            GoodAgentListController *agentC = [[GoodAgentListController alloc] init];
            agentC.delegate = self;
            agentC.style = AgentStyleFrom;
            agentC.agentList = _agentList;
            [self.navigationController pushViewController:agentC animated:YES];
        }
            break;
        case 1: {
            GoodAgentListController *agentC = [[GoodAgentListController alloc] init];
            agentC.delegate = self;
            agentC.style = AgentStyleTo;
            agentC.agentList = _agentList;
            [self.navigationController pushViewController:agentC animated:YES];
        }
            break;
        case 2: {
            if (!_fromAgent.ID || [_fromAgent.ID isEqualToString:@""]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"请选择调货代理商";
            }
            else {
                PGSelectedTerminalController *terminalC = [[PGSelectedTerminalController alloc] init];
                terminalC.filterType = FilterTypeTransferGood;
                terminalC.selectedAgentID = _fromAgent.ID;
                [self.navigationController pushViewController:terminalC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - GoodAgentSelectedDelegate

- (void)getSelectedGoodAgent:(GoodAgentModel *)model style:(AgentStyle)style {
    if (style == AgentStyleFrom) {
        _fromAgent = model;
        _selectedTerminalList = nil;
        [_tableView reloadData];
    }
    else if (style == AgentStyleTo) {
        _toAgent = model;
    }
    [self.tableView reloadData];
}

#pragma mark - NSNotification

- (void)getTGFilterTerminal:(NSNotification *)notification {
    _selectedTerminalList = [notification.userInfo objectForKey:kTGTerminal];
    [_tableView reloadData];
}

@end
