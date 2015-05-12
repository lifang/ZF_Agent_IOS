//
//  CooperationViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/5/12.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CooperationViewController.h"

@interface CooperationViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) UITextField *validateField;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIImageView *checkImageView;

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
    [_sendButton setTitleColor:kColor(160, 199, 237, 1) forState:UIControlStateDisabled];
    [_sendButton addTarget:self action:@selector(sendInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [phoneBackView addSubview:_sendButton];
    
    //提示
    originY += textHeight;
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, middleSpace)];
    _tipLabel.backgroundColor = [UIColor clearColor];
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
    return nil;
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
    textField.backgroundColor = [UIColor greenColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
}

#pragma mark - Action

- (IBAction)sendInfo:(id)sender {
    
}

#pragma mark - UITextFielDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
