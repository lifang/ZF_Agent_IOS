//
//  SubAgentDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SubAgentDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "SubAgentDetailModel.h"
#import "BenefitListController.h"

@interface SubAgentDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UIButton *benefitBtn;

@property (nonatomic, strong) SubAgentDetailModel *agentDetail;

@end

@implementation SubAgentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _subAgent.agentName;
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self getSubAgentDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kScreenWidth - 120, 20)];
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.font = [UIFont boldSystemFontOfSize:15.f];
    _typeLabel.text = @"代理商类型：";
    [headerView addSubview:_typeLabel];
    
    _benefitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _benefitBtn.frame = CGRectMake(kScreenWidth - 90, 15, 18, 18);
    [_benefitBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_benefitBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_benefitBtn addTarget:self action:@selector(needBenefit:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_benefitBtn];
    
    UILabel *benefitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 15, 60, 20)];
    benefitLabel.backgroundColor = [UIColor clearColor];
    benefitLabel.font = [UIFont systemFontOfSize:14.f];
    benefitLabel.textAlignment = NSTextAlignmentRight;
    benefitLabel.text = @"开通分润";
    benefitLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(needBenefit:)];
    [benefitLabel addGestureRecognizer:tap];
    [headerView addSubview:benefitLabel];
}

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setHeaderAndFooterView];
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

#pragma mark - Request

