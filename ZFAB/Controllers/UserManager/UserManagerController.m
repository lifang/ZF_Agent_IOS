//
//  UserManagerController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "UserManagerController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "MultipleDeleteCell.h"
#import "UserTerminalController.h"

@interface UserManagerController ()

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, assign) BOOL isMultiDelete;

@property (nonatomic, strong) NSMutableDictionary *selectedItem; //多选的行

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation UserManagerController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户管理";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"delete.png")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userListRefresh:)
                                                 name:RefreshUserListNotification
                                               object:nil];
    
    _dataItem = [[NSMutableArray alloc] init];
    _selectedItem = [[NSMutableDictionary alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
    [self initBottomView];
}

- (void)initBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49 - 64, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = kColor(170, 169, 169, 1);
    [_bottomView addSubview:firstLine];
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(10, 7, 60, 36);
    readBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [readBtn setTitle:@"取消" forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(cancelDelete:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:readBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 60, 7, 60, 36);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:deleteBtn];
}

- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [self.tableView setEditing:_isMultiDelete animated:YES];
    if (_isMultiDelete) {
        [self.view addSubview:_bottomView];
    }
    else {
        [_selectedItem removeAllObjects];
        [_bottomView removeFromSuperview];
    }
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
    [NetworkInterface getUserListWithAgentUserID:delegate.agentUserID token:delegate.token page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"加载完成";
                    if (!isMore) {
                        [_dataItem removeAllObjects];
                    }
                    if ([[object objectForKey:@"result"] count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseUserDataWithDictionary:object];
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

//删除单个用户
- (void)deleteSingleUserWithIndexPath:(NSIndexPath *)indexPath {
    UserModel *model = [_dataItem objectAtIndex:indexPath.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];

    [NetworkInterface deleteUserWithAgentID:delegate.agentID token:delegate.token userIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:[model.userID intValue]]] finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
                    [_dataItem removeObject:model];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
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

- (void)deleteMultiUsers {
    NSArray *userIDs = [self usersIDForEditRows];
    if ([userIDs count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要删除的用户";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteUserWithAgentID:delegate.agentID token:delegate.token userIDs:userIDs finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
                    [self updateUserListForMultiDelete];
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

- (void)parseUserDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *userList = [dict objectForKey:@"result"];
    for (int i = 0; i < [userList count]; i++) {
        id userDict = [userList objectAtIndex:i];
        if ([userDict isKindOfClass:[NSDictionary class]]) {
            UserModel *model = [[UserModel alloc] initWithParseDictionary:userDict];
            [_dataItem addObject:model];
        }
    }
    [self.tableView reloadData];
}

//多删成功后更新列表
- (void)updateUserListForMultiDelete {
    NSMutableArray *deleteUserArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexArray = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_dataItem count]) {
            UserModel *model = [_dataItem objectAtIndex:[index intValue]];
            [deleteUserArray addObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[index intValue] inSection:0];
            [deleteIndexArray addObject:indexPath];
        }
    }
    [_dataItem removeObjectsInArray:deleteUserArray];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    self.isMultiDelete = NO;
}

//获取多选状态下选中的消息id数组
- (NSArray *)usersIDForEditRows {
    NSMutableArray *IDs = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_dataItem count]) {
            UserModel *model = [_dataItem objectAtIndex:[index intValue]];
            [IDs addObject:[NSNumber numberWithInt:[model.userID intValue]]];
        }
    }
    return IDs;
}

#pragma mark - Action

- (IBAction)showEdit:(id)sender {
    if (!_isMultiDelete && self.tableView.isEditing) {
        self.tableView.editing = NO;
    }
    self.isMultiDelete = !_isMultiDelete;
}

- (IBAction)deleteUser:(id)sender {
    [self deleteMultiUsers];
}

- (IBAction)cancelDelete:(id)sender {
    self.isMultiDelete = NO;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userIdentifier = @"userIdentifier";
    MultipleDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (cell == nil) {
        cell = [[MultipleDeleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier];
    }
    UserModel *model = [_dataItem objectAtIndex:indexPath.row];
    cell.textLabel.text = model.userName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMultiDelete) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteSingleUserWithIndexPath:indexPath];
    }
    else if (editingStyle == 3) {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMultiDelete) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UserModel *model = [_dataItem objectAtIndex:indexPath.row];
        UserTerminalController *terminalC = [[UserTerminalController alloc] init];
        terminalC.userModel = model;
        [self.navigationController pushViewController:terminalC animated:YES];
    }
    else {
        [_selectedItem setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMultiDelete) {
        [_selectedItem removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
    }
}

#pragma mark - 上下拉刷新重写

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isMultiDelete) {
        [super scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_isMultiDelete) {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - NSNotification

- (void)userListRefresh:(NSNotification *)notification {
    UserModel *deleteModel = [notification.userInfo objectForKey:userForDelete];
    if (deleteModel) {
        [_dataItem removeObject:deleteModel];
        [self.tableView reloadData];
    }
}


@end
