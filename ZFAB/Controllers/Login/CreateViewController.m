//
//  CreateViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CreateViewController.h"
#import "RegularFormat.h"
#import "CityHandle.h"

#define kRegisterInputViewTag   100
#define kRegisterImageViewTag   101

@interface RegisterCell : UITableViewCell

@property (nonatomic, strong) NSString *key;

@end

@implementation RegisterCell

@end

@interface RegisterTextField : UITextField

@property (nonatomic, strong) NSString *key;

@end

@implementation RegisterTextField

@end

@interface CreateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property (nonatomic, strong) NSString *selectedKey; //用于记录点击的是哪一行
@property (nonatomic, assign) CGRect imageRect;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请成为代理商";
    _agentType = AgentTypeCompany;
    _registerDict = [[NSMutableDictionary alloc] init];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    //子类重写
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
    [self initInputView];
    [self initPickerView];
}

- (void)initInputView {
    CGFloat imageSize = 16.0f; //输入框图片大小
    _usernameField = [[UITextField alloc] init];
    _usernameField.delegate = self;
    _usernameField.placeholder = @"用户名";
    _usernameField.font = [UIFont systemFontOfSize:15.f];
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, imageSize, imageSize)];
    userImageView.image = kImageName(@"register10.png");
    [userView addSubview:userImageView];
    _usernameField.leftView = userView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.secureTextEntry = YES;
    _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.delegate = self;
    _passwordField.placeholder = @"登录密码";
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *pwsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, imageSize, imageSize)];
    pwsImageView.image = kImageName(@"register11.png");
    [pwdView addSubview:pwsImageView];
    _passwordField.leftView = pwdView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.secureTextEntry = YES;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _confirmField = [[UITextField alloc] init];
    _confirmField.delegate = self;
    _confirmField.placeholder = @"确认密码";
    _confirmField.font = [UIFont systemFontOfSize:15.f];
    _confirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmField.secureTextEntry = YES;
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, imageSize)];
    UIImageView *confirmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, imageSize, imageSize)];
    confirmImageView.image = kImageName(@"register11.png");
    [confirmView addSubview:confirmImageView];
    _confirmField.leftView = confirmView;
    _confirmField.leftViewMode = UITextFieldViewModeAlways;
    _confirmField.secureTextEntry = YES;
    _confirmField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(selectedCity:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
}


#pragma mark - Set

- (void)setAgentType:(AgentType)agentType {
    _agentType = agentType;
    [_tableView reloadData];
}

#pragma mark - Request

- (void)uploadPictureWithImage:(UIImage *)image {
    
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    self.agentType = (AgentType)([_segmentControl selectedSegmentIndex] + 1);
}

- (IBAction)selectedCity:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [_pickerView selectedRowInComponent:1];
    NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
    if (cityID) {
        [_registerDict setObject:cityID forKey:key_city];
    }
    [_tableView reloadData];
}

#pragma mark - 数据验证

