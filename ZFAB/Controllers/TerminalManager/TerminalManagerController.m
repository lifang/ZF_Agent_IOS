//
//  TerminalManagerController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalManagerController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "KxMenu.h"
#import "TerminalManagerCell.h"
#import "TerminalDetailController.h"

@interface TerminalManagerController ()

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) UIButton *statusButton;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, assign) TerminalStatus currentStatus;

@end

@implementation TerminalManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"终端管理";
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    self.currentStatus = TerminalStatusNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    CGFloat topSpace = 20.f;
    CGFloat middleSpace = 10.f;
    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
    CGFloat btnHeight = 36.f;
    //申请售后
    UIButton *afterSaleApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    afterSaleApplyBtn.frame = CGRectMake(middleSpace, topSpace, btnWidth, btnHeight);
    afterSaleApplyBtn.layer.cornerRadius = 4;
    afterSaleApplyBtn.layer.masksToBounds = YES;
    afterSaleApplyBtn.layer.borderWidth = 1.f;
    afterSaleApplyBtn.layer.borderColor = kMainColor.CGColor;
    [afterSaleApplyBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [afterSaleApplyBtn setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    afterSaleApplyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [afterSaleApplyBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    [afterSaleApplyBtn addTarget:self action:@selector(applyAfterSale:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:afterSaleApplyBtn];
    //为用户开通终端
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(btnWidth + 3 * middleSpace, topSpace, btnWidth, btnHeight);
    openBtn.layer.cornerRadius = 4;
    openBtn.layer.masksToBounds = YES;
    openBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [openBtn setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    [openBtn setTitle:@"为用户绑定终端" forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(bindingTerminal:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:openBtn];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 76, kScreenWidth, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:firstLine];
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30 - kLineHeight, kScreenWidth, kLineHeight)];
    secondLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:secondLine];
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(10, 0, 110, 30);
    _statusButton.backgroundColor = [UIColor clearColor];
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusButton setTitle:@"选择终端状态" forState:UIControlStateNormal];
    [_statusButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(showStatus:) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
    _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [backView addSubview:_statusButton];
    
    CGFloat originX = _statusButton.frame.origin.x + _statusButton.frame.size.width + 10;
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, kScreenWidth - originX, 30)];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:13.f];
    _statusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStatus:)];
    [_statusLabel addGestureRecognizer:tap];
    [backView addSubview:_statusLabel];
}

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0.f];
    [self setHeaderView];
}

#pragma mark - Set

- (void)setCurrentStatus:(TerminalStatus)currentStatus {
    _currentStatus = currentStatus;
    _statusLabel.text = [self getStatusStringWithStatus:_currentStatus];
    [self firstLoadData];
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
    [NetworkInterface getTerminalListWithAgentID:delegate.agentID token:delegate.token keyword:nil page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_dataItem removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"applyList"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseTerminalListWithDictionary:object];
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

- (NSString *)getStatusStringWithStatus:(TerminalStatus)status {
    NSString *statusString = nil;
    switch (status) {
        case TerminalStatusNone:
            statusString = @"全部";
            break;
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}

- (void)parseTerminalListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id applyList = [[dict objectForKey:@"result"] objectForKey:@"applyList"];
    if ([applyList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [applyList count]; i++) {
            id applyDict = [applyList objectAtIndex:i];
            if ([applyDict isKindOfClass:[NSDictionary class]]) {
                TerminalModel *model = [[TerminalModel alloc] initWithParseDictionary:applyDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Action

- (IBAction)applyAfterSale:(id)sender {
    
}

- (IBAction)bindingTerminal:(id)sender {
    
}

- (IBAction)selectStatus:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentStatus = (int)item.tag;
}

- (IBAction)showStatus:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self getStatusStringWithStatus:TerminalStatusNone]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:TerminalStatusNone],
                                 [KxMenuItem menuItem:[self getStatusStringWithStatus:TerminalStatusOpened]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:TerminalStatusOpened],
                                 [KxMenuItem menuItem:[self getStatusStringWithStatus:TerminalStatusPartOpened]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:TerminalStatusPartOpened],
                                 [KxMenuItem menuItem:[self getStatusStringWithStatus:TerminalStatusUnOpened]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:TerminalStatusUnOpened],
                                 [KxMenuItem menuItem:[self getStatusStringWithStatus:TerminalStatusCanceled]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:TerminalStatusCanceled],
                                 [KxMenuItem menuItem:[self getStatusStringWithStatus:TerminalStatusStopped]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:TerminalStatusStopped],
                                 nil];

    CGRect convertRect = [_statusButton convertRect:_statusButton.frame toView:self.view];
    CGRect rect = CGRectMake(_statusButton.frame.origin.x + _statusButton.frame.size.width / 2, convertRect.origin.y + convertRect.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TerminalModel *model = [_dataItem objectAtIndex:indexPath.section];
    NSString *cellIdentifier = nil;
    switch (model.status) {
        case TerminalStatusOpened:
            //已开通
            if (model.appID) {
                cellIdentifier = OpenedFirstStatusIdentifier;
            }
            else {
                cellIdentifier = OpenedSecondStatusIdentifier;
            }
            break;
        case TerminalStatusPartOpened:
            //部分开通
            cellIdentifier = PartOpenedStatusIdentifier;
            break;
        case TerminalStatusUnOpened:
            //未开通
            if (model.appID) {
                cellIdentifier = UnOpenedSecondStatusIdentifier;
            }
            else {
                cellIdentifier = UnOpenedFirstStatusIdentifier;
            }
            break;
        case TerminalStatusCanceled:
            //已注销
            cellIdentifier = CanceledStatusIdentifier;
            break;
        case TerminalStatusStopped:
            //已停用
            cellIdentifier = StoppedStatusIdentifier;
            break;
        default:
            break;
    }
    TerminalManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TerminalManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setContentsWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TerminalModel *model = [_dataItem objectAtIndex:indexPath.section];
    if (model.status == TerminalStatusOpened && !model.appID) {
        return kTMMiddleCellHeight;
    }
    return kTMShortCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TerminalModel *model = [_dataItem objectAtIndex:indexPath.section];
    if (model.status == TerminalStatusOpened && !model.appID) {
        //自助开通无法查看详情
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"自助开通终端无详情信息";
        return;
    }
    else {
        TerminalDetailController *detailC = [[TerminalDetailController alloc] init];
        detailC.terminalModel = model;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

@end
