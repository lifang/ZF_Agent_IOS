//
//  TMFilterViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TMFilterViewController.h"
#import "TMFilterPOSController.h"
#import "TMFilterChannelController.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "SerialModel.h"
#import "TMTerminalListController.h"

@interface TMFilterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TMFilterPOSDelegate,TMFilterChannelDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *lowField;

@property (nonatomic, strong) UITextField *highField;

@property (nonatomic, strong) NSMutableArray *goodList;    //Pos机

@property (nonatomic, strong) NSMutableArray *channelList; //支付通道

@property (nonatomic, strong) POSModel *selectedPOS;

@property (nonatomic, strong) ChannelListModel *selectedChannel;

@end

@implementation TMFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选";
    _goodList = [[NSMutableArray alloc] init];
    _channelList = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    signOut.layer.cornerRadius = 4;
    signOut.layer.masksToBounds = YES;
    signOut.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [signOut setTitle:@"确认" forState:UIControlStateNormal];
    [signOut setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [signOut addTarget:self action:@selector(filterFinished:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signOut];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
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
    [self initInputView];
}

- (void)initInputView {
    _lowField = [[UITextField alloc] init];
    _lowField.font = [UIFont systemFontOfSize:14.f];
    _lowField.backgroundColor = [UIColor clearColor];
    _lowField.textAlignment = NSTextAlignmentRight;
    _lowField.placeholder = @"0";
    _lowField.delegate = self;
    _highField = [[UITextField alloc] init];
    _highField.font = [UIFont systemFontOfSize:14.f];
    _highField.backgroundColor = [UIColor clearColor];
    _highField.placeholder = @"0";
    _highField.textAlignment = NSTextAlignmentRight;
    _highField.delegate = self;
}

#pragma mark - Request

- (void)searchWithFilterInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalManagerUseChannelWithToken:delegate.token posTitle:_selectedPOS.title channelID:_selectedChannel.channelID maxPrice:[_highField.text intValue] minPrice:[_lowField.text intValue] finished:^(BOOL success, NSData *response) {
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
                    [self parseSearchListWithData:object];
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

- (void)parseSearchListWithData:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray *searchList = [[NSMutableArray alloc] init];
    NSArray *serialList = [dict objectForKey:@"result"];
    for (int i = 0; i < [serialList count]; i++) {
        id serialDict = [serialList objectAtIndex:i];
        if ([serialDict isKindOfClass:[NSDictionary class]]) {
            SerialModel *model = [[SerialModel alloc] initWithParseDictionary:serialDict];
            [searchList addObject:model];
        }
    }
    TMTerminalListController *listC = [[TMTerminalListController alloc] init];
    listC.terminalList = searchList;
    [self.navigationController pushViewController:listC animated:YES];
}


#pragma mark - Action

- (IBAction)filterFinished:(id)sender {
    BOOL maxIsNumber = [RegularFormat isNumber:_highField.text];
    BOOL minIsNumber = [RegularFormat isNumber:_lowField.text];
    if ((_highField.text && ![_highField.text isEqualToString:@""] && !maxIsNumber) ||
        (_lowField.text && ![_lowField.text isEqualToString:@""] && !minIsNumber)) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"价格必须为正整数";
        return;
    }
    if ([_highField.text intValue] < [_lowField.text intValue]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"最低价不能超过最高价";
        return;
    }
    [self searchWithFilterInfo];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 1;
            break;
        case 2:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            NSString *titleName = nil;
            switch (indexPath.row) {
                case 0:
                    titleName = @"POS机选择";
                    break;
            }
            cell.textLabel.text = titleName;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.text = _selectedPOS.title;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1: {
            NSString *titleName = nil;
            switch (indexPath.row) {
                case 0:
                    titleName = @"支付通道选择";
                    break;
            }
            cell.textLabel.text = titleName;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.text = _selectedChannel.channelName;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"最低价￥";
                    _lowField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
                    [cell.contentView addSubview:_lowField];
                }
                    break;
                case 1: {
                    cell.textLabel.text = @"最高价￥";
                    _highField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
                    [cell.contentView addSubview:_highField];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //POS机
        TMFilterPOSController *posC = [[TMFilterPOSController alloc] init];
        posC.goodList = _goodList;
        posC.delegate = self;
        [self.navigationController pushViewController:posC animated:YES];
    }
    else if (indexPath.section == 1) {
        //支付通道
        TMFilterChannelController *channelC = [[TMFilterChannelController alloc] init];
        channelC.channelItems = _channelList;
        channelC.delegate = self;
        [self.navigationController pushViewController:channelC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
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

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TMFilterPOSDelegate

- (void)getSelectedPOS:(POSModel *)model {
    _selectedPOS = model;
}

#pragma mark - TMFilterChannelDelegate

- (void)getSelectedChannel:(ChannelListModel *)channel
              billingModel:(BillingModel *)billing {
    _selectedChannel = channel;
}

@end
