//
//  UserTerminalController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "UserTerminalController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface UserTerminalController ()

@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation UserTerminalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _userModel.userName;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"delete.png")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(deleteUser:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth - 20, 20)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:15.f];
    infoLabel.text = @"持有终端";
    [headerView addSubview:infoLabel];
    
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
    [NetworkInterface getUserTerminalListWithUserID:_userModel.userID token:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [self parseUserTerminalWithDictionary:object];
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

//删除
- (void)deleteSingleUser {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteUserWithAgentID:delegate.agentID token:delegate.token userID:_userModel.userID finished:^(BOOL success, NSData *response) {
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
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          _userModel,userForDelete,
                                          nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserListNotification object:nil userInfo:dict];
                    [self.navigationController popViewControllerAnimated:YES];
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

- (void)parseUserTerminalWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *terminalList = [dict objectForKey:@"result"];
    for (int i = 0; i < [terminalList count]; i++) {
        id terminalDict = [terminalList objectAtIndex:i];
        if ([terminalDict isKindOfClass:[NSDictionary class]]) {
            UserTerminalModel *model = [[UserTerminalModel alloc] initWithParseDictionary:terminalDict];
            [_dataItem addObject:model];
        }
    }
    [self.tableView reloadData]; 
}

#pragma mark - Action

- (IBAction)deleteUser:(id)sender {
    [self deleteSingleUser];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *terminalIdentifier = @"terminalIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:terminalIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:terminalIdentifier];
    }
    UserTerminalModel *model = [_dataItem objectAtIndex:indexPath.row];
    NSString *terminalString = [NSString stringWithFormat:@"终端号：%@",model.terminalNum];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:terminalString];
    NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                               nil];
    NSDictionary *contentAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont boldSystemFontOfSize:15],NSFontAttributeName,
                                 nil];
    [attrString addAttributes:titleAttr range:NSMakeRange(0, 4)];
    [attrString addAttributes:contentAttr range:NSMakeRange(4, [attrString length] - 4)];
    cell.textLabel.attributedText = attrString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

@end
