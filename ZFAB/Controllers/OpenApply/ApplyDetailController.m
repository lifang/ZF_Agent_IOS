//
//  ApplyDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ApplyDetailController.h"
#import "OpenApplyModel.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "CityHandle.h"
#import "BankModel.h"
#import "BankSelectedController.h"
#import "ChannelSelectedController.h"
#import "MerchantSelectedController.h"
#import "RegularFormat.h"

#define kTextViewTag   111
#define kApplyImageTag 112

@interface ApplyInfoCell : UITableViewCell

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) MaterialType type;

@end

@implementation ApplyInfoCell

@end

@interface ApplyTextField : UITextField

@property (nonatomic, strong) NSString *key;

@end

@implementation ApplyTextField


@end

@interface ApplyDetailController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,BankSelectedDelegate,ChannelSelectedDelegate,ApplyMerchantSelectedDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, assign) OpenApplyType applyType;  //对公 对私

@property (nonatomic, strong) OpenApplyModel *applyData;

@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UILabel *channelLabel;

//用于记录点击的是哪一行
@property (nonatomic, strong) NSString *selectedKey;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property (nonatomic, strong) NSString *merchantID;
@property (nonatomic, strong) NSString *channelID; //支付通道ID
@property (nonatomic, strong) NSString *billID;    //结算日期ID

@property (nonatomic, assign) CGRect imageRect;

@property (nonatomic, assign) BOOL alreadyInitUI;

//无作用 就是用来去掉cell中输入框的输入状态
@property (nonatomic, strong) UITextField *tempField;

@end

@implementation ApplyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通申请";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    _applyType = OpenApplyPublic;
    _infoDict = [[NSMutableDictionary alloc] init];
    _tempField = [[UITextField alloc] init];
    _tempField.hidden = YES;
    [self.view addSubview:_tempField];
//    [self initAndLayoutUI];
    [self beginApply];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    headerView.backgroundColor = kColor(234, 234, 234, 1);
    _tableView.tableHeaderView = headerView;
    NSArray *nameArray = nil;
    switch (_applyData.openType) {
        case OpenTypePrivate: {
            nameArray = [NSArray arrayWithObjects:
                         @"对私",
                         nil];
            _applyType = OpenApplyPrivate;
        }
            break;
        case OpenTypePublic: {
            nameArray = [NSArray arrayWithObjects:
                         @"对公",
                         nil];
            _applyType = OpenApplyPublic;
        }
            break;
        case OpenTypeAll: {
           nameArray = [NSArray arrayWithObjects:
                        @"对公",
                        @"对私",
                        nil];
            _applyType = OpenApplyPublic;
        }
            break;
        default:
            break;
    }
    CGFloat h_space = 20.f;
    CGFloat v_space = 10.f;
    _segmentControl = [[UISegmentedControl alloc] initWithItems:nameArray];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.frame = CGRectMake(h_space, v_space, kScreenWidth - h_space * 2, 30);
    _segmentControl.tintColor = kMainColor;
    [_segmentControl addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:12.f],NSFontAttributeName,
                              nil];
    [_segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [headerView addSubview:_segmentControl];
    
    UIView *terminalView = [self terminalInfoView];
    [headerView addSubview:terminalView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitApply:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    _tableView.tableFooterView = footerView;
}

- (UIView *)terminalInfoView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 100)];
    view.backgroundColor = kColor(244, 243, 243, 1);
    CGFloat borderSpace = 20.f;
    CGFloat topSpace = 10.f;
    CGFloat labelHeight = 20.f;
    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace, kScreenWidth - borderSpace * 2, labelHeight)];
    _brandLabel.backgroundColor = [UIColor clearColor];
    _brandLabel.textColor = kColor(142, 141, 141, 1);
    _brandLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_brandLabel];
    
    _modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace + labelHeight, kScreenWidth - borderSpace * 2, labelHeight)];
    _modelLabel.backgroundColor = [UIColor clearColor];
    _modelLabel.textColor = kColor(142, 141, 141, 1);
    _modelLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_modelLabel];
    
    _terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace + labelHeight * 2, kScreenWidth - borderSpace * 2, labelHeight)];
    _terminalLabel.backgroundColor = [UIColor clearColor];
    _terminalLabel.textColor = kColor(142, 141, 141, 1);
    _terminalLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_terminalLabel];
    
    _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace, topSpace + labelHeight * 3, kScreenWidth - borderSpace * 2, labelHeight)];
    _channelLabel.backgroundColor = [UIColor clearColor];
    _channelLabel.textColor = kColor(142, 141, 141, 1);
    _channelLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_channelLabel];
    
    _brandLabel.text = [NSString stringWithFormat:@"POS品牌   %@",_applyData.brandName];
    _modelLabel.text = [NSString stringWithFormat:@"POS型号   %@",_applyData.modelNumber];
    _terminalLabel.text = [NSString stringWithFormat:@"终  端  号   %@",_applyData.terminalNumber];
    _channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",_applyData.channelName];
    return view;
}

