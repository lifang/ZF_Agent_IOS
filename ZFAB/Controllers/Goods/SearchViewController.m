//
//  SearchViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/31.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) ZFSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyItems;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initSearchBar];
    [self initContentView];
    
    _historyItems = [[NSMutableArray alloc] init];
    [self getSearchHistory];
}

- (void)initSearchBar {
    _searchBar = [[ZFSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _searchBar.delegate = self;
    _searchBar.text = _keyword;
    self.navigationItem.titleView = _searchBar;
    [_searchBar becomeFirstResponder];
    NSString *placeHolder = @"";
    switch (_type) {
        case HistoryTypeGood:
            placeHolder = @"搜索商品";
            break;
        case HistoryTypeAfterSaleApply:
            placeHolder = @"搜索终端号";
            break;
        case HistoryTypePG:
            placeHolder = @"搜索终端号";
            break;
        default:
            break;
    }
    [_searchBar setAttrPlaceHolder:placeHolder];
}

- (void)initContentView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
}

- (void)setHeaderAndFooterView {
    if ([_historyItems count] > 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cleanButton.frame = CGRectMake((kScreenWidth - 120) / 2, 10, 120, 28);
        cleanButton.layer.cornerRadius = 4;
        cleanButton.layer.masksToBounds = YES;
        cleanButton.layer.borderWidth = 1.f;
        cleanButton.layer.borderColor = kMainColor.CGColor;
        [cleanButton setTitleColor:kMainColor forState:UIControlStateNormal];
        cleanButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [cleanButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [cleanButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
        [cleanButton addTarget:self action:@selector(clearSearchHistoy:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:cleanButton];
        _tableView.tableFooterView = footerView;
    }
    else {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
    }
}


#pragma mark - Action

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 数据

- (void)getSearchHistory {
    NSMutableArray *searchArray = [SearchHistoryHelper getHistoryWithType:_type];
    if (searchArray) {
        self.historyItems = searchArray;
    }
    [self setHeaderAndFooterView];
    [_tableView reloadData];
}

- (IBAction)clearSearchHistoy:(id)sender {
    [self.historyItems removeAllObjects];
    [SearchHistoryHelper removeHistoryWithType:_type];
    [self setHeaderAndFooterView];
    [_tableView reloadData];
}

- (void)saveSearchHistory {
    if (![self.historyItems containsObject:self.searchBar.text] && self.searchBar.text && ![self.searchBar.text isEqualToString:@""]) {
        [self.historyItems addObject:self.searchBar.text];
        //保存搜索历史到本地
        [SearchHistoryHelper saveHistory:self.historyItems forType:_type];
        [self setHeaderAndFooterView];
        [_tableView reloadData];
    }
}

- (void)searchWithString:(NSString *)string {
    if (_delegate && [_delegate respondsToSelector:@selector(getSearchKeyword:)]) {
        [_delegate getSearchKeyword:string];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - SearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"search");
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"!!");
    [self saveSearchHistory];
    [self searchWithString:self.searchBar.text];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"History";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [_historyItems objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = [_historyItems objectAtIndex:indexPath.row];
    [self searchWithString:self.searchBar.text];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView && _searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}


@end
