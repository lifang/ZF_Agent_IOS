//
//  RegisterViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetworkInterface.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请成为代理商";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI 

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    self.tableView.tableHeaderView = headerView;
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"公司",
                          @"个人",
                          nil];
    CGFloat h_space = 20.f;
    CGFloat v_space = 10.f;
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:nameArray];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.frame = CGRectMake(h_space, v_space, kScreenWidth - h_space * 2, 30);
    self.segmentControl.tintColor = kMainColor;
    [self.segmentControl addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
                              nil];
    [self.segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [headerView addSubview:self.segmentControl];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    [super typeChanged:nil];
}

- (IBAction)signUp:(id)sender {
    [self dataValidation];
}

@end
