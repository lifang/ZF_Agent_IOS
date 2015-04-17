//
//  GoodListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodListController.h"
#import "SortView.h"
#import "ZFSearchBar.h"
#import "TreeDataHandle.h"
#import "AppDelegate.h"
#import "FilterViewController.h"
#import "NavigationBarAttr.h"
#import "GoodListModel.h"
#import "GoodListCell.h"
#import "SearchViewController.h"
#import "GoodDetailController.h"

@interface GoodListController ()<SortViewDelegate,UISearchBarDelegate,SearchDelegate>

@property (nonatomic, strong) ZFSearchBar *searchBar;
@property (nonatomic, strong) SortView *sortView;

@property (nonatomic, assign) OrderFilter filterType; //排序类型

@property (nonatomic, strong) NSMutableArray *dataItem;

/*搜索字段*/
///保存用户选择的筛选条件
@property (nonatomic, strong) NSMutableDictionary *filterDict;
@property (nonatomic, strong) NSString *keyword;      //关键字

@end

@implementation GoodListController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataItem = [[NSMutableArray alloc] init];
    _filterDict = [[NSMutableDictionary alloc] init];
    [self initAndLayoutUI];
    [self setOriginalQuery];
    [self firstLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGoodList)
                                                 name:UpdateGoodListNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initNavigationBarView];
    [self initContentView];
    [self setHeaderAndFooterView];
}

- (void)initNavigationBarView {
    _searchBar = [[ZFSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _searchBar.inputField.clearButtonMode = UITextFieldViewModeNever;
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, 24, 24);
    [filterButton setBackgroundImage:kImageName(@"good_filter.png") forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterGoods:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:filterItem, nil];
}

- (void)initContentView {
    CGFloat sortViewHeight = 40.f;
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"默认排序",
                          @"销量优先",
                          @"价格降序",
                          @"评分最高",
                          nil];
    _sortView = [[SortView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, sortViewHeight)];
    _sortView.delegate = self;
    [_sortView setItems:nameArray];
    [self.view addSubview:_sortView];
    [self initRefreshViewWithOffset:sortViewHeight];
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
    //****************筛选条件***************
    NSArray *brandItem = [self filterForKey:s_brands];
    NSArray *catrgoryItem = [self filterForKey:s_category];
    NSArray *channelItem = [self filterForKey:s_channel];
    NSArray *cardItem = [self filterForKey:s_card];
    NSArray *tradeItem = [self filterForKey:s_trade];
    NSArray *slipItem = [self filterForKey:s_slip];
    NSArray *dateItem = [self filterForKey:s_date];
    BOOL isRent = [[_filterDict objectForKey:s_rent] boolValue];
    CGFloat maxPrice = [[_filterDict objectForKey:s_maxPrice] floatValue];
    CGFloat minPrice = [[_filterDict objectForKey:s_minPrice] floatValue];
    //***************************************
    [NetworkInterface getGoodListWithCityID:delegate.cityID agentID:delegate.agentID supplyType:_supplyType sortType:_filterType brandID:brandItem category:catrgoryItem channelID:channelItem payCardID:cardItem tradeID:tradeItem slipID:slipItem date:dateItem maxPrice:maxPrice minPrice:minPrice keyword:_keyword onlyRent:isRent page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                    [self parseDataWithDictionary:object];
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

- (void)parseDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *goodList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [goodList count]; i++) {
        GoodListModel *good = [[GoodListModel alloc] initWithParseDictionary:[goodList objectAtIndex:i]];
        [_dataItem addObject:good];
    }
    [self.tableView reloadData];
}

#pragma mark - Data

//搜索条件初始化
- (void)setOriginalQuery {
    _filterType = OrderFilterDefault;
    _keyword = nil;
    TreeNodeModel *original = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
                                                                  children:nil
                                                                    nodeID:kNoneFilterID];
    NSMutableArray *item = [[NSMutableArray alloc] initWithObjects:original, nil];
    //所有条件可多选，value为数组
    [_filterDict setObject:item forKey:s_brands];
    [_filterDict setObject:item forKey:s_category];
    [_filterDict setObject:item forKey:s_channel];
    [_filterDict setObject:item forKey:s_card];
    [_filterDict setObject:item forKey:s_trade];
    [_filterDict setObject:item forKey:s_slip];
    [_filterDict setObject:item forKey:s_date];
    //值
    [_filterDict setObject:[NSNumber numberWithBool:NO] forKey:s_rent];
    [_filterDict setObject:[NSNumber numberWithFloat:0] forKey:s_maxPrice];
    [_filterDict setObject:[NSNumber numberWithFloat:0] forKey:s_minPrice];
}

//根据字典中选中条件获取请求需要的数组
- (NSArray *)filterForKey:(NSString *)key {
    NSArray *filterItem = [_filterDict objectForKey:key];
    for (TreeNodeModel *node in filterItem) {
        //若筛选条件包含全部，数组返回nil
        if ([node.nodeID isEqualToString:kNoneFilterID]) {
            return nil;
        }
    }
    NSMutableArray *IDItem = [[NSMutableArray alloc] init];
    for (TreeNodeModel *node in filterItem) {
        [IDItem addObject:[NSNumber numberWithInt:[node.nodeID intValue]]];
    }
    return IDItem;
}

#pragma mark - Action

- (IBAction)filterGoods:(id)sender {
    FilterViewController *filterC = [[FilterViewController alloc] init];
    filterC.filterDict = _filterDict;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterC];
    [NavigationBarAttr setNavigationBarStyle:nav];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *goodListIdentifier = @"goodListIdentifier";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:goodListIdentifier];
    if (cell == nil) {
        cell = [[GoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goodListIdentifier];
    }
    GoodListModel *model = [_dataItem objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kGoodCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodListModel *model = [_dataItem objectAtIndex:indexPath.row];
    GoodDetailController *detailC = [[GoodDetailController alloc] init];
    detailC.supplyType = _supplyType;
    detailC.goodID = model.goodID;
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - UISearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *searchC = [[SearchViewController alloc] init];
    searchC.delegate = self;
    searchC.keyword = _keyword;
    searchC.type = HistoryTypeGood;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchC];
    [NavigationBarAttr setNavigationBarStyle:nav];
    [self presentViewController:nav animated:NO completion:nil];
    return NO;
}

#pragma mark - SortViewDelegate

- (void)changeValueWithIndex:(NSInteger)index {
    switch (index) {
        case SortDefault:
            _filterType = OrderFilterDefault;
            break;
        case SortSales:
            _filterType = OrderFilterSales;
            break;
        case SortPriceDown:
            _filterType = OrderFilterPriceDown;
            break;
        case SortPriceUp:
            _filterType = OrderFilterPriceUp;
            break;
        case SortScore:
            _filterType = OrderFilterScore;
            break;
        default:
            break;
    }
    [self firstLoadData];
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - Notification

- (void)updateGoodList {
    [self firstLoadData];
}

#pragma mark - SearchDelegate

- (void)getSearchKeyword:(NSString *)keyword {
    _keyword = keyword;
    _searchBar.text = _keyword;
    [self firstLoadData];
}

@end
