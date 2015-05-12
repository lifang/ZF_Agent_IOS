//
//  UserListViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "UserListViewController.h"
#import "MultipleDeleteCell.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "AddUserViewController.h"

@interface UserListViewController ()

@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation UserListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择用户";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"add.png")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(addUser:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:RefreshUserNotification
                                               object:nil];
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

#pragma mark - Action

- (IBAction)addUser:(id)sender {
    AddUserViewController *addC = [[AddUserViewController alloc] init];
    [self.navigationController pushViewController:addC animated:YES];
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
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    NSString *content = model.userName;
    if (!model.userName || [model.userName isEqualToString:@""]) {
        if (model.phone && ![model.phone isEqualToString:@""]) {
            content = model.phone;
        }
        else {
            content = model.email;
        }
    }
    cell.textLabel.text = content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserModel *model = [_dataItem objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedUser:)]) {
        [_delegate selectedUser:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上下拉刷新重写


- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - Notification

- (void)refreshData:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

@end
