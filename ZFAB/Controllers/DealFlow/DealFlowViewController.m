//
//  DealFlowViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "DealFlowViewController.h"
#import "NetworkInterface.h"
#import "TimeFormat.h"
#import "TradeTerminalController.h"
#import "TradeAgentController.h"
#import "AppDelegate.h"
#import "TradeCell.h"
#import "TradeDetailController.h"
#import "StatisticTradeController.h"

typedef enum {
    TimeStart = 0,
    TimeEnd,
}TimeType;

@interface DealFlowViewController ()<TradeTerminalDelegate,TradeAgentDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSString *terminalNumber;
@property (nonatomic, strong) TradeAgentModel *agentModel;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) TimeType timeType;

@property (nonatomic, strong) NSMutableArray *tradeRecords;

@property (nonatomic, strong) NSMutableArray *tradeAgentItem; //代理商列表数组

@end

@implementation DealFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tradeRecords = [[NSMutableArray alloc] init];
    _tradeAgentItem = [[NSMutableArray alloc] init];
    self.title = @"交易流水";
    [self initAndLayoutUI];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    self.tableView.tableHeaderView = headerView;
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"转账",
                          @"消费",
                          @"还款",
                          @"生活充值",
                          @"话费充值",
                          nil];
    CGFloat h_space = 20.f;
    CGFloat v_space = 10.f;
    _segmentControl = [[UISegmentedControl alloc] initWithItems:nameArray];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.frame = CGRectMake(h_space, v_space, kScreenWidth - h_space * 2, 30);
    _segmentControl.tintColor = kMainColor;
    [_segmentControl addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:12.f],NSFontAttributeName,
                              nil];
    [_segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [headerView addSubview:_segmentControl];
    
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
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.datePicker];
}

#pragma mark - Set

- (void)setStartTime:(NSString *)startTime {
    _startTime = startTime;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = _startTime;
}

- (void)setEndTime:(NSString *)endTime {
    _endTime = endTime;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:2];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = _endTime;
}

