//
//  CooperationViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/5/12.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CooperationViewController.h"
#import "CityHandle.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "RegisterSuccessController.h"
#import "RegisterProtocolController.h"

@interface CooperationViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) UITextField *validateField;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, strong) UIButton *personButton;
@property (nonatomic, strong) UIButton *companyButton;

@property (nonatomic, strong) UIButton *agreeButton;

@property (nonatomic, strong) UILabel *cityLabel;

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property (nonatomic, strong) NSString *validate;   //验证码

@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) NSString *provinceID;

@property (nonatomic, strong) NSString *primaryMobile; //接收验证码的手机号 防止用户修改掉

@end

@implementation CooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请成为合作伙伴";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = kColor(254, 254, 254, 1);
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    CGFloat topSpace = 20.f;
    CGFloat inSideSpace = 10.f;
    CGFloat middleSpace = 15.f;
    CGFloat textHeight = 40.f;
    CGFloat imageSize = 24.f;
    CGFloat btnWidth = 70.f;
    CGFloat originY = topSpace;
    //姓名
    UIView *nameBackView = [self createTextBackView];
    nameBackView.frame = CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, textHeight);
    [_scrollView addSubview:nameBackView];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(inSideSpace, 0, nameBackView.bounds.size.width - inSideSpace * 2, textHeight)];
    [self setTextFieldAttr:_nameField withPlaceholder:@"填写您的姓名"];
    [nameBackView addSubview:_nameField];
    
    //手机号
    originY += middleSpace + textHeight;
    UIView *phoneBackView = [self createTextBackView];
    phoneBackView.frame = CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, textHeight);
    [_scrollView addSubview:phoneBackView];
    
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(inSideSpace, 0, nameBackView.bounds.size.width - inSideSpace * 2 - btnWidth, textHeight)];
    [self setTextFieldAttr:_phoneField withPlaceholder:@"填写您的手机号"];
    [phoneBackView addSubview:_phoneField];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(phoneBackView.bounds.size.width - btnWidth, 0, btnWidth, textHeight);
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _sendButton.layer.cornerRadius = 4.f;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_sendButton setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    [_sendButton setTitleColor:kColor(160, 199, 237, 1) forState:UIControlStateDisabled];
    [_sendButton addTarget:self action:@selector(sendInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [phoneBackView addSubview:_sendButton];
    
    //提示
    originY += textHeight;
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, middleSpace)];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.font = [UIFont systemFontOfSize:12.f];
    _tipLabel.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_tipLabel];
    _tipLabel.hidden = YES;
    
    //验证码
    originY += middleSpace;
    UIView *validateBackView = [self createTextBackView];
    validateBackView.frame = CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, textHeight);
    [_scrollView addSubview:validateBackView];
    _validateField = [[UITextField alloc] initWithFrame:CGRectMake(inSideSpace, 0, validateBackView.bounds.size.width - inSideSpace * 2 - imageSize - 10, textHeight)];
    [self setTextFieldAttr:_validateField withPlaceholder:@"输入手机验证码"];
    [validateBackView addSubview:_validateField];
    
    //验证图标
    _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(validateBackView.bounds.size.width - imageSize - 10, (textHeight - imageSize) / 2, imageSize, imageSize)];
    [validateBackView addSubview:_checkImageView];
    _checkImageView.hidden = YES;
    
    //合作伙伴类型
    originY += textHeight + middleSpace;
    UIView *cooperationView = [self createSelectBackView];
    cooperationView.frame = CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, textHeight);
    [_scrollView addSubview:cooperationView];
    UILabel *co_operationLabel = [[UILabel alloc] initWithFrame:CGRectMake(inSideSpace, 0, 90, textHeight)];
    co_operationLabel.backgroundColor = [UIColor clearColor];
    co_operationLabel.font = [UIFont systemFontOfSize:14.f];
    co_operationLabel.textColor = kColor(172, 172, 172, 1);
    co_operationLabel.text = @"合作伙伴类型";
    [cooperationView addSubview:co_operationLabel];
    CGFloat labelWidth = 60.f;
    CGFloat btnSize = 18.f;
    UILabel *companyLabel = [self createLabelWithTitle:@"我是公司"];
    companyLabel.userInteractionEnabled = YES;
    companyLabel.frame = CGRectMake(cooperationView.bounds.size.width - inSideSpace / 2 - labelWidth, 0, labelWidth, textHeight);
    UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCompany:)];
    [companyLabel addGestureRecognizer:companyTap];
    [cooperationView addSubview:companyLabel];
    _companyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _companyButton.frame = CGRectMake(cooperationView.bounds.size.width - inSideSpace / 2 - labelWidth - btnSize - 2 , (textHeight - btnSize ) / 2, btnSize, btnSize);
    [_companyButton setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_companyButton setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_companyButton addTarget:self action:@selector(selectCompany:) forControlEvents:UIControlEventTouchUpInside];
    [cooperationView addSubview:_companyButton];
    
    UILabel *personLabel = [self createLabelWithTitle:@"我是个人"];
    personLabel.userInteractionEnabled = YES;
    personLabel.frame = CGRectMake(cooperationView.bounds.size.width - inSideSpace - labelWidth * 2 - btnSize, 0, labelWidth, textHeight);
    UITapGestureRecognizer *personTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPerson:)];
    [personLabel addGestureRecognizer:personTap];
    [cooperationView addSubview:personLabel];
    
    _personButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _personButton.frame = CGRectMake(cooperationView.bounds.size.width - (inSideSpace / 2 + labelWidth + btnSize + 2) * 2 , (textHeight - btnSize ) / 2, btnSize, btnSize);
    [_personButton setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_personButton setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_personButton addTarget:self action:@selector(selectPerson:) forControlEvents:UIControlEventTouchUpInside];
    _personButton.selected = YES;
    [self setSelectStatusForButton:_personButton];
    [cooperationView addSubview:_personButton];
    
    //城市
    originY += middleSpace + textHeight;
    UIView *cityView = [self createSelectBackView];
    cityView.frame = CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, textHeight);
    [_scrollView addSubview:cityView];
    UILabel *cityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(inSideSpace, 0, 80, textHeight)];
    cityTitleLabel.backgroundColor = [UIColor clearColor];
    cityTitleLabel.font = [UIFont systemFontOfSize:14.f];
    cityTitleLabel.textColor = kColor(172, 172, 172, 1);
    cityTitleLabel.text = @"所在城市";
    [cityView addSubview:cityTitleLabel];
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(cityView.bounds.size.width - inSideSpace - 10, 18, 10, 5)];
    arrowImage.image = kImageName(@"arrow.png");
    [cityView addSubview:arrowImage];
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(cityView.bounds.size.width - inSideSpace - 180, 0, 160, textHeight)];
    _cityLabel.textAlignment = NSTextAlignmentRight;
    _cityLabel.backgroundColor = [UIColor clearColor];
    _cityLabel.font = [UIFont systemFontOfSize:14.f];
    _cityLabel.textColor = kColor(172, 172, 172, 1);
    [cityView addSubview:_cityLabel];
    UITapGestureRecognizer *cityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCity:)];
    [cityView addGestureRecognizer:cityTap];
    
    //同意
    originY += middleSpace * 2 + textHeight;
    _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeButton.frame = CGRectMake(leftSpace, originY, 18, 18);
    [_agreeButton setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_agreeButton setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_agreeButton addTarget:self action:@selector(agreeProtocol:) forControlEvents:UIControlEventTouchUpInside];
    _agreeButton.selected = YES;
    [self setSelectStatusForButton:_agreeButton];
    [_scrollView addSubview:_agreeButton];
    
    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, originY, kScreenWidth - 40 - rightSpace, 20)];
    protocolLabel.backgroundColor = [UIColor clearColor];
    protocolLabel.font = [UIFont systemFontOfSize:14.f];
    protocolLabel.textColor = kMainColor;
    protocolLabel.userInteractionEnabled = YES;
    NSString *protocolInfo = @"同意《华尔街金融平台用户使用协议》";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:protocolInfo];
    NSDictionary *rentAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
                              kMainColor,NSForegroundColorAttributeName,
                              [NSNumber numberWithInt:1],NSUnderlineStyleAttributeName,
                              nil];
    [attrString addAttributes:rentAttr range:NSMakeRange(2, [protocolInfo length] - 2)];
    protocolLabel.attributedText = attrString;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanProtocol:)];
    [protocolLabel addGestureRecognizer:tap];
    [_scrollView addSubview:protocolLabel];
    
    //电话
    originY += middleSpace + 20;
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, 24)];
    phoneLabel.backgroundColor = kColor(252, 232, 231, 1);
    phoneLabel.font = [UIFont systemFontOfSize:13.f];
    phoneLabel.layer.borderWidth = 1.f;
    phoneLabel.layer.borderColor = kColor(248, 89, 86, 1).CGColor;
    phoneLabel.textColor = kColor(244, 140, 135, 1);
    phoneLabel.userInteractionEnabled = YES;
    NSString *contactInfo = @"若申请时遇到问题，请拨打电话400-009-0876";
    NSMutableAttributedString *contactAttrString = [[NSMutableAttributedString alloc] initWithString:contactInfo];
    NSDictionary *contactAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:13.f],NSFontAttributeName,
                              kColor(244, 140, 135, 1),NSForegroundColorAttributeName,
                              [NSNumber numberWithInt:1],NSUnderlineStyleAttributeName,
                              nil];
    [contactAttrString addAttributes:contactAttr range:NSMakeRange(14, [contactInfo length] - 14)];
    phoneLabel.attributedText = contactAttrString;
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contact:)];
    [phoneLabel addGestureRecognizer:phoneTap];
    [_scrollView addSubview:phoneLabel];
    
    originY += 24 + middleSpace * 2;
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, 40);
    _submitButton.layer.cornerRadius = 4;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _submitButton.userInteractionEnabled = NO;
    [_submitButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"lightblue.png"] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_submitButton];
    
    originY += 40;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, originY);
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

