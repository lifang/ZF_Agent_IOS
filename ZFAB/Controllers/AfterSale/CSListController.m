//
//  CSListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CSListController.h"
#import "KxMenu.h"
#import "AppDelegate.h"
#import "CSCell.h"
#import "AfterSaleDetailController.h"
#import "UpdateDetailController.h"
#import "CancelDetailController.h"

@interface CSListController ()<CSCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) UIButton *statusButton;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, assign) CSStatus currentStatus;

@property (nonatomic, strong) CSModel *selectedModel;

@end

@implementation CSListController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [CSDataHandle titleForCSType:_csType];
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCSList:)
                                                 name:RefreshCSListNotification
                                               object:nil];
    
    self.historyType = HistoryTypeCS;
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    self.tableView.tableHeaderView = headerView;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:firstLine];
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30 - kLineHeight, kScreenWidth, kLineHeight)];
    secondLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:secondLine];
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(10, 0, 130, 30);
    _statusButton.backgroundColor = [UIColor clearColor];
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusButton setTitle:[CSDataHandle statusTitleForCSType:_csType] forState:UIControlStateNormal];
    [_statusButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(showRecordStatus:) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0);
    _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [backView addSubview:_statusButton];
    
    CGFloat originX = _statusButton.frame.origin.x + _statusButton.frame.size.width + 10;
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, kScreenWidth - originX, 30)];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:13.f];
    _statusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRecordStatus:)];
    [_statusLabel addGestureRecognizer:tap];
    [backView addSubview:_statusLabel];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    self.currentStatus = CSStatusAll;
}

#pragma mark - Set

- (void)setCurrentStatus:(CSStatus)currentStatus {
    _currentStatus = currentStatus;
    _statusLabel.text = [CSDataHandle getStatusStringWithCSType:_csType status:_currentStatus];
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
    [NetworkInterface getCSListWithAgentUserID:delegate.agentUserID token:delegate.token csType:_csType keyword:self.searchInfo status:_currentStatus page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                    [self parseCSListDataWithDictionary:object];
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

//取消申请
- (void)cancelApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csCancelApplyWithToken:delegate.token csType:_csType csID:_selectedModel.csID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    hud.labelText = @"取消申请成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCSListNotification object:nil];
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

//重新提交注销申请
- (void)submitCanncelApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csRepeatAppleyWithToken:delegate.token csID:_selectedModel.csID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    hud.labelText = @"提交成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCSListNotification object:nil];
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

- (void)parseCSListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id csList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([csList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [csList count]; i++) {
            id csDict = [csList objectAtIndex:i];
            if ([csDict isKindOfClass:[NSDictionary class]]) {
                CSModel *model = [[CSModel alloc] initWithParseDictionary:csDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}


#pragma mark - Action

- (IBAction)showRecordStatus:(id)sender {
    NSArray *menuList = [CSDataHandle statusMenuWithCSType:_csType
                                                    target:self
                                                    action:@selector(selectStatus:)
                                             selectedTitle:_statusLabel.text];

    CGRect rect = CGRectMake(_statusButton.frame.origin.x + _statusButton.frame.size.width / 2, _statusButton.frame.origin.y + _statusButton.frame.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuList];
}

- (IBAction)selectStatus:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentStatus = (CSStatus)item.tag;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSModel *data = [_dataItem objectAtIndex:indexPath.section];
    NSString *identifier = [data getCellIdentifier];
    CSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSCell alloc] initWithCSType:_csType reuseIdentifier:identifier];
    }
    cell.delegate = self;
    [cell setContentsWithData:data];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSModel *data = [_dataItem objectAtIndex:indexPath.section];
    NSString *identifier = [data getCellIdentifier];
    if (_csType == CSTypeAfterSale) {
        if ([identifier isEqualToString:firstStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    else if (_csType == CSTypeUpdate) {
        if ([identifier isEqualToString:firstStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    else if (_csType == CSTypeCancel) {
        if ([identifier isEqualToString:firstStatusIdentifier] ||
            [identifier isEqualToString:fifthStatusIdentifier]) {
            return kCSCellLongHeight;
        }
    }
    return kCSCellShortHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CSModel *model = [_dataItem objectAtIndex:indexPath.section];
    switch (_csType) {
        case CSTypeAfterSale: {
            AfterSaleDetailController *detailC = [[AfterSaleDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        case CSTypeUpdate: {
            UpdateDetailController *detailC = [[UpdateDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        case CSTypeCancel: {
            CancelDetailController *detailC = [[CancelDetailController alloc] init];
            detailC.csID = model.csID;
            detailC.csType = _csType;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}


#pragma mark - 上下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - CSCellDelegate

- (void)CSCellCancelApplyWithData:(CSModel *)model {
    _selectedModel = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消申请？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)CSCellRepeatApplyWithData:(CSModel *)model {
    _selectedModel = model;
    [self submitCanncelApply];
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self cancelApply];
    }
}

#pragma mark - NSNotification

- (void)refreshCSList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - 搜索

- (void)getSearchKeyword:(NSString *)keyword {
    self.searchInfo = keyword;
    [self firstLoadData];
}

@end
