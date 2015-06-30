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

#pragma mark - Request

- (void)uploadPictureWithImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
    [NetworkInterface uploadRegisterImageWithImage:image finished:^(BOOL success, NSData *response) {
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

- (void)submitForCreate {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在提交...";
    [NetworkInterface registerWithUsername:self.usernameField.text
                                  password:self.passwordField.text
                          isAlreadyEncrypt:NO
                                 agentType:self.agentType
                               companyName:[self.registerDict objectForKey:key_company]
                                 licenseID:[self.registerDict objectForKey:key_license]
                                     taxID:[self.registerDict objectForKey:key_tax]
                           legalPersonName:[self.registerDict objectForKey:key_person]
                             legalPersonID:[self.registerDict objectForKey:key_personCardID]
                              mobileNumber:[self.registerDict objectForKey:key_phone]
                                     email:[self.registerDict objectForKey:key_email]
                                    cityID:[self.registerDict objectForKey:key_city]
                             detailAddress:[self.registerDict objectForKey:key_address]
                             cardImagePath:[self.registerDict objectForKey:key_cardImage]
                          licenseImagePath:[self.registerDict objectForKey:key_licenseImage]
                              taxImagePath:[self.registerDict objectForKey:key_taxImage]
                                  finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"success = %@",[object objectForKey:@"message"]);
                    hud.labelText = @"注册成功";
                    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - Data

- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSString class]]) {
        return;
    }
    NSString *urlString = [dict objectForKey:@"result"];
    if (urlString && ![urlString isEqualToString:@""]) {
        [self.registerDict setObject:urlString forKey:self.selectedKey];
    }
    [self.tableView reloadData];
}

@end