- (void)getSubAgentDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getSubAgentDetailWithToken:delegate.token subAgentID:_subAgent.agentID finished:^(BOOL success, NSData *response) {
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
                    [self parseAgentDetailWithDictionary:object];
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

- (void)setHasBenefit {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    int benefit = 1;
    if (!_benefitBtn.isSelected) {
        //请求成功才修改按钮状态 因此是反的
        benefit = 2;
    }
    [NetworkInterface setHasBenefitWithAgentID:delegate.agentID subAgentID:_subAgent.agentID hasBenefit:benefit finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"设置成功";
                    BOOL isSelected = NO;
                    if (benefit == 2) {
                        isSelected = YES;
                    }
                    [self showButtonStatusWithSelected:isSelected];
                    _agentDetail.hasProfit = isSelected;
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

- (void)parseAgentDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _agentDetail = [[SubAgentDetailModel alloc] initWithParseDictionary:[dict objectForKey:@"result"]];
    [self initAndLayoutUI];
    if (_agentDetail.agentType == AgentTypeCompany) {
        _typeLabel.text = @"代理商类型：公司";
    }
    else {
        _typeLabel.text = @"代理商类型：个人";
    }
    if (_agentDetail.hasProfit) {
        [self showButtonStatusWithSelected:YES];
    }
}

- (void)showSettingBenefitItem {
    if (_benefitBtn.isSelected) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"设置分润"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(setBenefit:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)showButtonStatusWithSelected:(BOOL)selected {
    _benefitBtn.selected = selected;
    if (_benefitBtn.isSelected) {
        [_benefitBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
    }
    else {
        [_benefitBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    }
    [self showSettingBenefitItem];
}

#pragma mark - Action

- (IBAction)setBenefit:(id)sender {
    BenefitListController *benefitC = [[BenefitListController alloc] init];
    benefitC.subAgentID = _subAgent.agentID;
    [self.navigationController pushViewController:benefitC animated:YES];
}

- (IBAction)needBenefit:(id)sender {
    [self setHasBenefit];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_agentDetail.agentType == AgentTypeCompany) {
        //公司
        return 5;
    }
    //个人
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if (_agentDetail.agentType == AgentTypeCompany) {
        //公司
        switch (section) {
            case 0:
                row = 3;
                break;
            case 1:
                row = 6;
                break;
            case 2:
                row = 3;
                break;
            case 3:
                row = 1;
                break;
            case 4:
                row = 4;
                break;
            default:
                break;
        }
    }
    else {
        //个人
        switch (section) {
            case 0:
                row = 6;
                break;
            case 1:
                row = 1;
                break;
            case 2:
                row = 1;
                break;
            case 3:
                row = 4;
                break;
            default:
                break;
        }
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (_agentDetail.agentType == AgentTypeCompany) {
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            NSString *titleName = nil;
            NSString *imageName = nil;
            NSString *content = nil;
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0:
                            content = _agentDetail.companyName;
                            titleName = @"公司名称";
                            imageName = @"register1.png";
                            break;
                        case 1:
                            content = _agentDetail.licenseNumber;
                            titleName = @"公司营业执照登记号";
                            imageName = @"register2.png";
                            break;
                        case 2:
                            content = _agentDetail.taxNumber;
                            titleName = @"公司税务登记证号";
                            imageName = @"register3.png";
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 1: {
                    switch (indexPath.row) {
                        case 0:
                            content = _agentDetail.personName;
                            titleName = @"负责人姓名";
                            imageName = @"register4.png";
                            break;
                        case 1:
                            content = _agentDetail.personID;
                            titleName = @"负责人身份证号";
                            imageName = @"register5.png";
                            break;
                        case 2:
                            content = _agentDetail.mobilePhone;
                            titleName = @"手机";
                            imageName = @"register6.png";
                            break;
                        case 3:
                            content = _agentDetail.email;
                            titleName = @"邮箱";
                            imageName = @"register7.png";
                            break;
                        case 4:
                            content = [NSString stringWithFormat:@"%@ %@",_agentDetail.provinceName,_agentDetail.cityName];
                            titleName = @"所在省市";
                            imageName = @"register8.png";
                            break;
                        case 5:
                            content = _agentDetail.address;
                            titleName = @"详细地址";
                            imageName = @"register9.png";
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 3: {
                    switch (indexPath.row) {
                        case 0:
                            content = _agentDetail.loginName;
                            titleName = @"用户名";
                            imageName = @"register10.png";
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.imageView.image = kImageName(imageName);
            cell.detailTextLabel.text = content;
        }
        else if (indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
            UIImageView *uploadView = [[UIImageView alloc] initWithFrame:rect];
            uploadView.image = kImageName(@"upload.png");
            [cell.contentView addSubview:uploadView];
            NSString *titleName = nil;
            NSString *imageName = nil;
            BOOL hasImage = NO;
            switch (indexPath.row) {
                case 0:
                    hasImage = (_agentDetail.cardImagePath && ![_agentDetail.cardImagePath isEqualToString:@""]);
                    titleName = @"身份证照片";
                    imageName = @"register5.png";
                    break;
                case 1:
                    hasImage = (_agentDetail.licenseImagePath && ![_agentDetail.licenseImagePath isEqualToString:@""]);
                    titleName = @"营业执照照片";
                    imageName = @"register2.png";
                    break;
                case 2:
                    hasImage = (_agentDetail.taxImagePath && ![_agentDetail.taxImagePath isEqualToString:@""]);
                    titleName = @"税务登记证照片";
                    imageName = @"register3.png";
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.imageView.image = kImageName(imageName);
            if (hasImage) {
                uploadView.hidden = NO;
            }
            else {
                uploadView.hidden = YES;
            }
        }
        else if (indexPath.section == 4) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, cell.bounds.size.height)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:15.f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, cell.bounds.size.height)];
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.font = [UIFont systemFontOfSize:15.f];
            contentLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:contentLabel];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 0, 1, cell.bounds.size.height)];
            line.image = kImageName(@"gray.png");
            [cell.contentView addSubview:line];
            NSString *titleName = nil;
            NSString *content = nil;
            switch (indexPath.row) {
                case 0:
                    titleName = @"加入时间";
                    content = _agentDetail.createTime;
                    break;
                case 1:
                    titleName = @"已售出";
                    content = [NSString stringWithFormat:@"%d",_agentDetail.saleCount];
                    break;
                case 2:
                    titleName = @"剩余库存";
                    content = [NSString stringWithFormat:@"%d",_agentDetail.remainCount];
                    break;
                case 3:
                    titleName = @"终端开通量";
                    content = [NSString stringWithFormat:@"%d",_agentDetail.openCount];
                    break;
                default:
                    break;
            }
            titleLabel.text = titleName;
            contentLabel.text = content;
        }
    }
    else {
        if (indexPath.section == 0 || indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            NSString *titleName = nil;
            NSString *imageName = nil;
            NSString *content = nil;
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0:
                            content = _agentDetail.personName;
                            titleName = @"负责人姓名";
                            imageName = @"register4.png";
                            break;
                        case 1:
                            content = _agentDetail.personID;
                            titleName = @"负责人身份证号";
                            imageName = @"register5.png";
                            break;
                        case 2:
                            content = _agentDetail.mobilePhone;
                            titleName = @"手机";
                            imageName = @"register6.png";
                            break;
                        case 3:
                            content = _agentDetail.email;
                            titleName = @"邮箱";
                            imageName = @"register7.png";
                            break;
                        case 4:
                            content = [NSString stringWithFormat:@"%@ %@",_agentDetail.provinceName,_agentDetail.cityName];
                            titleName = @"所在省市";
                            imageName = @"register8.png";
                            break;
                        case 5:
                            content = _agentDetail.address;
                            titleName = @"详细地址";
                            imageName = @"register9.png";
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 2: {
                    switch (indexPath.row) {
                        case 0:
                            content = _agentDetail.loginName;
                            titleName = @"用户名";
                            imageName = @"register10.png";
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.imageView.image = kImageName(imageName);
            cell.detailTextLabel.text = content;
        }
        else if (indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
            UIImageView *uploadView = [[UIImageView alloc] initWithFrame:rect];
            uploadView.image = kImageName(@"upload.png");
            [cell.contentView addSubview:uploadView];
            NSString *titleName = nil;
            NSString *imageName = nil;
            BOOL hasImage = NO;
            switch (indexPath.row) {
                case 0:
                    hasImage = (_agentDetail.cardImagePath && ![_agentDetail.cardImagePath isEqualToString:@""]);
                    titleName = @"身份证照片";
                    imageName = @"register5.png";
                    break;
                case 1:
                    hasImage = (_agentDetail.licenseImagePath && ![_agentDetail.licenseImagePath isEqualToString:@""]);
                    titleName = @"营业执照照片";
                    imageName = @"register2.png";
                    break;
                case 2:
                    hasImage = (_agentDetail.taxImagePath && ![_agentDetail.taxImagePath isEqualToString:@""]);
                    titleName = @"税务登记证照片";
                    imageName = @"register3.png";
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.imageView.image = kImageName(imageName);
            if (hasImage) {
                uploadView.hidden = NO;
            }
            else {
                uploadView.hidden = YES;
            }
        }
        else if (indexPath.section == 3) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, cell.bounds.size.height)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:15.f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, cell.bounds.size.height)];
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.font = [UIFont systemFontOfSize:15.f];
            contentLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:contentLabel];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 0, 1, cell.bounds.size.height)];
            line.image = kImageName(@"gray.png");
            [cell.contentView addSubview:line];
            NSString *titleName = nil;
            NSString *content = nil;
            switch (indexPath.row) {
                case 0:
                    titleName = @"加入时间";
                    content = _agentDetail.createTime;
                    break;
                case 1:
                    titleName = @"已售出";
                    content = [NSString stringWithFormat:@"%d",_agentDetail.saleCount];
                    break;
                case 2:
                    titleName = @"剩余库存";
                    content = [NSString stringWithFormat:@"%d",_agentDetail.remainCount];
                    break;
                case 3:
                    titleName = @"终端开通量";
                    content = [NSString stringWithFormat:@"%d",_agentDetail.openCount];
                    break;
                default:
                    break;
            }
            titleLabel.text = titleName;
            contentLabel.text = content;
        }
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

@end
