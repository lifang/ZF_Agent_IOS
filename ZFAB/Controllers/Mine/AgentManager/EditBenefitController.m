//
//  EditBenefitController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "EditBenefitController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RegularFormat.h"
#import "BenefitListController.h"

@interface EditBenefitController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UILabel *precentLabel; //百分号

@end

@implementation EditBenefitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置分润";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(summbitBenefit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(summbitBenefit:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    _tableView.tableFooterView = footerView;
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
    
    _inputField = [[UITextField alloc] init];
    _inputField.borderStyle = UITextBorderStyleNone;
    _inputField.backgroundColor = [UIColor clearColor];
    _inputField.delegate = self;
    _inputField.placeholder = @"1";
    _inputField.font = [UIFont systemFontOfSize:15.f];
    UIView *oldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _inputField.leftView = oldView;
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputField.text = [NSString stringWithFormat:@"%.1f",_tradeModel.percent];
    
    _precentLabel = [[UILabel alloc] init];
    _precentLabel.backgroundColor = [UIColor clearColor];
    _precentLabel.font = [UIFont systemFontOfSize:15.f];
    _precentLabel.text = @"%";
    
    [_inputField becomeFirstResponder];
}

#pragma mark - Request

- (void)modityBenefit {
    NSString *benefitString = [NSString stringWithFormat:@"%.1f_%@",[_inputField.text floatValue],_tradeModel.ID];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitBenefitWithAgentID:delegate.agentID token:delegate.token subAgentID:_subAgentID channelID:_channelID profit:benefitString type:_type finished:^(BOOL success, NSData *response) {
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
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshBenefitListNotification object:nil];
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

#pragma mark - Action

- (IBAction)summbitBenefit:(id)sender {
    if (!_inputField.text || [_inputField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入分润比例";
        return;
    }
    if (![RegularFormat isFloat:_inputField.text] ||
        [_inputField.text floatValue] < 0 ||
        [_inputField.text floatValue] > 100) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的分润比例";
        return;
    }
    _tradeModel.percent = [_inputField.text floatValue];
    if (_type == BenefitPercentCreate) {
        //新增分润
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_type == BenefitPercentModity) {
        //修改
        [self modityBenefit];
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _inputField.frame = CGRectMake(0, 0, kScreenWidth - 40, cell.contentView.bounds.size.height);
    [cell.contentView addSubview:_inputField];
    _precentLabel.frame = CGRectMake(kScreenWidth - 40, 0, 40, cell.contentView.bounds.size.height);
    [cell.contentView addSubview:_precentLabel];
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
