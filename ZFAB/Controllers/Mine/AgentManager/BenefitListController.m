//
//  BenefitListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "BenefitListController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "BenefitModel.h"
#import "BenefitCell.h"
#import "ChannelListModel.h"
#import "CreateBenefitController.h"
#import "EditBenefitController.h"

@interface BenefitListController ()<UITableViewDataSource,UITableViewDelegate,BenefitCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) NSMutableArray *channelList;

@end

@implementation BenefitListController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置分润";
    _dataItem = [[NSMutableArray alloc] init];
    _channelList = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self getBenefitList];
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"add.png")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(addBenefit:)];
    self.navigationItem.rightBarButtonItem = rigthItem;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshBenefitList:)
                                                 name:RefreshBenefitListNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
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
    [self initPickerView];
}

- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(selectedChannel:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];

}

#pragma mark - Request

//支付通道
- (void)getChannelList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAgentChannelListWithToken:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [self parseChannelListWithDictionary:object];
                    [self pickerScrollIn];
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

- (void)getBenefitList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getBenefitListWithToken:delegate.token subAgentID:_subAgentID finished:^(BOOL success, NSData *response) {
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
                    [self parseBenefitListWithDictionary:object];
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

//删除分润
- (void)deleteBenefitWithModel:(BenefitModel *)model {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteBenefitWithAgentID:delegate.agentID token:delegate.token subAgentID:_subAgentID channelID:model.ID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshBenefitListNotification object:nil];
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

- (void)parseBenefitListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [_dataItem removeAllObjects];
    id list = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [list count]; i++) {
            id benefitDict = [list objectAtIndex:i];
            if ([benefitDict isKindOfClass:[NSDictionary class]]) {
                BenefitModel *model = [[BenefitModel alloc] initWithParseDictionary:benefitDict];
                [_dataItem addObject:model];
            }
        }
    }
    [_tableView reloadData];
}

- (void)parseChannelListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [_channelList removeAllObjects];
    id list = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [list count]; i++) {
            id channelDict = [list objectAtIndex:i];
            if ([channelDict isKindOfClass:[NSDictionary class]]) {
                ChannelListModel *model = [[ChannelListModel alloc] initWithParseBenefitChannelDictionary:channelDict];
                [_channelList addObject:model];
            }
        }
    }
    [_pickerView reloadAllComponents];
}

- (void)addBenefitForChannel:(ChannelListModel *)channel {
    for (BenefitModel *model in _dataItem) {
        if ([model.ID isEqualToString:channel.channelID]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"该通道已设置过分润";
            return;
        }
    }
    CreateBenefitController *createC = [[CreateBenefitController alloc] init];
    createC.channel = channel;
    createC.subAgentID = _subAgentID;
    [self.navigationController pushViewController:createC animated:YES];
}

#pragma mark - Action

- (IBAction)addBenefit:(id)sender {
    if ([_channelList count] <= 0) {
        [self getChannelList];
    }
    else {
        [self pickerScrollIn];
    }
}

- (IBAction)selectedChannel:(id)sender {
    [self pickerScrollOut];
    NSInteger firstIndex = [_pickerView selectedRowInComponent:0];
    ChannelListModel *channel = nil;
    if (firstIndex < [_channelList count]) {
        channel = [_channelList objectAtIndex:firstIndex];
    }
    [self addBenefitForChannel:channel];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BenefitModel *model = [_dataItem objectAtIndex:section];
    return [model.tradeList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    BenefitModel *model = [_dataItem objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        identifier = @"ChannelIdentifier";
        BenefitCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BenefitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        cell.benefitModel = model;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.f];
        cell.textLabel.text = [NSString stringWithFormat:@"支付通道：%@",model.channelName];
        return cell;
    }
    else {
        identifier = @"TradeTypeIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        TradeTypeModel *tradeModel = [model.tradeList objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = tradeModel.tradeName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f%%",tradeModel.percent];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BenefitModel *model = [_dataItem objectAtIndex:indexPath.section];
    if (indexPath.row != 0) {
        TradeTypeModel *tradeModel = [model.tradeList objectAtIndex:indexPath.row - 1];
        EditBenefitController *editC = [[EditBenefitController alloc] init];
        editC.subAgentID = _subAgentID;
        editC.channelID = model.ID;
        editC.type = BenefitPercentModity;
        editC.tradeModel = tradeModel;
        [self.navigationController pushViewController:editC animated:YES];
    }
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_channelList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //通道
    ChannelListModel *model = [_channelList objectAtIndex:row];
    return model.channelName;
}

- (void)pickerScrollIn {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - BenefitCellDelegate

- (void)benefitCellDeleteChannel:(BenefitModel *)benefitModel {
    NSLog(@"%@",benefitModel.channelName);
    [self deleteBenefitWithModel:benefitModel];
}

#pragma mark - NSNotification

- (void)refreshBenefitList:(NSNotification *)notification {
    [self performSelector:@selector(getBenefitList) withObject:nil afterDelay:0.1f];
}

@end
