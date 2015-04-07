//
//  CreateAgentController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CreateAgentController.h"

@interface CreateAgentController ()

@property (nonatomic, strong) UIButton *benefitBtn;

@end

@implementation CreateAgentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建下级代理商";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    headerView.backgroundColor = kColor(244, 243, 243, 1);
    self.tableView.tableHeaderView = headerView;
    
    CGFloat h_space = 20.f;
    CGFloat v_space = 10.f;
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(h_space, v_space, kScreenWidth - h_space * 2, 20)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont boldSystemFontOfSize:15.f];
    infoLabel.text = @"选择下级代理商类型";
    [headerView addSubview:infoLabel];
    
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"公司",
                          @"个人",
                          nil];
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:nameArray];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.frame = CGRectMake(h_space, 40, kScreenWidth - h_space * 2, 30);
    self.segmentControl.tintColor = kMainColor;
    [self.segmentControl addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
                              nil];
    [self.segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [headerView addSubview:self.segmentControl];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    
    _benefitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _benefitBtn.frame = CGRectMake(20, 10, 18, 18);
    [_benefitBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [_benefitBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [_benefitBtn addTarget:self action:@selector(needBenefit:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_benefitBtn];
    
    UILabel *benefitLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth - 40, 20)];
    benefitLabel.backgroundColor = [UIColor clearColor];
    benefitLabel.font = [UIFont systemFontOfSize:13.f];
    benefitLabel.text = @"开通分润";
    benefitLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(needBenefit:)];
    [benefitLabel addGestureRecognizer:tap];
    [footerView addSubview:benefitLabel];

    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 40, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [submitBtn setTitle:@"创建" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(createAgent:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    [super typeChanged:nil];
}

- (IBAction)createAgent:(id)sender {
    [self dataValidation];
}

- (IBAction)needBenefit:(id)sender {
    _benefitBtn.selected = !_benefitBtn.selected;
    if (_benefitBtn.isSelected) {
        [_benefitBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
    }
    else {
        [_benefitBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    }
}


@end
