//
//  SubAgentListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SubAgentListController.h"
#import "AppDelegate.h"
#import "SubAgentCell.h"
#import "DefaultBenefitController.h"
#import "CreateAgentController.h"
#import "SubAgentDetailController.h"

@interface SubAgentListController ()<UpdateDefaultBenefitDelegate>

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, assign) CGFloat defaultBenefit;

@end

@implementation SubAgentListController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"管理下级代理商";
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
    [self getDefaultBenefit];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAgentList:)
                                                 name:RefeshAgentListNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
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
    [NetworkInterface getSubAgentListWithAgentID:delegate.agentID token:delegate.token page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        hud.hidden = YES;
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseSubAgentListWithDictionary:object];
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

//获取默认分润
- (void)getDefaultBenefit {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getDefaultBenefitWithAgentID:delegate.agentID token:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    _defaultBenefit = [[object objectForKey:@"result"] floatValue];
                    [self.tableView reloadData];
                }
            }
            else {
                //返回错误数据
            }
        }
        else {
        }
    }];
}

#pragma mark - Data

- (void)parseSubAgentListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([infoList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [infoList count]; i++) {
            id agentDict = [infoList objectAtIndex:i];
            if ([agentDict isKindOfClass:[NSDictionary class]]) {
                SubAgentModel *model = [[SubAgentModel alloc] initWithParseDictionary:agentDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
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
            row = 1;
            break;
        case 2:
            row = [_dataItem count];
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        NSString *titleName = nil;
        NSString *content = nil;
        switch (indexPath.section) {
            case 0:
                titleName = @"设置默认分润比例";
                content = [NSString stringWithFormat:@"%.1f%%",_defaultBenefit];
                break;
            case 1:
                titleName = @"创建下级代理商";
                break;
            default:
                break;
        }
        cell.textLabel.text = titleName;
        cell.detailTextLabel.text = content;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else {
        //下级代理商
        static NSString *subAgentIdentifier = @"subAgentIdentifier";
        SubAgentCell *cell = [tableView dequeueReusableCellWithIdentifier:subAgentIdentifier];
        if (cell == nil) {
            cell = [[SubAgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subAgentIdentifier];
        }
        SubAgentModel *model = [_dataItem objectAtIndex:indexPath.row];
        [cell setContentWithData:model];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            //默认分润
            DefaultBenefitController *benefitC = [[DefaultBenefitController alloc] init];
            benefitC.delegate = self;
            benefitC.benefit = _defaultBenefit;
            [self.navigationController pushViewController:benefitC animated:YES];
        }
            break;
        case 1: {
            //创建下级代理商
            CreateAgentController *createC = [[CreateAgentController alloc] init];
            [self.navigationController pushViewController:createC animated:YES];
        }
            break;
        case 2: {
            SubAgentModel *model = [_dataItem objectAtIndex:indexPath.row];
            SubAgentDetailController *detailC = [[SubAgentDetailController alloc] init];
            detailC.subAgent = model;
            [self.navigationController pushViewController:detailC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return kSubAgentCellHeight;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.f;
    switch (section) {
        case 0:
            height = 0.001f;
            break;
        case 1:
            height = 5.f;
            break;
        case 2:
            height = 20.f;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - NSNotification

- (void)refreshAgentList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - UpdateBenefitDelegate

- (void)getNewDefaultBenefit:(CGFloat)newBenefit {
    _defaultBenefit = newBenefit;
    [self.tableView reloadData];
}

@end
