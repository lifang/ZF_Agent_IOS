//
//  AddressViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressEditController.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "MultipleDeleteCell.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isMultiDelete;

@property (nonatomic, strong) NSMutableArray *addressItems;

@property (nonatomic, strong) NSMutableDictionary *selectedItem; //多选的行

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地址管理";
    _addressItems = [[NSMutableArray alloc] init];
    _selectedItem = [[NSMutableDictionary alloc] init];
    [self initAndLayoutUI];
    [self getAddressList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:RefreshAddressListNotification object:nil];
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
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 24, 24);
    [deleteButton setBackgroundImage:kImageName(@"delete.png") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(multiDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 24, 24);
    [addButton setBackgroundImage:kImageName(@"add.png") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -5;
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,deleteItem,addItem, nil];
}

- (void)initContentView {
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
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initBottomView];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
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
    [deleteBtn addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:deleteBtn];
}

- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [_tableView setEditing:_isMultiDelete animated:YES];
    if (_isMultiDelete) {
        [self.view addSubview:_bottomView];
    }
    else {
        [_selectedItem removeAllObjects];
        [_bottomView removeFromSuperview];
    }
}

#pragma mark - Request

- (void)getAddressList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAddressListWithAgentUserID:delegate.agentUserID token:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [_addressItems removeAllObjects];
                    [self parseAddressListDataWithDict:object];
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

//地址单删
- (void)deleteSingleAddressWithIndexPath:(NSIndexPath *)indexPath {
    AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteAddressWithToken:delegate.token addressIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:[model.addressID intValue]]] finished:^(BOOL success, NSData *response) {
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
                    [_addressItems removeObject:model];
                    [_tableView beginUpdates];
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [_tableView endUpdates];
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

//地址多删
- (void)deleteMultiAddress {
    NSArray *addressID = [self addresssIDForEditRows];
    if ([addressID count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要删除的地址";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteAddressWithToken:delegate.token addressIDs:addressID finished:^(BOOL success, NSData *response) {
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
                    [self updateAddressListForMultiDelete];
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

- (void)parseAddressListDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *addressList = [dict objectForKey:@"result"];
    for (int i = 0; i < [addressList count]; i++) {
        NSDictionary *addressDict = [addressList objectAtIndex:i];
        AddressModel *model = [[AddressModel alloc] initWithParseDictionary:addressDict];
        [_addressItems addObject:model];
    }
    [_tableView reloadData];
}

//多删成功后更新列表
- (void)updateAddressListForMultiDelete {
    NSMutableArray *deleteAddressArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexArray = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_addressItems count]) {
            AddressModel *model = [_addressItems objectAtIndex:[index intValue]];
            [deleteAddressArray addObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[index intValue] inSection:0];
            [deleteIndexArray addObject:indexPath];
        }
    }
    [_addressItems removeObjectsInArray:deleteAddressArray];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:deleteIndexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    self.isMultiDelete = NO;
}

//获取多选状态下选中的地址id数组
- (NSArray *)addresssIDForEditRows {
    NSMutableArray *IDs = [[NSMutableArray alloc] init];
    for (NSNumber *index in _selectedItem) {
        if ([index intValue] < [_addressItems count]) {
            AddressModel *model = [_addressItems objectAtIndex:[index intValue]];
            [IDs addObject:model.addressID];
        }
    }
    return IDs;
}

#pragma mark - Action

- (IBAction)multiDelete:(id)sender {
    if (!_isMultiDelete && _tableView.isEditing) {
        _tableView.editing = NO;
    }
    self.isMultiDelete = !_isMultiDelete;
}

- (IBAction)addAddress:(id)sender {
    if (_isMultiDelete) {
        self.isMultiDelete = NO;
    }
    AddressEditController *modifyC = [[AddressEditController alloc] init];
    modifyC.type = AddressAdd;
    [self.navigationController pushViewController:modifyC animated:YES];
}

- (IBAction)cancelDelete:(id)sender {
    self.isMultiDelete = NO;
}

- (IBAction)deleteAddress:(id)sender {
    [self deleteMultiAddress];
}


#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_addressItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Address";
    MultipleDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MultipleDeleteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
    NSString *receiver = [NSString stringWithFormat:@"收件人：%@",model.addressReceiver];
    NSString *totalString = [NSString stringWithFormat:@"%@   %@",receiver,model.addressPhone];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSDictionary *receiverAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont boldSystemFontOfSize:15.f],NSFontAttributeName,
                                  nil];
    NSDictionary *phoneAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont systemFontOfSize:14],NSFontAttributeName,
                               nil];
    [attrString addAttributes:receiverAttr range:NSMakeRange(0, [receiver length])];
    [attrString addAttributes:phoneAttr range:NSMakeRange([receiver length], [attrString length] - [receiver length])];
    cell.textLabel.attributedText = attrString;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"收件地址：%@",model.address];
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
        [self deleteSingleAddressWithIndexPath:indexPath];
    }
    else if (editingStyle == 3) {
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMultiDelete) {
        AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
        AddressEditController *modifyC = [[AddressEditController alloc] init];
        modifyC.type = AddressModify;
        modifyC.address = model;
        [self.navigationController pushViewController:modifyC animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
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

#pragma mark - NSNotification

- (void)refreshList:(NSNotification *)notification {
    [self getAddressList];
}


@end
