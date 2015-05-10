//
//  StockTerminalController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StockTerminalController.h"
#import "AppDelegate.h"
#import "StockTerminalModel.h"
#import "NetworkInterface.h"
#import "StockTerminalCell.h"

@interface StockTerminalController ()

@property (nonatomic, strong) UILabel *prepareCountLabel;

@property (nonatomic, strong) UILabel *openCountLabel;

@property (nonatomic, strong) UILabel *prepareTimeLabel;

@property (nonatomic, strong) UILabel *openTimeLabel;

@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation StockTerminalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _stockAgent.agentName;
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self fillStaticData];
    [self firstLoadData];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170.f)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    [self addAgentInfoViewForHeaderView:headerView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

//顶部代理商信息
- (void)addAgentInfoViewForHeaderView:(UIView *)headerView {
    CGFloat originY = 20.f;
    CGFloat originX = 20.f;
    CGFloat labelHeight = 20.f;
    CGFloat titleHeight = 40.f;
    _prepareCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kScreenWidth - originX * 2, labelHeight)];
    _prepareCountLabel.backgroundColor = [UIColor clearColor];
    _prepareCountLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [headerView addSubview:_prepareCountLabel];
    
    originY += labelHeight;
    _openCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kScreenWidth - originX * 2, labelHeight)];
    _openCountLabel.backgroundColor = [UIColor clearColor];
    _openCountLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [headerView addSubview:_openCountLabel];
    
    //配货日期
    originY += labelHeight + 10.f;
    _prepareTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kScreenWidth - originX * 2, labelHeight)];
    _prepareTimeLabel.backgroundColor = [UIColor clearColor];
    _prepareTimeLabel.font = [UIFont systemFontOfSize:13.f];
    [headerView addSubview:_prepareTimeLabel];
    
    //开通日期
    originY += labelHeight;
    _openTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kScreenWidth - originX * 2, labelHeight)];
    _openTimeLabel.backgroundColor = [UIColor clearColor];
    _openTimeLabel.font = [UIFont systemFontOfSize:13.f];
    [headerView addSubview:_openTimeLabel];
    
    //标题栏目
    originY += labelHeight + 20.f;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, titleHeight)];
    backView.backgroundColor = kColor(218, 217, 217, 1);
    [headerView addSubview:backView];
    
    //终端号
    CGFloat totalWidth = kScreenWidth - originX * 2;
    UILabel *terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, totalWidth * 0.4, titleHeight)];
    terminalLabel.backgroundColor = [UIColor clearColor];
    terminalLabel.font = [UIFont systemFontOfSize:14.f];
    terminalLabel.textAlignment = NSTextAlignmentCenter;
    terminalLabel.text = @"终端号";
    [backView addSubview:terminalLabel];
    
    //机型
    originX += totalWidth * 0.4;
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, totalWidth * 0.3, titleHeight)];
    modelLabel.backgroundColor = [UIColor clearColor];
    modelLabel.font = [UIFont systemFontOfSize:14.f];
    modelLabel.textAlignment = NSTextAlignmentCenter;
    modelLabel.text = @"机型";
    [backView addSubview:modelLabel];
    
    //开通状态
    originX += totalWidth * 0.3;
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, totalWidth * 0.3, titleHeight)];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont systemFontOfSize:14.f];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"开通状态";
    [backView addSubview:statusLabel];
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
    [NetworkInterface getStockTerminalWithAgentID:_stockAgent.agentID token:delegate.token channelID:_stockModel.stockChannelID goodID:_stockModel.stockGoodID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        list = [[object objectForKey:@"result"] objectForKey:@"list"];
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
                    [self parseStockListWithDictionary:object];
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

- (void)fillStaticData {
    _prepareCountLabel.text = [NSString stringWithFormat:@"配货总量  %d",_stockAgent.totalCount];
    _openCountLabel.text = [NSString stringWithFormat:@"已开通量  %d",_stockAgent.openCount];
    _prepareTimeLabel.text = [NSString stringWithFormat:@"上次配货日期  %@",_stockAgent.prepareTime];
    _openTimeLabel.text = [NSString stringWithFormat:@"上次开通日期  %@",_stockAgent.openTime];
}

- (void)parseStockListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id terminalList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([terminalList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [terminalList count]; i++) {
            id terminalDict = [terminalList objectAtIndex:i];
            StockTerminalModel *model = [[StockTerminalModel alloc] initWithParseDictionary:terminalDict];
            [_dataItem addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *stockTerminalIdentifier = @"stockTerminalIdentifier";
    StockTerminalCell *cell = [tableView dequeueReusableCellWithIdentifier:stockTerminalIdentifier];
    if (cell == nil) {
        cell = [[StockTerminalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stockTerminalIdentifier];
    }
    StockTerminalModel *model = [_dataItem objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kStockTermainalCellHeight;
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}


@end