- (void)initAndLayoutUI {
    if (_alreadyInitUI) {
        return;
    }
    _alreadyInitUI = YES;
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
    
    [self initPickerView];
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
                                                                  action:@selector(modifyLocation:)];
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
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _datePicker.backgroundColor = kColor(244, 243, 243, 1);
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.datePicker];
}

- (void)setTextFieldAttr:(ApplyTextField *)textField {
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.tag = kTextViewTag;
    textField.delegate = self;
    textField.textColor = kColor(108, 108, 108, 1);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Request

- (void)beginApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface beginToApplyWithAgentID:delegate.agentID token:delegate.token terminalID:_terminalID openApplyType:_applyType finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseApplyDataWithDictionary:object];
                    [self initAndLayoutUI];
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

- (void)submitApplyInfoWithArray:(NSArray *)params {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitApplyWithToken:delegate.token params:params finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"添加成功";
                    if ([[self.navigationController childViewControllers] count] >= 2) {
                        UIViewController *controller = [self.navigationController.childViewControllers objectAtIndex:1];
                        [self.navigationController popToViewController:controller animated:YES];
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

#pragma mark - Data

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *applyDict = [dict objectForKey:@"result"];
    OpenApplyModel *model = [[OpenApplyModel alloc] initWithParseDictionary:applyDict];
    _applyData = model;
    [self setPrimaryData];
    [_tableView reloadData];
}

//保存获取的内容
- (void)setPrimaryData {
    if (_applyData.personName) {
        [_infoDict setObject:_applyData.personName forKey:key_name];
    }
    if (_applyData.merchantName) {
        [_infoDict setObject:_applyData.merchantName forKey:key_merchantName];
    }
    if (_applyData.birthday) {
        [_infoDict setObject:_applyData.birthday forKey:key_birth];
    }
    if (_applyData.cardID) {
        [_infoDict setObject:_applyData.cardID forKey:key_cardID];
    }
    if (_applyData.phoneNumber) {
        [_infoDict setObject:_applyData.phoneNumber forKey:key_phone];
    }
    if (_applyData.email) {
        [_infoDict setObject:_applyData.email forKey:key_email];
    }
    if (_applyData.cityID) {
        [_infoDict setObject:_applyData.cityID forKey:key_location];
    }
    if (_applyData.bankName) {
        [_infoDict setObject:_applyData.bankName forKey:key_bank];
    }
    if (_applyData.bankNumber) {
        [_infoDict setObject:_applyData.bankNumber forKey:key_bankID];
    }
    if (_applyData.bankAccount) {
        [_infoDict setObject:_applyData.bankAccount forKey:key_bankAccount];
    }
    if (_applyData.taxID) {
        [_infoDict setObject:_applyData.taxID forKey:key_taxID];
    }
    if (_applyData.organID) {
        [_infoDict setObject:_applyData.organID forKey:key_organID];
    }
    if (_applyData.channelOpenName && _applyData.billingName) {
        [_infoDict setObject:[NSString stringWithFormat:@"%@ %@",_applyData.channelOpenName,_applyData.billingName] forKey:key_channel];
    }
    _channelID = _applyData.channelID;
    _billID = _applyData.billingID;
    
    [_infoDict setObject:[NSNumber numberWithInt:_applyData.sex] forKey:key_sex];
    _merchantID = _applyData.merchantID;
    
    /*之前上传过对公对私资料 保存*/
    for (ApplyInfoModel *model in _applyData.applyList) {
        if (model.value && ![model.value isEqualToString:@""]) {
            [_infoDict setObject:model.value forKey:model.targetID];
        }
    }
}

//根据对公对私材料的id找到是否已经提交过材料
- (NSString *)getApplyValueForKey:(NSString *)key {
    NSLog(@"!!%@,key = %@",[_infoDict objectForKey:key],key);
    if ([_infoDict objectForKey:key] && ![[_infoDict objectForKey:key] isEqualToString:@""]) {
        //setPrimaryData方法中已经保存此值， 若修改则返回修改的值
        return [_infoDict objectForKey:key];
    }
    return nil;
}

- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSString class]]) {
        return;
    }
    NSString *urlString = [dict objectForKey:@"result"];
    if (urlString && ![urlString isEqualToString:@""]) {
        [_infoDict setObject:urlString forKey:_selectedKey];
    }
    [_tableView reloadData];
}

