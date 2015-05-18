//
//  MessageViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MessageViewController.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "MultipleDeleteCell.h"
#import "MessageModel.h"
#import "MessageDetailController.h"

typedef enum {
    MessageSingleDeleteTag = 30,
    MessageMultiDeleteTag,
}MessageDeleteTag;

@interface MessageViewController ()<UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isMultiDelete;

@property (nonatomic, strong) NSMutableArray *messageItems;
@property (nonatomic, strong) NSMutableDictionary *selectedItem; //多选的行

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSIndexPath *deletePath;

@end

@implementation MessageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的消息";
    _messageItems = [[NSMutableArray alloc] init];
    _selectedItem = [[NSMutableDictionary alloc] init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(showEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
    [self firstLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMessageList:)
                                                 name:RefreshMessageListNotification
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarItem.badgeValue = nil;
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.messageCount = 0;
}

#pragma mark - UI

- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [self.tableView setEditing:_isMultiDelete animated:YES];
    if (_isMultiDelete) {
        [[AppDelegate shareAppDelegate].window addSubview:_bottomView];
    }
    else {
        [_selectedItem removeAllObjects];
        [_bottomView removeFromSuperview];
    }
    NSString *rightName = nil;
    if (_isMultiDelete) {
        rightName = @"取消";
    }
    else {
        rightName = @"编辑";
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:rightName
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(showEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setHeaderAndFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
    [self initBottomView];
}

- (void)initBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)];
    firstLine.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:firstLine];
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(10, 7, 80, 36);
    readBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [readBtn setTitle:@"标注为已读" forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(setReadAll:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:readBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 60, 7, 60, 36);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:deleteBtn];
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
    [NetworkInterface getMyMessageListWithAgentUserID:delegate.agentUserID token:delegate.token page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
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
                        [_messageItems removeAllObjects];
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
                    [self parseMessageListWithDictionary:object];
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

//标记已读
- (void)setReadStatusForSelectedMessages {
    NSArray *messagesID = [self messagesIDForEditRows];
    if ([messagesID count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要标注的消息";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface readMultiMessageWithAgentUserID:delegate.agentUserID token:delegate.token messageIDs:messagesID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"标注成功";
                    [self updateMessageStautsForRead];
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

//多删
- (void)deleteSelectedMessages {
    NSArray *messagesID = [self messagesIDForEditRows];
    if ([messagesID count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要删除的消息";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteMultiMessageWithAgentUserID:delegate.agentUserID token:delegate.token messageIDs:messagesID finished:^(BOOL success, NSData *response) {
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
                    [self updateMessageListForMultiDelete];
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

//单删
- (void)deleteSingleMessageWithIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = [_messageItems objectAtIndex:indexPath.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteSingleMessageWithAgentUserID:delegate.agentUserID token:delegate.token messageID:model.messageID finished:^(BOOL success, NSData *response) {
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
                    [_messageItems removeObject:model];
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

#pragma mark - Data

- (void)parseMessageListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([infoList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [infoList count]; i++) {
            id messageDict = [infoList objectAtIndex:i];
            if ([messageDict isKindOfClass:[NSDictionary class]]) {
                MessageModel *model = [[MessageModel alloc] initWithParseDictionary:messageDict];
                [_messageItems addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

//标注已读后更新状态
- (void)updateMessageStautsForRead {
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_messageItems count]) {
            MessageModel *model = [_messageItems objectAtIndex:[index intValue]];
            model.messageRead = YES;
        }
    }
    self.isMultiDelete = NO;
    [self.tableView reloadData];
}

//多删成功后更新列表
- (void)updateMessageListForMultiDelete {
    NSMutableArray *deleteMessageArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexArray = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_messageItems count]) {
            MessageModel *model = [_messageItems objectAtIndex:[index intValue]];
            [deleteMessageArray addObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[index intValue] inSection:0];
            [deleteIndexArray addObject:indexPath];
        }
    }
    [_messageItems removeObjectsInArray:deleteMessageArray];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    self.isMultiDelete = NO;
}

//获取多选状态下选中的消息id数组
- (NSArray *)messagesIDForEditRows {
    NSMutableArray *IDs = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_messageItems count]) {
            MessageModel *model = [_messageItems objectAtIndex:[index intValue]];
            [IDs addObject:model.messageID];
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

- (IBAction)setReadAll:(id)sender {
    [self setReadStatusForSelectedMessages];
}

- (IBAction)deleteMessage:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确认删除消息？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = MessageMultiDeleteTag;
    [alert show];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messageItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *messageIdentifier = @"messageIdentifier";
    MultipleDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
    if (cell == nil) {
        cell = [[MultipleDeleteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:messageIdentifier];
    }
    MessageModel *message = [_messageItems objectAtIndex:indexPath.row];
    cell.textLabel.text = message.messageTitle;
    cell.detailTextLabel.text = message.messageTime;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    cell.detailTextLabel.textColor = kColor(108, 108, 108, 1);
    if (message.messageRead) {
        cell.textLabel.textColor = kColor(108, 108, 108, 1);
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isMultiDelete) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MessageModel *message = [_messageItems objectAtIndex:indexPath.row];
        MessageDetailController *detailC = [[MessageDetailController alloc] init];
        detailC.message = message;
        detailC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailC animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _deletePath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"确认删除消息？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = MessageSingleDeleteTag;
        [alert show];
    }
    else if (editingStyle == 3) {

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

- (void)refreshMessageList:(NSNotification *)notification {
    id message = [notification.userInfo objectForKey:messageForDelete];
    if (message) {
        [_messageItems removeObject:message];
        [self.tableView reloadData];
    }
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == MessageSingleDeleteTag) {
            if (_deletePath) {
                [self deleteSingleMessageWithIndexPath:_deletePath];
            }
        }
        else if (alertView.tag == MessageMultiDeleteTag) {
            [self deleteSelectedMessages];
        }
    }
}

@end