- (void)dataValidation {
    if (self.agentType == AgentTypeCompany) {
        if (![_registerDict objectForKey:key_company] || [[_registerDict objectForKey:key_company] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写公司名称";
            return;
        }
        if (![_registerDict objectForKey:key_license] || [[_registerDict objectForKey:key_license] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写营业执照登记号";
            return;
        }
        if (![_registerDict objectForKey:key_tax] || [[_registerDict objectForKey:key_tax] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写税务登记证号";
            return;
        }
        if (![_registerDict objectForKey:key_licenseImage] || [[_registerDict objectForKey:key_licenseImage] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请上传营业执照照片";
            return;
        }
        if (![_registerDict objectForKey:key_taxImage] || [[_registerDict objectForKey:key_taxImage] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请上传税务登记证照片";
            return;
        }
    }
    if (![_registerDict objectForKey:key_person] || [[_registerDict objectForKey:key_person] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写负责人姓名";
        return;
    }
    if (![_registerDict objectForKey:key_personCardID] || [[_registerDict objectForKey:key_personCardID] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写负责人身份证号";
        return;
    }
    if (![_registerDict objectForKey:key_phone] || [[_registerDict objectForKey:key_phone] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写手机";
        return;
    }
    if (![_registerDict objectForKey:key_email] || [[_registerDict objectForKey:key_email] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮箱";
        return;
    }
    if (![_registerDict objectForKey:key_city] || [[_registerDict objectForKey:key_city] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
    }
    if (![_registerDict objectForKey:key_address] || [[_registerDict objectForKey:key_address] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写详细地址";
        return;
    }
    if (![_registerDict objectForKey:key_cardImage] || [[_registerDict objectForKey:key_cardImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传身份证照片";
        return;
    }
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写用户名";
        return;
    }
    if (!_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写密码";
        return;
    }
    if (!_confirmField.text || [_confirmField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写确认密码";
        return;
    }
    if (![RegularFormat isMobileNumber:[_registerDict objectForKey:key_phone]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的手机";
        return;
    }
    if (![RegularFormat isCorrectEmail:[_registerDict objectForKey:key_email]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的邮箱";
        return;
    }
    if (![_passwordField.text isEqualToString:_confirmField.text]) {
        if (![_registerDict objectForKey:key_tax] || [[_registerDict objectForKey:key_tax] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"两次密码输入不一致";
            return;
        }
    }
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_agentType == AgentTypeCompany) {
        //公司
        return 4;
    }
    //个人
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if (_agentType == AgentTypeCompany) {
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
    RegisterCell *cell = nil;
    if (_agentType == AgentTypeCompany) {
        if (indexPath.section == 0 || indexPath.section == 1) {
            //第一二排 输入信息
            static NSString *firstIdentifier = @"firstIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifier];
            if (cell == nil) {
                cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIdentifier];
                CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                RegisterTextField *textField = [[RegisterTextField alloc] initWithFrame:rect];
                textField.borderStyle = UITextBorderStyleNone;
                textField.textAlignment = NSTextAlignmentRight;
                textField.font = [UIFont systemFontOfSize:14.f];
                textField.tag = kRegisterInputViewTag;
                textField.delegate = self;
                textField.textColor = kColor(108, 108, 108, 1);
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:textField];
            }
            RegisterTextField *textFiled = (RegisterTextField *)[cell.contentView viewWithTag:kRegisterInputViewTag];
            NSString *textKey = nil;
            NSString *titleName = nil;
            NSString *imageName = nil;
            switch (indexPath.section) {
                case 0: {
                    //第一分组
                    switch (indexPath.row) {
                        case 0:
                            textKey = key_company;
                            titleName = @"公司名称";
                            imageName = @"register1.png";
                            break;
                        case 1:
                            textKey = key_license;
                            titleName = @"公司营业执照登记号";
                            imageName = @"register2.png";
                            break;
                        case 2:
                            textKey = key_tax;
                            titleName = @"公司税务登记证号";
                            imageName = @"register3.png";
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 1: {
                    //第二分组
                    switch (indexPath.row) {
                        case 0:
                            textKey = key_person;
                            titleName = @"负责人姓名";
                            imageName = @"register4.png";
                            break;
                        case 1:
                            textKey = key_personCardID;
                            titleName = @"负责人身份证号";
                            imageName = @"register5.png";
                            break;
                        case 2:
                            textKey = key_phone;
                            titleName = @"手机";
                            imageName = @"register6.png";
                            break;
                        case 3:
                            textKey = key_email;
                            titleName = @"邮箱";
                            imageName = @"register7.png";
                            break;
                        case 4:
                            textKey = key_city;
                            titleName = @"所在省市";
                            imageName = @"register8.png";
                            break;
                        case 5:
                            textKey = key_address;
                            titleName = @"详细地址";
                            imageName = @"register9.png";
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
            textFiled.key = textKey;
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.imageView.image = kImageName(imageName);
            if ([_registerDict objectForKey:textKey] && ![[_registerDict objectForKey:textKey] isEqualToString:@""]) {
                if (indexPath.section == 1 && indexPath.row == 4) {
                    textFiled.text = [CityHandle getCityNameWithCityID:[_registerDict objectForKey:textKey]];
                }
                else {
                    textFiled.text = [_registerDict objectForKey:textKey];
                }
            }
            else {
                textFiled.text = nil;
            }
            if (indexPath.section == 1 && indexPath.row == 4) {
                //省市信息
                CGRect rect = CGRectMake(kScreenWidth - 180, (cell.frame.size.height - 30) / 2, 150, 30);
                textFiled.frame = rect;
                textFiled.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else {
                CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                textFiled.frame = rect;
                textFiled.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.section == 2) {
            //第三排 图片信息
            cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
            UIImageView *uploadView = [[UIImageView alloc] initWithFrame:rect];
            uploadView.image = kImageName(@"upload.png");
            uploadView.tag = kRegisterImageViewTag;
            [cell.contentView addSubview:uploadView];
            NSString *textKey = nil;
            NSString *titleName = nil;
            NSString *imageName = nil;
            switch (indexPath.row) {
                case 0:
                    textKey = key_cardImage;
                    titleName = @"身份证照片";
                    imageName = @"register5.png";
                    break;
                case 1:
                    textKey = key_licenseImage;
                    titleName = @"营业执照照片";
                    imageName = @"register2.png";
                    break;
                case 2:
                    textKey = key_taxImage;
                    titleName = @"税务登记证照片";
                    imageName = @"register3.png";
                    break;
                default:
                    break;
            }
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.imageView.image = kImageName(imageName);
            cell.detailTextLabel.textColor = kMainColor;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            if ([_registerDict objectForKey:textKey] && ![_registerDict objectForKey:textKey]) {
                uploadView.hidden = NO;
                cell.detailTextLabel.text = nil;
            }
            else {
                uploadView.hidden = YES;
                cell.detailTextLabel.text = @"上传照片";
            }
        }
        else if (indexPath.section == 3) {
            //用户名 密码
            cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            switch (indexPath.row) {
                case 0: {
                    _usernameField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_usernameField];
                }
                    break;
                case 1: {
                    _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_passwordField];
                }
                    break;
                case 2: {
                    _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_confirmField];
                }
                    break;
                default:
                    break;
            }
        }
    }
    else {
        //个人
        switch (indexPath.section) {
            case 0: {
                //第一排 输入信息
                static NSString *firstIdentifier = @"firstIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifier];
                if (cell == nil) {
                    cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIdentifier];
                    CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                    RegisterTextField *textField = [[RegisterTextField alloc] initWithFrame:rect];
                    textField.borderStyle = UITextBorderStyleNone;
                    textField.textAlignment = NSTextAlignmentRight;
                    textField.font = [UIFont systemFontOfSize:14.f];
                    textField.tag = kRegisterInputViewTag;
                    textField.delegate = self;
                    textField.textColor = kColor(108, 108, 108, 1);
                    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    [cell.contentView addSubview:textField];
                }
                RegisterTextField *textFiled = (RegisterTextField *)[cell.contentView viewWithTag:kRegisterInputViewTag];
                NSString *textKey = nil;
                NSString *titleName = nil;
                NSString *imageName = nil;
                //第一分组
                switch (indexPath.row) {
                    case 0:
                        textKey = key_person;
                        titleName = @"负责人姓名";
                        imageName = @"register4.png";
                        break;
                    case 1:
                        textKey = key_personCardID;
                        titleName = @"负责人身份证号";
                        imageName = @"register5.png";
                        break;
                    case 2:
                        textKey = key_phone;
                        titleName = @"手机";
                        imageName = @"register6.png";
                        break;
                    case 3:
                        textKey = key_email;
                        titleName = @"邮箱";
                        imageName = @"register7.png";
                        break;
                    case 4:
                        textKey = key_city;
                        titleName = @"所在省市";
                        imageName = @"register8.png";
                        break;
                    case 5:
                        textKey = key_address;
                        titleName = @"详细地址";
                        imageName = @"register9.png";
                        break;
                    default:
                        break;
                }
                
                textFiled.key = textKey;
                cell.textLabel.text = titleName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                cell.imageView.image = kImageName(imageName);
                if ([_registerDict objectForKey:textKey] && ![[_registerDict objectForKey:textKey] isEqualToString:@""]) {
                    if (indexPath.section == 0 && indexPath.row == 4) {
                        textFiled.text = [CityHandle getCityNameWithCityID:[_registerDict objectForKey:textKey]];
                    }
                    else {
                        textFiled.text = [_registerDict objectForKey:textKey];
                    }
                }
                else {
                    textFiled.text = nil;
                }
                if (indexPath.section == 0 && indexPath.row == 4) {
                    //省市信息
                    CGRect rect = CGRectMake(kScreenWidth - 180, (cell.frame.size.height - 30) / 2, 150, 30);
                    textFiled.frame = rect;
                    textFiled.userInteractionEnabled = NO;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else {
                    CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                    textFiled.frame = rect;
                    textFiled.userInteractionEnabled = YES;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
            }
                break;
            case 1: {
                //第二排 图片信息
                cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
                UIImageView *uploadView = [[UIImageView alloc] initWithFrame:rect];
                uploadView.image = kImageName(@"upload.png");
                uploadView.tag = kRegisterImageViewTag;
                [cell.contentView addSubview:uploadView];
                NSString *textKey = nil;
                NSString *titleName = nil;
                NSString *imageName = nil;
                switch (indexPath.row) {
                    case 0:
                        textKey = key_cardImage;
                        titleName = @"身份证照片";
                        imageName = @"register5.png";
                        break;
                    default:
                        break;
                }
                cell.textLabel.text = titleName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                cell.imageView.image = kImageName(imageName);
                cell.detailTextLabel.textColor = kMainColor;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
                if ([_registerDict objectForKey:textKey] && ![_registerDict objectForKey:textKey]) {
                    uploadView.hidden = NO;
                    cell.detailTextLabel.text = nil;
                }
                else {
                    uploadView.hidden = YES;
                    cell.detailTextLabel.text = @"上传照片";
                }
            }
                break;
            case 2: {
                //用户名 密码
                cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                switch (indexPath.row) {
                    case 0: {
                        _usernameField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                        [cell.contentView addSubview:_usernameField];
                    }
                        break;
                    case 1: {
                        _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                        [cell.contentView addSubview:_passwordField];
                    }
                        break;
                    case 2: {
                        _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                        [cell.contentView addSubview:_confirmField];
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
    if (_agentType == AgentTypeCompany) {
        RegisterCell *cell = (RegisterCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row != 4)) {
            UITextField *textfield = (UITextField *)[cell.contentView viewWithTag:kRegisterInputViewTag];
            if (textfield && textfield.userInteractionEnabled) {
                //输入框
                [textfield becomeFirstResponder];
            }
        }
        else if (indexPath.section == 1 && indexPath.row == 4) {
            //选择城市
            [self pickerScrollIn];
            [_usernameField becomeFirstResponder];
            [_usernameField resignFirstResponder];
        }
        else if (indexPath.section == 2) {
            //图片
            _selectedKey = cell.key;
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kRegisterImageViewTag];
            _imageRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
            [self showImageOption];
        }
    }
    else {
        RegisterCell *cell = (RegisterCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.section == 0 && indexPath.row != 4) {
            UITextField *textfield = (UITextField *)[cell.contentView viewWithTag:kRegisterInputViewTag];
            if (textfield && textfield.userInteractionEnabled) {
                //输入框
                [textfield becomeFirstResponder];
            }
        }
        else if (indexPath.section == 0 && indexPath.row == 4) {
            //选择城市
            [self pickerScrollIn];
            [_usernameField becomeFirstResponder];
            [_usernameField resignFirstResponder];
        }
        else if (indexPath.section == 1) {
            //图片
            _selectedKey = cell.key;
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kRegisterImageViewTag];
            _imageRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
            [self showImageOption];
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

#pragma mark - UITextField

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    RegisterCell *cell = (RegisterCell *)[[textField superview] superview];
    CGRect rect = cell.textLabel.frame;
    [cell.textLabel sizeToFit];
    rect.size.width = cell.textLabel.frame.size.width;
    cell.textLabel.frame = rect;
    CGFloat originX = cell.textLabel.frame.origin.x + cell.textLabel.frame.size.width;
    CGFloat width = kScreenWidth - originX - 20 > 170 ? 170 : kScreenWidth - originX - 20;
    textField.frame = CGRectMake(kScreenWidth - width - 20, 0, width, cell.contentView.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(RegisterTextField *)textField {
    if (textField.text && ![textField.text isEqualToString:@""]) {
        [_registerDict setObject:textField.text forKey:textField.key];
    }
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - 图片
//点击图片行调用
- (void)showImageOption {
    UIActionSheet *sheet = nil;
    NSString *value = [_registerDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"查看照片",@"相册上传",@"拍照上传",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册上传",@"拍照上传",nil];
    }
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *value = [_registerDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        if (buttonIndex == 0) {
            //查看大图
            [self scanBigImage];
            return;
        }
        else if (buttonIndex == 1) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 2) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else {
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

//查看大图
- (void)scanBigImage {
    NSString *urlString = [_registerDict objectForKey:_selectedKey];
    [self showDetailImageWithURL:urlString imageRect:self.imageRect];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}


@end
