//
//  DefaultBenefitController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "DefaultBenefitController.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface DefaultBenefitController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UILabel *precentLabel; //百分号

@end

@implementation DefaultBenefitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"默认分润比例";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(summbitDefaultBenefit:)];
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
    _inputField.text = [NSString stringWithFormat:@"%.1f",_benefit];
    _inputField.font = [UIFont systemFontOfSize:15.f];
    UIView *oldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _inputField.leftView = oldView;
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _precentLabel = [[UILabel alloc] init];
    _precentLabel.backgroundColor = [UIColor clearColor];
    _precentLabel.font = [UIFont systemFontOfSize:15.f];
    _precentLabel.text = @"%";
    
    [_inputField becomeFirstResponder];
}

#pragma mark - Request

- (void)setDefaultBenefit {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface setDefaultBenefitWithAgentID:delegate.agentID token:delegate.token precent:[_inputField.text floatValue] finished:^(BOOL success, NSData *response) {
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
                    if (_delegate && [_delegate respondsToSelector:@selector(getNewDefaultBenefit:)]) {
                        [_delegate getNewDefaultBenefit:[_inputField.text floatValue]];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)summbitDefaultBenefit:(id)sender {
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
    [self setDefaultBenefit];
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
