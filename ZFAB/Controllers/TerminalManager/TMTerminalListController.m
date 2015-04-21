//
//  TMTerminalListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TMTerminalListController.h"
#import "ZFSearchBar.h"
#import "SerialSearchCell.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "TerminalBottomView.h"
#import "SearchViewController.h"
#import "NavigationBarAttr.h"
#import "AfterSaleApplyController.h"

@interface TMTerminalListController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SerialCellDelegate,TerminalBottomDelegate,SearchDelegate>

@property (nonatomic, strong) ZFSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *tipLabel;  //记录筛选数据条数

@property (nonatomic, strong) TerminalBottomView *bottomView;

@property (nonatomic, strong) NSString *keyword;  //搜索的终端号

@end

@implementation TMTerminalListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_terminalList) {
        _terminalList = [[NSMutableArray alloc] init];
    }
    [self initAndLayoutUI];
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
                                                             toItem:_bottomView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
}

#pragma mark - UISearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *searchC = [[SearchViewController alloc] init];
    searchC.delegate = self;
    searchC.keyword = _keyword;
    searchC.type = HistoryTypeAfterSaleApply;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchC];
    [NavigationBarAttr setNavigationBarStyle:nav];
    [self presentViewController:nav animated:NO completion:nil];
    return NO;
}

#pragma mark - Request

- (void)searchTerminal {
    NSMutableArray *terminals = [[NSMutableArray alloc] init];
    if (_keyword && ![_keyword isEqualToString:@""]) {
        [terminals addObject:_keyword];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalManagerTerminalWithAgentID:delegate.agentID token:delegate.token terminalList:terminals finished:^(BOOL success, NSData *response) {
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
    [_terminalList removeAllObjects];
    NSArray *serialList = [dict objectForKey:@"result"];
    for (int i = 0; i < [serialList count]; i++) {
        id serialDict = [serialList objectAtIndex:i];
        if ([serialDict isKindOfClass:[NSDictionary class]]) {
            SerialModel *model = [[SerialModel alloc] initWithParseDictionary:serialDict];
            [_terminalList addObject:model];
        }
    }
    [_tableView reloadData];
    [self refreshSelectedInfo];
}

- (void)setTipInfo {
    NSInteger count = [_terminalList count];
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
    for (SerialModel *model in _terminalList) {
        if (model.isSelected) {
            selectedCount++;
        }
    }
    if (selectedCount == [_terminalList count]) {
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
    for (SerialModel *model in _terminalList) {
        if (model.isSelected) {
            [terminalList addObject:model];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          terminalList,kTMTermainalList,
                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:getSelectedTerminalsNotification
                                                        object:nil
                                                      userInfo:dict];
    UIViewController *controller = nil;
    for (UIViewController *subController in self.navigationController.childViewControllers) {
        if ([subController isKindOfClass:[AfterSaleApplyController class]]) {
            controller = subController;
            break;
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
    return [_terminalList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"terminalSelected";
    SerialSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SerialSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    SerialModel *model = [_terminalList objectAtIndex:indexPath.row];
    [cell setContentsWithData:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SerialSearchCell *cell = (SerialSearchCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectedCell];
}


#pragma mark - SerialCellDelegate

- (void)serialCellShouldRefreshSelectedCount {
    [self refreshSelectedInfo];
}

#pragma mark - TerminalBottomDelegate 

- (void)selectedAllTerminal:(BOOL)isSelected {
    for (SerialModel *model in _terminalList) {
        model.isSelected = isSelected;
    }
    [_tableView reloadData];
    [self refreshSelectedInfo];
}

#pragma mark - SearchDelegate

- (void)getSearchKeyword:(NSString *)keyword {
    _keyword = keyword;
    _searchBar.text = _keyword;
    [self searchTerminal];
}

@end