#pragma mark - 上传图片

- (void)uploadPictureWithImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
    [NetworkInterface uploadApplyImageWithImage:image terminalID:_terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"上传成功";
                    [self parseImageUploadInfo:object];
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

//点击图片行调用
- (void)showImageOption {
    UIActionSheet *sheet = nil;
    NSString *value = [_infoDict objectForKey:_selectedKey];
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
    NSString *value = [_infoDict objectForKey:_selectedKey];
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

- (void)scanBigImage {
    NSString *urlString = [_infoDict objectForKey:_selectedKey];
    [self showDetailImageWithURL:urlString imageRect:self.imageRect];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 2;
    if ([_applyData.materialList count] > 0) {
        section = 3;
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 9;
            break;
        case 1:
            if (_applyType == OpenTypePublic) {
                row = 6;
            }
            else {
                row = 4;
            }
            break;
        case 2:
            row = [_applyData.materialList count];
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyInfoCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            static NSString *firstIdentifier = @"firstIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifier];
            if (cell == nil) {
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIdentifier];
                CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                ApplyTextField *textField = [[ApplyTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                [cell.contentView addSubview:textField];
            }
            ApplyTextField *textFiled = (ApplyTextField *)[cell.contentView viewWithTag:kTextViewTag];
            NSString *textKey = nil;
            NSString *titleName = nil;
            switch (indexPath.row) {
                case 0:
                    textKey = key_selected;
                    titleName = @"选择已有商户";
                    break;
                case 1:
                    textKey = key_name;
                    titleName = @"姓名";
                    break;
                case 2:
                    textKey = key_merchantName;
                    titleName = @"店铺名称（商户名）";
                    break;
                case 3:
                    textKey = key_sex;
                    titleName = @"性别";
                    break;
                case 4:
                    textKey = key_birth;
                    titleName = @"选择生日";
                    break;
                case 5:
                    textKey = key_cardID;
                    titleName = @"身份证号";
                    break;
                case 6:
                    textKey = key_phone;
                    titleName = @"电话";
                    break;
                case 7:
                    textKey = key_email;
                    titleName = @"邮箱";
                    break;
                case 8:
                    textKey = key_location;
                    titleName = @"选择所在地";
                    break;
                default:
                    break;
            }
            textFiled.key = textKey;
            if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 8) {
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
            if ([_infoDict objectForKey:textKey]) {
                if (indexPath.row == 8) {
                    textFiled.text = [CityHandle getCityNameWithCityID:[_infoDict objectForKey:textKey]];
                }
                else if (indexPath.row == 3) {
                    //性别
                    int sexIndex = [[_infoDict objectForKey:textKey] intValue];
                    NSString *sex = @"";
                    if (sexIndex == 0) {
                        sex = @"女";
                    }
                    else {
                        sex = @"男";
                    }
                    textFiled.text = sex;
                }
                else {
                    textFiled.text = [_infoDict objectForKey:textKey];
                }
            }
            cell.key = textKey;
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        }
            break;
        case 1: {
            static NSString *secondIdentifier = @"secondIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:secondIdentifier];
            if (cell == nil) {
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondIdentifier];
                CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                ApplyTextField *textField = [[ApplyTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                [cell.contentView addSubview:textField];
            }
            ApplyTextField *textFiled = (ApplyTextField *)[cell.contentView viewWithTag:kTextViewTag];
            NSString *textKey = nil;
            NSString *titleName = nil;
            switch (indexPath.row) {
                case 0:
                    textKey = key_bank;
                    titleName = @"结算银行账号名";
                    break;
                case 1:
                    textKey = key_bankID;
                    titleName = @"结算银行代码";
                    break;
                case 2:
                    textKey = key_bankAccount;
                    titleName = @"结算银行卡号";
                    break;
                case 3:
                    if (_applyType == OpenTypePublic) {
                        textKey = key_taxID;
                        titleName = @"税务登记证号";
                    }
                    else {
                        textKey = key_channel;
                        titleName = @"支付通道";
                    }
                    break;
                case 4:
                    if (_applyType == OpenTypePublic) {
                        textKey = key_organID;
                        titleName = @"组织机构号";
                    }
                    break;
                case 5:
                    if (_applyType == OpenTypePublic) {
                        textKey = key_channel;
                        titleName = @"支付通道";
                    }
                    break;
                default:
                    break;
            }
            textFiled.key = textKey;
            if (indexPath.row == 1 ||
                (indexPath.row == 5 && _applyType == OpenTypePublic) ||
                (indexPath.row == 3 && _applyType == OpenTypePrivate)) {
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
            if ([_infoDict objectForKey:textKey]) {
                textFiled.text = [_infoDict objectForKey:textKey];
            }
            cell.key = textKey;
            cell.textLabel.text = titleName;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        }
            break;
        case 2: {
            MaterialModel *model = [_applyData.materialList objectAtIndex:indexPath.row];
            if (model.materialType == MaterialList) {
                //选项 银行
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                CGRect rect = CGRectMake(kScreenWidth - 180, (cell.frame.size.height - 30) / 2, 150, 30);
                ApplyTextField *textField = [[ApplyTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                textField.userInteractionEnabled = NO;
                textField.key = model.materialID;
                NSString *bankCode = [self getApplyValueForKey:textField.key];
                textField.text = bankCode;
                [cell.contentView addSubview:textField];
                cell.key = model.materialID;
                cell.type = MaterialList;
                cell.textLabel.text = model.materialName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else if (model.materialType == MaterialText) {
                //文字
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                CGRect rect = CGRectMake(kScreenWidth - 170, (cell.frame.size.height - 30) / 2, 150, 30);
                ApplyTextField *textField = [[ApplyTextField alloc] init];
                textField.frame = rect;
                [self setTextFieldAttr:textField];
                textField.key = model.materialID;
                textField.text = [self getApplyValueForKey:textField.key];
                [cell.contentView addSubview:textField];
                cell.key = model.materialID;
                cell.type = MaterialText;
                cell.textLabel.text = model.materialName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                return cell;
            }
            else if (model.materialType == MaterialImage) {
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                CGRect rect = CGRectMake(kScreenWidth - 40, (cell.frame.size.height - 20) / 2, 20, 20);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                imageView.image = kImageName(@"upload.png");
                imageView.tag = kApplyImageTag;
                [cell.contentView addSubview:imageView];
                
                cell.key = model.materialID;
                cell.type = MaterialImage;
                cell.textLabel.text = model.materialName;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                [self getApplyValueForKey:cell.key];
                if ([_infoDict objectForKey:cell.key] && ![[_infoDict objectForKey:cell.key] isEqualToString:@""]) {
                    imageView.hidden = NO;
                    cell.detailTextLabel.text = nil;
                }
                else {
                    imageView.hidden = YES;
                    cell.detailTextLabel.text = @"上传照片";
                }
                cell.detailTextLabel.textColor = kMainColor;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
            }
            else {
                //其他 防止报错
                cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                return cell;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_tempField becomeFirstResponder];
//    [_tempField resignFirstResponder];
    [self.editingField resignFirstResponder];
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            //选择商户
            MerchantSelectedController *selectedC = [[MerchantSelectedController alloc] init];
            selectedC.delegate = self;
            selectedC.terminalID = _terminalID;
            [self.navigationController pushViewController:selectedC animated:YES];
        }
        else if (indexPath.section == 0 && indexPath.row == 3) {
            //性别
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            _selectedKey = cell.key;
            [self pickerScrollIn];
        }
        else if (indexPath.section == 0 && indexPath.row == 4) {
            //选择生日
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            _selectedKey = cell.key;
            [self pickerScrollIn];
        }
        else if (indexPath.section == 0 && indexPath.row == 8) {
            //选择所在地
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            _selectedKey = cell.key;
            [self pickerScrollIn];
        }
        else if (indexPath.section == 1 && indexPath.row == 1) {
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            _selectedKey = cell.key;
            BankSelectedController *bankC = [[BankSelectedController alloc] init];
            bankC.delegate = self;
            bankC.terminalID = _terminalID;
            [self.navigationController pushViewController:bankC animated:YES];
        }
        else if ((indexPath.section == 1 && indexPath.row == 5 && _applyType == OpenTypePublic) ||
                 (indexPath.section == 1 && indexPath.row == 3 && _applyType == OpenTypePrivate)) {
            if (!_applyData.terminalChannelID || [_applyData.terminalChannelID isEqualToString:@""]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"获取终端支付通道失败";
            }
            else {
                //选择支付通道
                ChannelSelectedController *channelC = [[ChannelSelectedController alloc] init];
                channelC.delegate = self;
                channelC.channelID = _applyData.terminalChannelID;
                [self.navigationController pushViewController:channelC animated:YES];
            }
        }
        else {
            ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            ApplyTextField *textfield = (ApplyTextField *)[cell.contentView viewWithTag:kTextViewTag];
            if (textfield && textfield.userInteractionEnabled) {
                //输入框
                [textfield becomeFirstResponder];
            }
        }
    }
    else if (indexPath.section == 2) {
        ApplyInfoCell *cell = (ApplyInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
        if (cell.type == MaterialList) {
            _selectedKey = cell.key;
            //结算银行
            BankSelectedController *bankC = [[BankSelectedController alloc] init];
            bankC.delegate = self;
            bankC.terminalID = _terminalID;
            [self.navigationController pushViewController:bankC animated:YES];
        }
        else if (cell.type == MaterialImage) {
            //图片
            _selectedKey = cell.key;
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kApplyImageTag];
            _imageRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
            [self showImageOption];
        }
        else {
            ApplyTextField *textfield = (ApplyTextField *)[cell.contentView viewWithTag:kTextViewTag];
            if (textfield && textfield.userInteractionEnabled) {
                //输入框
                [textfield becomeFirstResponder];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_selectedKey == key_location) {
        return 2;
    }
    else if (_selectedKey == key_sex) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectedKey == key_location) {
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
    else if (_selectedKey == key_sex) {
        return 2;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selectedKey == key_location) {
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
    else if (_selectedKey == key_sex) {
        NSString *title = @"";
        switch (row) {
            case 0:
                title = @"女";
                break;
            case 1:
                title = @"男";
                break;
            default:
                break;
        }
        return title;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_selectedKey == key_location) {
        if (component == 0) {
            //省
            [_pickerView reloadComponent:1];
        }
    }
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    if ([_selectedKey isEqualToString:key_location]) {
        [_pickerView reloadAllComponents];
        NSString *cityID = [_infoDict objectForKey:key_location];
        [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:cityID] inComponent:0 animated:NO];
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:[CityHandle getCityIndexWithCityID:cityID] inComponent:1 animated:NO];
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
    else if ([_selectedKey isEqualToString:key_sex]) {
        [_pickerView reloadAllComponents];
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
    else if ([_selectedKey isEqualToString:key_birth]) {
        NSString *birth = [_infoDict objectForKey:key_birth];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        if (birth) {
            NSDate *birthDate = [format dateFromString:birth];
            if (birthDate) {
                _datePicker.date = birthDate;
            }
        }
        else {
            [self timeChanged:nil];
        }
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _datePicker.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    if (_segmentControl.selectedSegmentIndex == 1) {
        _applyType = OpenApplyPrivate;
    }
    else {
        _applyType = OpenApplyPublic;
    }
    [self beginApply];
    NSLog(@"%d",_applyType);
}

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    if ([_selectedKey isEqualToString:key_location]) {
        NSInteger index = [_pickerView selectedRowInComponent:1];
        NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
        [_infoDict setObject:cityID forKey:key_location];
    }
    else if ([_selectedKey isEqualToString:key_birth]) {
        
    }
    else if ([_selectedKey isEqualToString:key_sex]) {
        NSInteger index = [_pickerView selectedRowInComponent:0];
        [_infoDict setObject:[NSNumber numberWithInteger:index] forKey:key_sex];
    }
    [_tableView reloadData];
}

//datePicker滚动时调用方法
- (IBAction)timeChanged:(id)sender {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:_datePicker.date];
    NSString *str_date = dateString;
    if ([dateString length] >= 10) {
        str_date = [dateString substringToIndex:10];
    }
    [_infoDict setObject:str_date forKey:key_birth];
}

- (IBAction)submitApply:(id)sender {
//    [_tempField becomeFirstResponder];
//    [_tempField resignFirstResponder];
    [self.editingField resignFirstResponder];
    if (_applyData.openType == OpenTypeNone) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"未获取到终端开通类型";
        return;
    }
    if (![_infoDict objectForKey:key_name]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (![_infoDict objectForKey:key_merchantName]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写店铺名称";
        return;
    }
    if (![_infoDict objectForKey:key_sex]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择性别";
        return;
    }
    if (![_infoDict objectForKey:key_birth]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择生日";
        return;
    }
    if (![_infoDict objectForKey:key_cardID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写身份证号";
        return;
    }
    if (![_infoDict objectForKey:key_phone]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写电话";
        return;
    }
    if (![_infoDict objectForKey:key_email]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮箱";
        return;
    }
    if (![_infoDict objectForKey:key_location]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择所在地";
        return;
    }
    if (![_infoDict objectForKey:key_bank]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行名称";
        return;
    }
    if (![_infoDict objectForKey:key_bankID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行代码";
        return;
    }
    if (![_infoDict objectForKey:key_bankAccount]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行账户";
        return;
    }
    if (_applyType == OpenTypePublic) {
        if (![_infoDict objectForKey:key_taxID]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写税务登记证号";
            return;
        }
        if (![_infoDict objectForKey:key_organID]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写组织机构号";
            return;
        }
    }
    if (!_channelID || !_billID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择支付通道";
        return;
    }
    if (![RegularFormat isCorrectIdentificationCard:[_infoDict objectForKey:key_cardID]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"身份证输入不合法";
        return;
    }
    for (MaterialModel *model in _applyData.materialList) {
        if (![_infoDict objectForKey:model.materialID]) {
            NSString *infoString = nil;
            if (model.materialType == MaterialText) {
                infoString = [NSString stringWithFormat:@"请填写%@",model.materialName];
            }
            else if (model.materialType == MaterialList) {
                infoString = [NSString stringWithFormat:@"请选择%@",model.materialName];
            }
            else if (model.materialType == MaterialImage) {
                infoString = [NSString stringWithFormat:@"请上传%@",model.materialName];
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = infoString;
            return;
        }
    }
    NSMutableArray *paramList = [[NSMutableArray alloc] init];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:[_terminalID intValue]] forKey:@"terminalId"];
    [params setObject:[NSNumber numberWithInt:_openStatus] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:[delegate.agentID intValue]] forKey:@"applyCustomerId"];
    [params setObject:[NSNumber numberWithInt:_applyType] forKey:@"publicPrivateStatus"];
    [params setObject:[NSNumber numberWithInt:[_merchantID intValue]] forKey:@"merchantId"];
    [params setObject:[_infoDict objectForKey:key_merchantName] forKey:@"merchantName"];
    [params setObject:[_infoDict objectForKey:key_sex] forKey:@"sex"];
    [params setObject:[_infoDict objectForKey:key_birth] forKey:@"birthday"];
    [params setObject:[_infoDict objectForKey:key_cardID] forKey:@"cardId"];
    [params setObject:[_infoDict objectForKey:key_phone] forKey:@"phone"];
    [params setObject:[_infoDict objectForKey:key_name] forKey:@"name"];
    [params setObject:[_infoDict objectForKey:key_email] forKey:@"email"];
    [params setObject:[NSNumber numberWithInt:[[_infoDict objectForKey:key_location] intValue]] forKey:@"cityId"];
    [params setObject:[NSNumber numberWithInt:[_channelID intValue]] forKey:@"channel"];
    [params setObject:[NSNumber numberWithInt:[_billID intValue]] forKey:@"billingId"];
    [params setObject:[_infoDict objectForKey:key_bankAccount] forKey:@"bankNum"];
    [params setObject:[_infoDict objectForKey:key_bank] forKey:@"bankName"];
    [params setObject:[_infoDict objectForKey:key_bankID] forKey:@"bankCode"];
    [params setObject:[_infoDict objectForKey:key_organID] forKey:@"organizationNo"];
    [params setObject:[_infoDict objectForKey:key_taxID] forKey:@"registeredNo"];
    
    [paramList addObject:params];
    for (MaterialModel *model in _applyData.materialList) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *value = nil;
        value = [_infoDict objectForKey:model.materialID];
        if (model.materialName) {
            [dict setObject:model.materialName forKey:@"key"];
        }
        if (value) {
            [dict setObject:value forKey:@"value"];
        }
        [dict setObject:[NSNumber numberWithInt:model.materialType] forKey:@"types"];
        [dict setObject:[NSNumber numberWithInt:[model.materialID intValue]] forKey:@"targetId"];
        [dict setObject:[NSNumber numberWithInt:[model.levelID intValue]] forKey:@"openingRequirementId"];
        [paramList addObject:dict];
    }
    [self submitApplyInfoWithArray:paramList];
}


#pragma mark - ApplyMerchantSelectedDelegate
//选中商户后 带入商户的一些信息
- (void)getSelectedMerchant:(MerchantDetailModel *)model {
    _merchantID = model.merchantID;
    if (model.merchantPersonName && ![model.merchantPersonName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonName forKey:key_selected];
        [_infoDict setObject:model.merchantPersonName forKey:key_name];
        [_infoDict setObject:model.merchantPersonName forKey:key_bank];
    }
    if (model.merchantName && ![model.merchantName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantName forKey:key_merchantName];
    }
    if (model.merchantPersonID && ![model.merchantPersonID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonID forKey:key_cardID];
    }
    if (model.merchantCityID && ![model.merchantCityID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantCityID forKey:key_location];
    }
    if (model.merchantTaxID && ![model.merchantTaxID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantTaxID forKey:key_taxID];
    }
    if (model.merchantOrganizationID && ![model.merchantOrganizationID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantOrganizationID forKey:key_organID];
    }
    [_tableView reloadData];
}

#pragma mark - BankSelectedDelegate

- (void)getSelectedBank:(BankModel *)model {
    if (model) {
        //此处没有保存对象 因为infoDict的值都为NSString，防止报错
        [_infoDict setObject:model.bankCode forKey:_selectedKey];
        [_tableView reloadData];
    }
}

#pragma mark - ChannelSelectedDelegate

- (void)getChannelList:(ChannelListModel *)model billModel:(BillingModel *)billModel {
    NSString *channelInfo = [NSString stringWithFormat:@"%@ %@",model.channelName,billModel.billName];
    [_infoDict setObject:channelInfo forKey:key_channel];
    _channelID = model.channelID;
    _billID = billModel.billID;
    [_tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pickerScrollOut];
}

- (void)textFieldDidEndEditing:(ApplyTextField *)textField {
    if (textField.text && ![textField.text isEqualToString:@""]) {
        [_infoDict setObject:textField.text forKey:textField.key];
        if ([textField.key isEqualToString:key_name] &&
            (![_infoDict objectForKey:key_bank] || [[_infoDict objectForKey:key_bank] isEqualToString:@""])) {
            [_infoDict setObject:textField.text forKey:key_bank];
            [_tableView reloadData];
        }
    }
}

#pragma mark - 键盘

- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 && self.offset == 0) {
        self.primaryPoint = self.tableView.contentOffset;
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
