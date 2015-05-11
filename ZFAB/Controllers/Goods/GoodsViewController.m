//
//  GoodsViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodListController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface GoodsViewController ()

@end

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.navigationItem.title) {
        self.navigationItem.title = @"全部商品";
    }
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    CGFloat leftSpace = 40.f;
    CGFloat btnHeight = 80.f;
    CGFloat middleSpace = 20.f;
    
//    UIButton *wholesaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    wholesaleBtn.translatesAutoresizingMaskIntoConstraints = NO;
//    wholesaleBtn.layer.cornerRadius = 8;
//    wholesaleBtn.layer.masksToBounds = YES;
//    wholesaleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
//    [wholesaleBtn setTitle:@"去批购" forState:UIControlStateNormal];
//    [wholesaleBtn setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
//    [wholesaleBtn addTarget:self action:@selector(goToWholesale:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wholesaleBtn];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:wholesaleBtn
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:leftSpace]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:wholesaleBtn
//                                                          attribute:NSLayoutAttributeRight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1.0
//                                                           constant:-leftSpace]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:wholesaleBtn
//                                                          attribute:NSLayoutAttributeCenterY
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeCenterY
//                                                         multiplier:1.0
//                                                           constant:-(btnHeight + middleSpace) / 2 - 49]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:wholesaleBtn
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:nil
//                                                          attribute:NSLayoutAttributeHeight
//                                                         multiplier:0.0
//                                                           constant:btnHeight]];
    
    UIButton *procurementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procurementBtn.translatesAutoresizingMaskIntoConstraints = NO;
    procurementBtn.layer.cornerRadius = 8;
    procurementBtn.layer.masksToBounds = YES;
    procurementBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [procurementBtn setTitle:@"去代购" forState:UIControlStateNormal];
    [procurementBtn setBackgroundImage:[UIImage imageNamed:@"light_blue.png"] forState:UIControlStateNormal];
    [procurementBtn addTarget:self action:@selector(goToProcurement:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:procurementBtn];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:procurementBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:procurementBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:procurementBtn
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.f]]; //(btnHeight + middleSpace) / 2 - 49
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:procurementBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:btnHeight]];
    
}

#pragma mark - Action
//批购
- (IBAction)goToWholesale:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthWholesale]] boolValue]) {
        GoodListController *listC = [[GoodListController alloc] init];
        listC.supplyType = SupplyGoodsWholesale;
        listC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listC animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有批购权限";
    }
}

//代购
- (IBAction)goToProcurement:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthProcurement]] boolValue]) {
        GoodListController *listC = [[GoodListController alloc] init];
        listC.supplyType = SupplyGoodsProcurement;
        listC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listC animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有采购权限";
    }
}

@end
