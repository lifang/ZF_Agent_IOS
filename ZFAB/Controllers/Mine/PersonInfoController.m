//
//  PersonInfoController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/1.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PersonInfoController.h"
#import "NetworkInterface.h"
#import "PersonModel.h"
#import "AppDelegate.h"
#import "CityHandle.h"
#import "ModifyMobileController.h"
#import "ModifyEmailController.h"
#import "ModifyPasswordController.h"
#import "AddressViewController.h"

@interface PersonInfoController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PersonModel *personInfo;

@end

@implementation PersonInfoController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的信息";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self getPersonDetailInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPersonInfo:)
                                                 name:RefreshPersonInfoNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.f)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    NSString *typeString = nil;
    if ([_personInfo.type intValue] == AgentTypeCompany) {
        typeString = @"公司";
    }
    else {
        typeString = @"个人";
    }
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, 20)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.font = [UIFont boldSystemFontOfSize:15.f];
    typeLabel.text = [NSString stringWithFormat:@"代理商类型：%@",typeString];
    [headerView addSubview:typeLabel];
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
}

#pragma mark - Request

- (void)getPersonDetailInfo {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getPersonDetailWithAgentUserID:delegate.agentUserID token:delegate.token finished:^(BOOL success, NSData *response) {
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
                    id personDict = [object objectForKey:@"result"];
                    if ([personDict isKindOfClass:[NSDictionary class]]) {
                        _personInfo = [[PersonModel alloc] initWithParseDictionary:personDict];
                        [self initAndLayoutUI];
                    }
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_personInfo.type intValue] == AgentTypeCompany) {
        //公司
        return 4;
    }
    //个人
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if ([_personInfo.type intValue] == AgentTypeCompany) {
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
                row = 3;
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
                row = 3;
                break;
            default:
                break;
        }
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([_personInfo.type intValue] == AgentTypeCompany) {
        //公司
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            NSString *titleName = nil;
            NSString *imageName = nil;
            NSString *content = nil;
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0:
                            titleName = @"公司名称";
                            imageName = @"register1.png";
                            content = _personInfo.companyName;
                            break;
                        case 1:
                            titleName = @"公司营业执照登记号";
                            imageName = @"register2.png";
                            content = _personInfo.licenseNumber;
                            break;
                        case 2:
                            titleName = @"公司税务登记证号";
                            imageName = @"register3.png";
                            content = _personInfo.taxNumber;
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 1: {
                    switch (indexPath.row) {
                        case 0:
                            titleName = @"负责人姓名";
                            imageName = @"register4.png";
                            content = _personInfo.personName;
                            break;
                        case 1:
                            titleName = @"负责人身份证号";
                            imageName = @"register5.png";
                            content = _personInfo.personCardID;
                            break;
                        case 2:
                            titleName = @"手机";
                            imageName = @"register6.png";
                            content = _personInfo.mobileNumber;
                            break;
                        case 3:
                            titleName = @"邮箱";
                            imageName = @"register7.png";
                            content = _personInfo.email;
                            break;
                        case 4:
                            titleName = @"所在省市";
                            imageName = @"register8.png";
                            content = [CityHandle getCityNameWithCityID:_personInfo.cityID];
                            break;
                        case 5:
                            titleName = @"详细地址";
                            imageName = @"register9.png";
                            content = _personInfo.address;
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 3: {
                    switch (indexPath.row) {
                        case 0:
                            titleName = @"用户名";
                            imageName = @"register10.png";
                            content = _personInfo.userName;
                            break;
                        case 1:
                            titleName = @"修改账户密码";
                            imageName = @"register11.png";
                            content = nil;
                            break;
                        case 2:
                            titleName = @"收货地址管理";
                            imageName = @"register9.png";
                            content = nil;
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
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.text = content;
            cell.imageView.image = kImageName(imageName);
            if ((indexPath.section == 1 && (indexPath.row == 2 || indexPath.row == 3)) ||
                (indexPath.section == 3 && (indexPath.row == 1 || indexPath.row == 2))) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
            UIImageView *uploadView = [[UIImageView alloc] initWithFrame:rect];
            uploadView.image = kImageName(@"upload.png");
            [cell.contentView addSubview:uploadView];
            NSString *titleName = nil;
            NSString *imageName = nil;
            BOOL hasImage = NO;
            switch (indexPath.row) {
                case 0:
                    titleName = @"身份证照片";
                    imageName = @"register5.png";
                    hasImage = (_personInfo.cardImagePath && ![_personInfo.cardImagePath isEqualToString:@""]);
                    break;
                case 1:
                    titleName = @"营业执照照片";
                    imageName = @"register2.png";
                    hasImage = (_personInfo.licenseImagePath && ![_personInfo.licenseImagePath isEqualToString:@""]);
                    break;
                case 2:
                    titleName = @"税务登记证照片";
                    imageName = @"register3.png";
                    hasImage = (_personInfo.taxImagePath && ![_personInfo.taxImagePath isEqualToString:@""]);
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.imageView.image = kImageName(imageName);
            if (hasImage) {
                uploadView.hidden = NO;
            }
            else {
                uploadView.hidden = YES;
            }
        }
    }
    else {
        //个人
        if (indexPath.section == 0 || indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            NSString *titleName = nil;
            NSString *imageName = nil;
            NSString *content = nil;
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0:
                            titleName = @"负责人姓名";
                            imageName = @"register4.png";
                            content = _personInfo.personName;
                            break;
                        case 1:
                            titleName = @"负责人身份证号";
                            imageName = @"register5.png";
                            content = _personInfo.personCardID;
                            break;
                        case 2:
                            titleName = @"手机";
                            imageName = @"register6.png";
                            content = _personInfo.mobileNumber;
                            break;
                        case 3:
                            titleName = @"邮箱";
                            imageName = @"register7.png";
                            content = _personInfo.email;
                            break;
                        case 4:
                            titleName = @"所在省市";
                            imageName = @"register8.png";
                            content = [CityHandle getCityNameWithCityID:_personInfo.cityID];
                            break;
                        case 5:
                            titleName = @"详细地址";
                            imageName = @"register9.png";
                            content = _personInfo.address;
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 2: {
                    switch (indexPath.row) {
                        case 0:
                            titleName = @"用户名";
                            imageName = @"register10.png";
                            content = _personInfo.userName;
                            break;
                        case 1:
                            titleName = @"修改账户密码";
                            imageName = @"register11.png";
                            content = nil;
                            break;
                        case 2:
                            titleName = @"收货地址管理";
                            imageName = @"register9.png";
                            content = nil;
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
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.text = content;
            cell.imageView.image = kImageName(imageName);
            if ((indexPath.section == 0 && (indexPath.row == 2 || indexPath.row == 3)) ||
                (indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2))) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
            UIImageView *uploadView = [[UIImageView alloc] initWithFrame:rect];
            uploadView.image = kImageName(@"upload.png");
            [cell.contentView addSubview:uploadView];
            NSString *titleName = nil;
            NSString *imageName = nil;
            BOOL hasImage = NO;
            switch (indexPath.row) {
                case 0:
                    titleName = @"身份证照片";
                    imageName = @"register5.png";
                    hasImage = (_personInfo.cardImagePath && ![_personInfo.cardImagePath isEqualToString:@""]);
                    break;
//                case 1:
//                    titleName = @"营业执照照片";
//                    imageName = @"register2.png";
//                    hasImage = (_personInfo.licenseImagePath && ![_personInfo.licenseImagePath isEqualToString:@""]);
//                    break;
//                case 2:
//                    titleName = @"税务登记证照片";
//                    imageName = @"register3.png";
//                    hasImage = (_personInfo.taxImagePath && ![_personInfo.taxImagePath isEqualToString:@""]);
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.imageView.image = kImageName(imageName);
            if (hasImage) {
                uploadView.hidden = NO;
            }
            else {
                uploadView.hidden = YES;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_personInfo.type intValue] == AgentTypeCompany) {
        if (indexPath.section == 1 && indexPath.row == 2) {
            //修改手机
            ModifyMobileController *mobileC = [[ModifyMobileController alloc] init];
            mobileC.personInfo = _personInfo;
            [self.navigationController pushViewController:mobileC animated:YES];
        }
        else if (indexPath.section == 1 && indexPath.row == 3) {
            //修改邮箱
            ModifyEmailController *emailC = [[ModifyEmailController alloc] init];
            emailC.personInfo = _personInfo;
            [self.navigationController pushViewController:emailC animated:YES];
        }
        else if (indexPath.section == 3 && indexPath.row == 1) {
            //修改密码
            ModifyPasswordController *modifyC = [[ModifyPasswordController alloc] init];
            [self.navigationController pushViewController:modifyC animated:YES];
        }
        else if (indexPath.section == 3 && indexPath.row == 2) {
            //修改地址
            AddressViewController *addressC = [[AddressViewController alloc] init];
            [self.navigationController pushViewController:addressC animated:YES];
        }
    }
    else {
        if (indexPath.section == 0 && indexPath.row == 2) {
            //修改手机
            ModifyMobileController *mobileC = [[ModifyMobileController alloc] init];
            mobileC.personInfo = _personInfo;
            [self.navigationController pushViewController:mobileC animated:YES];
        }
        else if (indexPath.section == 0 && indexPath.row == 3) {
            //修改邮箱
            ModifyEmailController *emailC = [[ModifyEmailController alloc] init];
            emailC.personInfo = _personInfo;
            [self.navigationController pushViewController:emailC animated:YES];
        }
        else if (indexPath.section == 2 && indexPath.row == 1) {
            //修改密码
            ModifyPasswordController *modifyC = [[ModifyPasswordController alloc] init];
            [self.navigationController pushViewController:modifyC animated:YES];
        }
        else if (indexPath.section == 2 && indexPath.row == 2) {
            //修改地址
            AddressViewController *addressC = [[AddressViewController alloc] init];
            [self.navigationController pushViewController:addressC animated:YES];
        }
    }
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

- (void)refreshPersonInfo:(NSNotification *)notification {
    [_tableView reloadData];
}

@end
