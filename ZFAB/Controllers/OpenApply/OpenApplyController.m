//
//  OpenApplyController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OpenApplyController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "OpenApplyCell.h"
#import "ApplyDetailController.h"
#import "TerminalDetailController.h"

@interface OpenApplyController ()<OpenApplyCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation OpenApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通申请";
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
    self.historyType = HistoryTypeOpenApply;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"good_search.png")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showSearchView)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
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
    [NetworkInterface getApplyListWithAgentID:delegate.agentID token:delegate.token keyword:self.searchInfo page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                    id list = nil;
                    if ([[object objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                        list = [[object objectForKey:@"result"] objectForKey:@"applyList"];
                    }
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseApplyListDataWithDictionary:object];
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

- (void)parseApplyListDataWithDictionary:(NSDictionary *)dict {
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
        case TerminalStatusPartOpened:
            //部分开通
            cellIdentifier = PartOpenedApplyIdentifier;
            break;
        case TerminalStatusUnOpened:
            //未开通
            cellIdentifier = UnOpenedApplyIdentifier;
            break;
        default:
            break;
    }
    OpenApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[OpenApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    [cell setContentsWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TerminalModel *model = [_dataItem objectAtIndex:indexPath.section];
    TerminalDetailController *detailC = [[TerminalDetailController alloc] init];
    detailC.terminalModel = model;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kOpenApplyCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - OpenApplyCellDelegate

- (void)openApplyCellOpenWithData:(TerminalModel *)data {
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID = data.terminalID;
    detailC.openStatus = OpenStatusNew;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (void)openApplyCellReopenWithData:(TerminalModel *)data {
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID = data.terminalID;
    detailC.openStatus = OpenStatusReopen;
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - 搜索

- (void)getSearchKeyword:(NSString *)keyword {
    self.searchInfo = keyword;
    [self firstLoadData];
}

@end
