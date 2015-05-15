//
//  RegisterSuccessController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/5/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RegisterSuccessController.h"

@interface RegisterSuccessController ()

@end

@implementation RegisterSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请成为合作伙伴";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    UIImageView *successView = [[UIImageView alloc] init];
    successView.translatesAutoresizingMaskIntoConstraints = NO;
    successView.image = kImageName(@"check_right.png");
    [self.view addSubview:successView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:successView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:successView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:successView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:successView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    //
    UILabel *submitLabel = [[UILabel alloc] init];
    submitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    submitLabel.backgroundColor = [UIColor clearColor];
    submitLabel.font = [UIFont boldSystemFontOfSize:18.f];
    submitLabel.textAlignment = NSTextAlignmentCenter;
    submitLabel.text = @"合作伙伴申请提交成功";
    [self.view addSubview:submitLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:successView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:20.f]];
    
    //
    NSString *tipInfo = @"华尔街金融平台欢迎您的加入\n我们的工作人员会在一个工作日内与您联系请保持您的手机畅通";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tipInfo];
    NSDictionary *tipAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
                              [UIColor redColor],NSForegroundColorAttributeName,
                              nil];
    [attrString addAttributes:tipAttr range:NSMakeRange(22, 6)];

    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:14.f];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.attributedText = attrString;
    [self.view addSubview:tipLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:submitLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:60.f]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    backBtn.layer.cornerRadius = 4;
    backBtn.layer.masksToBounds = YES;
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:tipLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backBtn
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:120]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
}

#pragma mark - Action

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