- (TradeType)tradeTypeFromIndex:(NSInteger)index {
    TradeType type = TradeTypeNone;
    switch (index) {
        case 0:
            type = TradeTypeTransfer;
            break;
        case 1:
            type = TradeTypeConsume;
            break;
        case 2:
            type = TradeTypeRepayment;
            break;
        case 3:
            type = TradeTypeLife;
            break;
        case 4:
            type = TradeTypeTelephoneFare;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - Request

- (void)firstLoadData {
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    TradeType tradeType = [self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex];
    [NetworkInterface getTradeRecordWithAgentID:delegate.agentID token:delegate.token tradeType:tradeType terminalNumber:_terminalNumber subAgentID:_agentModel.agentID startTime:_startTime endTime:_endTime page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_tradeRecords removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseTradeListDataWithDictionary:object];
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

- (void)parseTradeListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *tradeList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [tradeList count]; i++) {
        TradeModel *trade = [[TradeModel alloc] initWithParseDictionary:[tradeList objectAtIndex:i]];
        [_tradeRecords addObject:trade];
    }
    [self.tableView reloadData];
}

#pragma mark - Action

- (IBAction)startSearch:(id)sender {
    [self pickerScrollOut];
    if (!_terminalNumber || [_terminalNumber isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择终端号";
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

- (IBAction)startStatistic:(id)sender {
    [self pickerScrollOut];
    if (!_terminalNumber || [_terminalNumber isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择终端号";
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
    StatisticTradeController *statisticC = [[StatisticTradeController alloc] init];
    statisticC.startTime = _startTime;
    statisticC.endTime = _endTime;
    statisticC.terminalNumber = _terminalNumber;
    statisticC.tradeType = [self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex];
    [self.navigationController pushViewController:statisticC animated:YES];
}

//datePicker滚动时调用方法
- (IBAction)timeChanged:(id)sender {
    if (_timeType == TimeStart) {
        self.startTime = [TimeFormat stringFromDate:_datePicker.date];
    }
    else if (_timeType == TimeEnd) {
        self.endTime = [TimeFormat stringFromDate:_datePicker.date];
    }
}

- (IBAction)typeChanged:(id)sender {
    [_tradeRecords removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            //终端号
            row = 1;
            break;
        case 1:
            //选择代理商
            row = 1;
            break;
        case 2:
            //时间
            row = 2;
            break;
        case 3:
            //交易流水
            row = [_tradeRecords count];
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            //终端号
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"选择终端号";
            cell.detailTextLabel.text = _terminalNumber;
            cell.imageView.image = kImageName(@"terminal.png");
            return cell;
        }
            break;
        case 1: {
            //代理商
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"选择代理商";
            cell.detailTextLabel.text = _agentModel.agentName;
            cell.imageView.image = kImageName(@"agent.png");
            return cell;
        }
            break;
        case 2: {
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
        case 3: {
            static NSString *cellIdentifier = @"TradeList";
            TradeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[TradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            TradeModel *trade = [_tradeRecords objectAtIndex:indexPath.row];
            [cell setContentWithData:trade
                       withTradeType:[self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 && [_tradeRecords count] > 0) {
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
            height = 5.f;
            break;
        case 2:
            height = 60.f;
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return kTradeCellHeight;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3 && [_tradeRecords count] > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.f)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.f];
        label.text = @"      交易流水：";
        return label;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(20, 10, kScreenWidth / 2 - 40, 40);
        searchBtn.layer.cornerRadius = 4;
        searchBtn.layer.masksToBounds = YES;
        searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [searchBtn setTitle:@"开始查询" forState:UIControlStateNormal];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(startSearch:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:searchBtn];
        
        UIButton *statisticBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        statisticBtn.frame = CGRectMake(kScreenWidth / 2 + 20, 10, kScreenWidth / 2 - 40, 40);
        statisticBtn.layer.cornerRadius = 4;
        statisticBtn.layer.masksToBounds = YES;
        statisticBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [statisticBtn setTitle:@"开始统计" forState:UIControlStateNormal];
        [statisticBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
        [statisticBtn addTarget:self action:@selector(startStatistic:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:statisticBtn];
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
        //选择终端
        TradeTerminalController *tradeC = [[TradeTerminalController alloc] init];
        tradeC.terminalNumber = _terminalNumber;
        tradeC.delegate = self;
        [self.navigationController pushViewController:tradeC animated:YES];
    }
    else if (indexPath.section == 1) {
        //选择代理商
        TradeAgentController *agentC = [[TradeAgentController alloc] init];
        agentC.delegate = self;
        agentC.agentItem = _tradeAgentItem;
        [self.navigationController pushViewController:agentC animated:YES];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            _timeType = TimeStart;
            [self pickerScrollIn];
        }
        else {
            _timeType = TimeEnd;
            [self pickerScrollIn];
        }
    }
    else if (indexPath.section == 3) {
        //交易流水
        TradeModel *trade = [_tradeRecords objectAtIndex:indexPath.row];
        TradeDetailController *detailC = [[TradeDetailController alloc] init];
        detailC.tradeID = trade.tradeID;
        detailC.tradeType = [self tradeTypeFromIndex:_segmentControl.selectedSegmentIndex];
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    if (_timeType == TimeStart) {
        if (_startTime && ![_startTime isEqualToString:@""]) {
            _datePicker.date = [TimeFormat dateFromString:_startTime];
        }
        else {
            self.startTime = [TimeFormat stringFromDate:_datePicker.date];
        }
    }
    else if (_timeType == TimeEnd) {
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
    if (_terminalNumber && _agentModel && _startTime && _endTime) {
        [super scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_terminalNumber && _agentModel && _startTime && _endTime) {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - TradeTerminalDelegate

- (void)getSelectTerminalNumber:(NSString *)terminalNumber {
    _terminalNumber = terminalNumber;
    [self.tableView reloadData];
}

#pragma mark - TradeAgentDelegate

- (void)getSelectedAgent:(TradeAgentModel *)agentModel {
    _agentModel = agentModel;
    [self.tableView reloadData];
}

@end
