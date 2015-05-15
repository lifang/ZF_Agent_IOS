//
//  TransferGoodManagerController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TransferGoodManagerController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "TimeFormat.h"
#import "GoodAgentModel.h"
#import "GoodAgentListController.h"
#import "TransferGoodCell.h"
#import "TransferGoodController.h"
#import "TGDetailController.h"

typedef enum {
    TransferTimeStart = 1,
    TransferTimeEnd,
}TransferTimeType;

@interface TransferGoodManagerController ()<GoodAgentSelectedDelegate>

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) TransferTimeType timeType;

@property (nonatomic, strong) NSMutableArray *transferList;

@property (nonatomic, strong) NSMutableArray *agentList;

@property (nonatomic, strong) GoodAgentModel *selectedAgent;

@end

@implementation TransferGoodManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"调货管理";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"调货"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(transferGood:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _transferList = [[NSMutableArray alloc] init];
    _agentList = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self getSubAgent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
    [self initPickerView];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    self.tableView.tableHeaderView = headerView;
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, 20)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:12.f];
    infoLabel.text = @"查询调货记录：";
    [headerView addSubview:infoLabel];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)initPickerView {
    //日期选择相关控件
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = kScreenWidth - 60;
    [_toolbar setItems:[NSArray arrayWithObjects:spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _datePicker.backgroundColor = kColor(244, 243, 243, 1);
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.datePicker];
}

#pragma mark - Set

- (void)setStartTime:(NSString *)startTime {
    _startTime = startTime;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = _startTime;
}

- (void)setEndTime:(NSString *)endTime {
    _endTime = endTime;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = _endTime;
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

- (void)firstLoadData {
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTransferGoodListWithAgentID:delegate.agentID token:delegate.token subAgentID:_selectedAgent.ID startTime:_startTime endTime:_endTime page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_transferList removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [(NSArray *)list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parsePrepareGoodListDataWithDictionary:object];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

#pragma mark - Data

- (void)parsePrepareGoodListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id list = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [(NSArray *)list count]; i++) {
            id transferDict = [list objectAtIndex:i];
            if ([transferDict isKindOfClass:[NSDictionary class]]) {
                TransferGoodModel *model = [[TransferGoodModel alloc] initWithParseDictionary:transferDict];
                [_transferList addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

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

#pragma mark - Action

- (IBAction)transferGood:(id)sender {
    TransferGoodController *transferC = [[TransferGoodController alloc] init];
    transferC.agentList = _agentList;
    [self.navigationController pushViewController:transferC animated:YES];
}

- (IBAction)startSearch:(id)sender {
    [self pickerScrollOut];
    if (!_selectedAgent) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择代理商";
        return;
    }
    if (!_startTime || [_startTime isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择开始时间";
        return;
    }
    if (!_endTime || [_endTime isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择结束时间";
        return;
    }
    NSDate *start = [TimeFormat dateFromString:_startTime];
    NSDate *end = [TimeFormat dateFromString:_endTime];
    if (!([start earlierDate:end] == start)) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"开始时间不能晚于结束时间";
        return;
    }
    [self firstLoadData];
}

//datePicker滚动时调用方法
- (IBAction)timeChanged:(id)sender {
    if (_timeType == TransferTimeStart) {
        self.startTime = [TimeFormat stringFromDate:_datePicker.date];
    }
    else if (_timeType == TransferTimeEnd) {
        self.endTime = [TimeFormat stringFromDate:_datePicker.date];
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            //下级代理商
            row = 1;
            break;
        case 1:
            //时间
            row = 2;
            break;
        case 2:
            //调货列表
            row = [_transferList count];
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            //代理商
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"选择代理商";
            cell.detailTextLabel.text = _selectedAgent.name;
            cell.imageView.image = kImageName(@"agent.png");
            return cell;
        }
            break;
        case 1: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"选择开始时间";
                    cell.detailTextLabel.text = _startTime;
                    cell.imageView.image = kImageName(@"time.png");
                    break;
                case 1:
                    cell.textLabel.text = @"选择结束时间";
                    cell.detailTextLabel.text = _endTime;
                    cell.imageView.image = kImageName(@"time.png");
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 2: {
            static NSString *cellIdentifier = @"PrepareGood";
            TransferGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[TransferGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            TransferGoodModel *model = [_transferList objectAtIndex:indexPath.row];
            [cell setContentWithData:model];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 && [_transferList count] > 0) {
        return 20.f;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.001f;
    switch (section) {
        case 0:
            height = 5.f;
            break;
        case 1:
            height = 60.f;
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return kTransferGoodCellHeight;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2 && [_transferList count] > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.f)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.f];
        label.text = @"      调货记录：";
        return label;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake((kScreenWidth / 2 + 40) / 2, 10, kScreenWidth / 2 - 40, 40);
        searchBtn.layer.cornerRadius = 4;
        searchBtn.layer.masksToBounds = YES;
        searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [searchBtn setTitle:@"开始查询" forState:UIControlStateNormal];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(startSearch:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:searchBtn];
        return footerView;
    }
    return nil;
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
    if (indexPath.section == 0) {
        //选择代理商
        GoodAgentListController *agentC = [[GoodAgentListController alloc] init];
        agentC.delegate = self;
        agentC.agentList = _agentList;
        [self.navigationController pushViewController:agentC animated:YES];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            _timeType = TransferTimeStart;
            [self pickerScrollIn];
        }
        else {
            _timeType = TransferTimeEnd;
            [self pickerScrollIn];
        }
    }
    else if (indexPath.section == 2) {
        //配货记录
        TransferGoodModel *model = [_transferList objectAtIndex:indexPath.row];
        TGDetailController *detailC = [[TGDetailController alloc] init];
        detailC.transferID = model.ID;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    if (_timeType == TransferTimeStart) {
        if (_startTime && ![_startTime isEqualToString:@""]) {
            _datePicker.date = [TimeFormat dateFromString:_startTime];
        }
        else {
            self.startTime = [TimeFormat stringFromDate:_datePicker.date];
        }
    }
    else if (_timeType == TransferTimeEnd) {
        if (_endTime && ![_endTime isEqualToString:@""]) {
            _datePicker.date = [TimeFormat dateFromString:_endTime];
        }
        else {
            self.endTime = [TimeFormat stringFromDate:_datePicker.date];
        }
    }
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _datePicker.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - 上下拉刷新重写

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_selectedAgent && _startTime && _endTime) {
        [super scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_selectedAgent && _startTime && _endTime) {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - GoodAgentSelectedDelegate

- (void)getSelectedGoodAgent:(GoodAgentModel *)model style:(AgentStyle)style {
    _selectedAgent = model;
    [self.tableView reloadData];
}


@end
