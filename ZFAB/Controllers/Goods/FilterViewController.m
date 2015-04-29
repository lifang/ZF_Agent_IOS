//
//  FilterViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "FilterViewController.h"
#import "NetworkInterface.h"
#import "TreeDataHandle.h"
#import "AppDelegate.h"
#import "RegularFormat.h"
#import "FilterContentViewController.h"

@interface FilterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *lowField;

@property (nonatomic, strong) UITextField *highField;

@property (nonatomic, strong) UISwitch *switchButton;
///下载的筛选条件
@property (nonatomic, strong) NSDictionary *loadDict;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(filterFinished:)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(filterCanceled:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    [self downloadFilterInfo];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    signOut.layer.cornerRadius = 4;
    signOut.layer.masksToBounds = YES;
    signOut.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [signOut setTitle:@"确认" forState:UIControlStateNormal];
    [signOut setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [signOut addTarget:self action:@selector(filterFinished:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signOut];
    self.tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
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
    [self initInputView];
}

- (void)initInputView {
    _switchButton = [[UISwitch alloc] init];
    _switchButton.onTintColor = kMainColor;
    _lowField = [[UITextField alloc] init];
    _lowField.font = [UIFont systemFontOfSize:14.f];
    _lowField.backgroundColor = [UIColor clearColor];
    _lowField.textAlignment = NSTextAlignmentRight;
    _lowField.placeholder = @"0";
    _lowField.delegate = self;
    _highField = [[UITextField alloc] init];
    _highField.font = [UIFont systemFontOfSize:14.f];
    _highField.backgroundColor = [UIColor clearColor];
    _highField.placeholder = @"0";
    _highField.textAlignment = NSTextAlignmentRight;
    _highField.delegate = self;
    
    [_switchButton setOn:[[_filterDict objectForKey:s_rent] boolValue]];
    _lowField.text = [NSString stringWithFormat:@"%d",[[_filterDict objectForKey:s_minPrice] intValue]];
    _highField.text = [NSString stringWithFormat:@"%d",[[_filterDict objectForKey:s_maxPrice] intValue]];
}

#pragma mark - Data

//界面上显示筛选条件名，顿号分隔
- (NSString *)nameForSelectedKey:(NSString *)key {
    NSArray *item = [_filterDict objectForKey:key];
    NSString *names = @"";
    for (int i = 0; i < [item count]; i++) {
        TreeNodeModel *node = [item objectAtIndex:i];
        names = [names stringByAppendingString:node.nodeName];
        if (i != [item count] - 1) {
            names = [names stringByAppendingString:@"、"];
        }
    }
    return names;
}

- (void)downloadFilterInfo {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getGoodSearchInfoWithCityID:delegate.cityID finished:^(BOOL success, NSData *response) {
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
                    _loadDict = [TreeDataHandle parseData:object];
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


#pragma mark - Action

- (IBAction)filterFinished:(id)sender {
    BOOL maxIsNumber = [RegularFormat isNumber:_highField.text];
    BOOL minIsNumber = [RegularFormat isNumber:_lowField.text];
    if (!maxIsNumber || !minIsNumber) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"价格必须为正整数，可输入0查询所有数据"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([_highField.text intValue] < [_lowField.text intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"最低价不能超过最高价"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [_filterDict setObject:[NSNumber numberWithBool:_switchButton.isOn] forKey:s_rent];
    [_filterDict setObject:[NSNumber numberWithFloat:[_highField.text intValue]] forKey:s_maxPrice];
    [_filterDict setObject:[NSNumber numberWithFloat:[_lowField.text intValue]] forKey:s_minPrice];
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateGoodListNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)filterCanceled:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 7;
            break;
        case 2:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = @"只包含租赁";
            _switchButton.frame = CGRectMake(kScreenWidth - 60, 6, 40, 30);
            [cell.contentView addSubview:_switchButton];
        }
            break;
        case 1: {
            NSString *titleName = nil;
            NSString *key = nil;
            switch (indexPath.row) {
                case 0:
                    titleName = @"选择POS品牌";
                    key = s_brands;
                    break;
                case 1:
                    titleName = @"选择POS类型";
                    key = s_category;
                    break;
                case 2:
                    titleName = @"选择支付通道";
                    key = s_channel;
                    break;
                case 3:
                    titleName = @"选择支付卡类型";
                    key = s_card;
                    break;
                case 4:
                    titleName = @"选择支付交易类型";
                    key = s_trade;
                    break;
                case 5:
                    titleName = @"选择签购单方式";
                    key = s_slip;
                    break;
                case 6:
                    titleName = @"选择对账日期";
                    key = s_date;
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.text = [self nameForSelectedKey:key];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"最低价￥";
                    _lowField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
                    [cell.contentView addSubview:_lowField];
                }
                    break;
                case 1: {
                    cell.textLabel.text = @"最高价￥";
                    _highField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
                    [cell.contentView addSubview:_highField];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        NSString *key = nil;
        switch (indexPath.row) {
            case 0:
                key = s_brands;
                break;
            case 1:
                key = s_category;
                break;
            case 2:
                key = s_channel;
                break;
            case 3:
                key = s_card;
                break;
            case 4:
                key = s_trade;
                break;
            case 5:
                key = s_slip;
                break;
            case 6:
                key = s_date;
                break;
            default:
                break;
        }
        FilterContentViewController *filterC = [[FilterContentViewController alloc] init];
        filterC.title = cell.textLabel.text;
        filterC.key = key;
        filterC.selectedFilterDict = _filterDict;
        filterC.dataItem = [_loadDict objectForKey:key];
        [self.navigationController pushViewController:filterC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
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

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    self.primaryPoint = self.tableView.contentOffset;
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y + self.offset) animated:YES];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y) animated:YES];
        self.offset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.editingField) {
        self.offset = 0;
        [self.editingField resignFirstResponder];
    }
}

@end
