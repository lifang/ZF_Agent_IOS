//
//  PGSelectedTerminalController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PGSelectedTerminalController.h"
#import "PGInputTerminalController.h"
#import "PGFilterPOSController.h"
#import "PGFilterChannelController.h"
#import "MBProgressHUD.h"

@interface PGSelectedTerminalController ()<UITableViewDataSource,UITableViewDelegate,PGFilterPOSDelegate,PGFilterChannelDelegate,PGTerminalDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *goodList;    //Pos机

@property (nonatomic, strong) NSMutableArray *channelList; //支付通道

@property (nonatomic, strong) POSModel *selectedPOS;

@property (nonatomic, strong) ChannelListModel *selectedChannel;

@property (nonatomic, strong) NSMutableArray *terminalList;

@end

@implementation PGSelectedTerminalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选终端";
    _goodList = [[NSMutableArray alloc] init];
    _channelList = [[NSMutableArray alloc] init];
    [self initAndLauoutUI];
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
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(selectedTerminal:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Action

- (IBAction)selectedTerminal:(id)sender {
    if (!_selectedPOS.ID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择POS机";
        return;
    }
    if (!_selectedChannel.channelID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择支付通道";
        return;
    }
    PGTerminalListController *listC = [[PGTerminalListController alloc] init];
    listC.channelID = _selectedChannel.channelID;
    listC.POSID = _selectedPOS.ID;
    listC.terminalFilter = _terminalList;
    listC.filterType = _filterType;
    if (_filterType == FilterTypeTransferGood) {
        listC.selectedAgentID = _selectedAgentID;
    }
    [self.navigationController pushViewController:listC animated:YES];
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
            title = @"输入终端号";
            cell.detailTextLabel.text = [_terminalList componentsJoinedByString:@","];
        }
            break;
        case 1: {
            title = @"POS机选择";
            cell.detailTextLabel.text = _selectedPOS.title;
        }
            break;
        case 2: {
            title = @"支付通道选择";
            cell.detailTextLabel.text = _selectedChannel.channelName;
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
            PGInputTerminalController *inputC = [[PGInputTerminalController alloc] init];
            inputC.delegate = self;
            if (_terminalList) {
                inputC.searchString = [_terminalList componentsJoinedByString:@"\n"];
            }
            [self.navigationController pushViewController:inputC animated:YES];
        }
            break;
        case 1: {
            PGFilterPOSController *posC = [[PGFilterPOSController alloc] init];
            posC.delegate = self;
            posC.goodList = _goodList;
            if (_filterType == FilterTypeTransferGood) {
                posC.selectedAgentID = _selectedAgentID;
            }
            [self.navigationController pushViewController:posC animated:YES];
        }
            break;
        case 2: {
            PGFilterChannelController *channelC = [[PGFilterChannelController alloc] init];
            channelC.delegate = self;
            channelC.channelList = _channelList;
            if (_filterType == FilterTypeTransferGood) {
                channelC.selectedAgentID = _selectedAgentID;
            }
            [self.navigationController pushViewController:channelC animated:YES];
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

#pragma mark - PGFilterPOSDelegate

- (void)getSelectedPGPOS:(POSModel *)model {
    _selectedPOS = model;
    [_tableView reloadData];
}

#pragma mark - PGFilterChannelDelegate

- (void)getSelectedPGChannelDelegate:(ChannelListModel *)model {
    _selectedChannel = model;
    [_tableView reloadData];
}

#pragma mark - PGTerminalDelegate

- (void)getTerminalListString:(NSString *)terminalListString {
    _terminalList = [NSMutableArray arrayWithArray:[terminalListString componentsSeparatedByString:@"\n"]];
    [_tableView reloadData];
}

@end
