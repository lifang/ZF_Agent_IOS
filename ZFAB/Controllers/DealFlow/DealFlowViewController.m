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

typedef enum {
    TimeStart = 0,
    TimeEnd,
}TimeType;

@interface DealFlowViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) TimeType timeType;

@property (nonatomic, strong) NSMutableArray *tradeRecords;

@end

@implementation DealFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tradeRecords = [[NSMutableArray alloc] init];
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

#pragma mark - Action

- (IBAction)startSearch:(id)sender {
    [self pickerScrollOut];
//    if ([_terminalLabel.text isEqualToString:s_defaultTerminalNum]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                        message:@"请选择终端号"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    if (!_startTime || [_startTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择开始时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_endTime || [_endTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDate *start = [TimeFormat dateFromString:_startTime];
    NSDate *end = [TimeFormat dateFromString:_endTime];
    if (!([start earlierDate:end] == start)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"开始时间不能晚于结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (IBAction)startStatistic:(id)sender {
//    if ([_terminalLabel.text isEqualToString:s_defaultTerminalNum]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                        message:@"请选择终端号"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    if (!_startTime || [_startTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择开始时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_endTime || [_endTime isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDate *start = [TimeFormat dateFromString:_startTime];
    NSDate *end = [TimeFormat dateFromString:_endTime];
    if (!([start earlierDate:end] == start)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"开始时间不能晚于结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
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
            cell.detailTextLabel.text = @"14824832434";
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
            cell.detailTextLabel.text = @"113";
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
        return 100;
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

    }
    else if (indexPath.section == 1) {
        
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


@end