- (UIView *)createTextBackView {
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    CGFloat height = 40.f;
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, 0, kScreenWidth - leftSpace - rightSpace, height)];
    textBackView.backgroundColor = kColor(236, 236, 235, 1);
    textBackView.layer.cornerRadius = 4;
    textBackView.layer.masksToBounds = YES;
    return textBackView;
}

- (UIView *)createSelectBackView {
    UIView *selectBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    selectBackView.backgroundColor = [UIColor clearColor];
    selectBackView.layer.borderWidth = 1.f;
    selectBackView.layer.borderColor = kColor(195, 194, 194, 1).CGColor;
    selectBackView.layer.cornerRadius = 4;
    selectBackView.layer.masksToBounds = YES;
    return selectBackView;
}

- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = kColor(172, 172, 172, 1);
    label.text = title;
    return label;
}

- (void)setTextFieldAttr:(UITextField *)textField withPlaceholder:(NSString *)placeholder {
    textField.font = [UIFont systemFontOfSize:16.f];
    NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                              nil];
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeholderString addAttributes:textDict range:NSMakeRange(0, [placeholderString length])];
    textField.attributedPlaceholder = placeholderString;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
}

- (void)setSelectStatusForButton:(UIButton *)button {
    if (button.isSelected) {
        [button setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
    }
    else {
        [button setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    }
}

#pragma mark - Data

//倒计时
- (void)countDownStart {
    __block int timeout = 10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _sendButton.userInteractionEnabled = YES;
                [_sendButton setTitleColor:kMainColor forState:UIControlStateNormal];
                _tipLabel.hidden = YES;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendButton.userInteractionEnabled = NO;
                _tipLabel.hidden = NO;
                NSInteger length = [[NSString stringWithFormat:@"%ds",timeout] length];
                NSString *title = [NSString stringWithFormat:@"验证码已发送 %ds可后重新获取",timeout];
                [_sendButton setTitleColor:kColor(160, 199, 237, 1) forState:UIControlStateNormal];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
                NSDictionary *rentAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:12.f],NSFontAttributeName,
                                          [UIColor redColor],NSForegroundColorAttributeName,
                                          nil];
                [attrString addAttributes:rentAttr range:NSMakeRange(7, length)];
                _tipLabel.attributedText = attrString;

                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)dataValidation {
    if (_nameField.text && ![_nameField.text isEqualToString:@""] &&
        _phoneField.text && ![_phoneField.text isEqualToString:@""] &&
        _validateField.text && ![_validateField.text isEqualToString:@""] &&
        _cityLabel.text && ![_cityLabel.text isEqualToString:@""] &&
        _agreeButton.isSelected) {
        _submitButton.userInteractionEnabled = YES;
        [_submitButton setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    }
    else {
        _submitButton.userInteractionEnabled = NO;
        [_submitButton setBackgroundImage:kImageName(@"lightblue.png") forState:UIControlStateNormal];
    }
}

#pragma mark - Request

- (void)getMobileNumber {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface getRegisterValidateWithMobileNumber:_phoneField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    if ([[object objectForKey:@"result"] isKindOfClass:[NSString class]]) {
                        _validate = [object objectForKey:@"result"];
                    }
                    _primaryMobile = _phoneField.text;
                    _checkImageView.hidden = YES;
                    [self countDownStart];
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

- (void)submitForRegister {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    NSString *type = @"个人";
    if (_companyButton.isSelected) {
        type = @"公司";
    }
    NSString *cityID = [NSString stringWithFormat:@"%@_%@",_provinceID,_cityID];
    [NetworkInterface registerCooperationWithUsername:_nameField.text phoneNumber:_phoneField.text agentType:type city:cityID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    RegisterSuccessController *registerC = [[RegisterSuccessController alloc] init];
                    [self.navigationController pushViewController:registerC animated:YES];
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Action

- (void)tapCity:(UITapGestureRecognizer *)tap {
    [_nameField becomeFirstResponder];
    [_nameField resignFirstResponder];
    [self pickerScrollIn];
}

- (void)contact:(UITapGestureRecognizer *)tap {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"4000090876"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
}

- (IBAction)sendInfo:(id)sender {
    [_phoneField becomeFirstResponder];
    [_phoneField resignFirstResponder];
    if (![RegularFormat isMobileNumber:_phoneField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的手机号";
        return;
    }
    [self getMobileNumber];
}

- (IBAction)selectPerson:(id)sender {
    if (!_personButton.isSelected) {
        _personButton.selected = YES;
        _companyButton.selected = NO;
        [self setSelectStatusForButton:_personButton];
        [self setSelectStatusForButton:_companyButton];
    }
}

- (IBAction)selectCompany:(id)sender {
    if (!_companyButton.isSelected) {
        _personButton.selected = NO;
        _companyButton.selected = YES;
        [self setSelectStatusForButton:_personButton];
        [self setSelectStatusForButton:_companyButton];
    }
}

- (IBAction)agreeProtocol:(id)sender {
    _agreeButton.selected = !_agreeButton.selected;
    [self setSelectStatusForButton:_agreeButton];
    [self dataValidation];
}

- (IBAction)scanProtocol:(id)sender {
    RegisterProtocolController *protocolC = [[RegisterProtocolController alloc] init];
    [self.navigationController pushViewController:protocolC animated:YES];
}

- (IBAction)submit:(id)sender {
    [_nameField becomeFirstResponder];
    [_nameField resignFirstResponder];
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写手机号";
        return;
    }
    if (!_validateField.text || [_validateField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写验证码";
        return;
    }
    if (!_cityLabel.text || [_cityLabel.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
    }
    if (!_agreeButton.isSelected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请同意使用协议";
        return;
    }
    if (!_validate ||[_validate isEqualToString:@""] || ![_validate isEqualToString:_validateField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"验证码不正确";
        return;
    }
    if (!_primaryMobile || [_primaryMobile isEqualToString:@""] || ![_primaryMobile isEqualToString:_phoneField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"手机号和验证码不对应";
        return;
    }
    [self submitForRegister];
}

- (IBAction)selectedCity:(id)sender {
    [self pickerScrollOut];
    NSInteger provinceIndex = [_pickerView selectedRowInComponent:0];
    NSInteger cityIndex = [_pickerView selectedRowInComponent:1];
    NSDictionary *selectCity = [_cityArray objectAtIndex:cityIndex];
    NSDictionary *selectProvince = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
    _provinceID = [NSString stringWithFormat:@"%@",[selectProvince objectForKey:@"id"]];
    _cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:cityIndex] objectForKey:@"id"]];
    _cityLabel.text = [NSString stringWithFormat:@"%@ %@",[selectProvince objectForKey:@"name"],[selectCity objectForKey:@"name"]];
    [self dataValidation];
}

#pragma mark - UITextFielDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self pickerScrollOut];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _validateField) {
        _checkImageView.hidden = NO;
        if ([textField.text isEqualToString:_validate]) {
            _checkImageView.image = kImageName(@"check_right.png");
        }
        else {
            _checkImageView.image = kImageName(@"check_wrong.png");
        }
    }
    [self dataValidation];
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

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4000090876"]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}


@end
