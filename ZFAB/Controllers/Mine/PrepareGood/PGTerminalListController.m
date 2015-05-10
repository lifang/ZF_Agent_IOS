//
//  PGTerminalListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PGTerminalListController.h"
#import "ZFSearchBar.h"
#import "SerialSearchCell.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "TerminalBottomView.h"
#import "SearchViewController.h"
#import "NavigationBarAttr.h"
#import "PrepareGoodController.h"
#import "TransferGoodController.h"

@interface PGTerminalListController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SerialCellDelegate,TerminalBottomDelegate,SearchDelegate>

@property (nonatomic, strong) ZFSearchBar *searchBar;

@property (nonatomic, strong) UILabel *tipLabel;  //记录筛选数据条数

@property (nonatomic, strong) TerminalBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray *resultItem;  //搜索终端列表

@end

@implementation PGTerminalListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _resultItem = [[NSMutableArray alloc] init];
    _terminalFilter = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initNavigationBarView];
    [self initContentView];
}

- (void)initNavigationBarView {
    _searchBar = [[ZFSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _searchBar.inputField.clearButtonMode = UITextFieldViewModeNever;
    [_searchBar setAttrPlaceHolder:@"搜索终端号"];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, kScreenWidth - 60, 20)];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.font = [UIFont systemFontOfSize:14.f];
    [headerView addSubview:_tipLabel];
    [self setTipInfo];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)initContentView {
    _bottomView = [[TerminalBottomView alloc] init];
    _bottomView.backgroundColor = kColor(235, 233, 233, 1);
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomView.delegate = self;
    [_bottomView.finishButton addTarget:self action:@selector(ensureTerminal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:60.f]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = kColor(244, 243, 243, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:self.tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_bottomView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    self.topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    self.topRefreshView.direction = PullFromTop;
    self.topRefreshView.delegate = self;
    [self.tableView addSubview:self.topRefreshView];

    self.bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    self.bottomRefreshView.direction = PullFromBottom;
    self.bottomRefreshView.delegate = self;
    self.bottomRefreshView.hidden = YES;
    [self.tableView addSubview:self.bottomRefreshView];
}

#pragma mark - UISearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *searchC = [[SearchViewController alloc] init];
    searchC.delegate = self;
    searchC.keyword = _searchBar.text;
    searchC.type = HistoryTypePG;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchC];
    [NavigationBarAttr setNavigationBarStyle:nav];
    [self presentViewController:nav animated:NO completion:nil];
    return NO;
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
    NSString *agentID = delegate.agentID;
    if (_selectedAgentID) {
        //调货下级代理商
        agentID = _selectedAgentID;
    }
    [NetworkInterface getPrepareGoodTerminalListWithAgentID:agentID token:delegate.token channelID:_channelID goodID:_POSID terminalNumbers:_terminalFilter page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
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
                        [_resultItem removeAllObjects];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}


#pragma mark - Data

- (void)parseSearchListWithData:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id serialList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([serialList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [serialList count]; i++) {
            id serialDict = [serialList objectAtIndex:i];
            if ([serialDict isKindOfClass:[NSDictionary class]]) {
                SerialModel *model = [[SerialModel alloc] initWithParseDictionary:serialDict];
                [_resultItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
    [self refreshSelectedInfo];
}

- (void)setTipInfo {
    NSInteger count = [_resultItem count];
    NSString *text = [NSString stringWithFormat:@"筛选后的机器共%ld台",count];
    NSRange range = NSMakeRange(7, [[NSString stringWithFormat:@"%ld",count] length]);
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *textAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              kMainColor,NSForegroundColorAttributeName,
                              [UIFont boldSystemFontOfSize:15.f],NSFontAttributeName,
                              nil];
    [attrText addAttributes:textAttr range:range];
    _tipLabel.attributedText = attrText;
}

- (void)refreshSelectedInfo {
    int selectedCount = 0;
    for (SerialModel *model in _resultItem) {
        if (model.isSelected) {
            selectedCount++;
        }
    }
    if (selectedCount == [_resultItem count] && selectedCount != 0) {
        [_bottomView setSelectedStatus:YES];
    }
    else {
        [_bottomView setSelectedStatus:NO];
    }
    _bottomView.totalLabel.text = [NSString stringWithFormat:@"已选中%d台",selectedCount];
    [self setTipInfo];
}

#pragma mark - Action

- (IBAction)ensureTerminal:(id)sender {
    NSMutableArray *terminalList = [[NSMutableArray alloc] init];
    for (SerialModel *model in _resultItem) {
        if (model.isSelected) {
            [terminalList addObject:model];
        }
    }
    if ([terminalList count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请至少选择一个终端";
        return;
    }
    NSDictionary *dict = nil;
    UIViewController *controller = nil;
    if (_filterType == FilterTypePrepareGood) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                terminalList,kPGTerminal,
                _channelID,kPGChannel,
                _POSID,kPGGood,
                nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:PGSelectedTerminalNotification
                                                            object:nil
                                                          userInfo:dict];
        for (UIViewController *subController in self.navigationController.childViewControllers) {
            if ([subController isKindOfClass:[PrepareGoodController class]]) {
                controller = subController;
                break;
            }
        }
    }
    else if (_filterType == FilterTypeTransferGood) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                terminalList,kTGTerminal,
                nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TGSelectedTerminalNotification
                                                            object:nil
                                                          userInfo:dict];
        for (UIViewController *subController in self.navigationController.childViewControllers) {
            if ([subController isKindOfClass:[TransferGoodController class]]) {
                controller = subController;
                break;
            }
        }
    }
    if (controller) {
        [self.navigationController popToViewController:controller animated:YES];
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resultItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"terminalSelected";
    SerialSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SerialSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    SerialModel *model = [_resultItem objectAtIndex:indexPath.row];
    [cell setContentsWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SerialSearchCell *cell = (SerialSearchCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectedCell];
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - SerialCellDelegate

- (void)serialCellShouldRefreshSelectedCount {
    [self refreshSelectedInfo];
}

#pragma mark - TerminalBottomDelegate

- (void)selectedAllTerminal:(BOOL)isSelected {
    for (SerialModel *model in _resultItem) {
        model.isSelected = isSelected;
    }
    [self.tableView reloadData];
    [self refreshSelectedInfo];
}

#pragma mark - SearchDelegate

- (void)getSearchKeyword:(NSString *)keyword {
    [_terminalFilter removeAllObjects];
    if (keyword && ![keyword isEqualToString:@""]) {
        [_terminalFilter addObject:keyword];
    }
    _searchBar.text = keyword;
    [self firstLoadData];
}


@end
