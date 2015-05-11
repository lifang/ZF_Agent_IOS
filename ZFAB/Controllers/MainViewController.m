//
//  MainViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MainViewController.h"
#import "NavigationBarAttr.h"
#import "HomeViewController.h"
#import "GoodsViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "GoodListController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)dealloc {
    NSLog(@"!!!!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Controllers

- (void)initControllers {
    self.delegate = self;
    HomeViewController *homeC = [[HomeViewController alloc] init];
    homeC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                     image:kImageName(@"tabbar1.png")
                                             selectedImage:kImageName(@"tabbar1_selected.png")];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeC];
    
//    GoodsViewController *goodC = [[GoodsViewController alloc] init];
//    goodC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"全部商品"
//                                                     image:kImageName(@"tabbar2.png")
//                                             selectedImage:kImageName(@"tabbar2_selected.png")];
//    UINavigationController *goodNav = [[UINavigationController alloc] initWithRootViewController:goodC];
    
    GoodListController *listC = [[GoodListController alloc] init];
    listC.supplyType = SupplyGoodsProcurement;
    listC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"全部商品"
                                                     image:kImageName(@"tabbar2.png")
                                             selectedImage:kImageName(@"tabbar2_selected.png")];
    UINavigationController *goodNav = [[UINavigationController alloc] initWithRootViewController:listC];
    
    MessageViewController *messageC = [[MessageViewController alloc] init];
    messageC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的消息"
                                                        image:kImageName(@"tabbar3.png")
                                                selectedImage:kImageName(@"tabbar3_selected.png")];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageC];
    
    MineViewController *mineC = [[MineViewController alloc] init];
    mineC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                     image:kImageName(@"tabbar4.png")
                                             selectedImage:kImageName(@"tabbar4_selected.png")];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineC];
    
    [NavigationBarAttr setNavigationBarStyle:homeNav];
    [NavigationBarAttr setNavigationBarStyle:goodNav];
    [NavigationBarAttr setNavigationBarStyle:messageNav];
    [NavigationBarAttr setNavigationBarStyle:mineNav];
    
    self.tabBar.tintColor = kMainColor;
    self.tabBar.selectionIndicatorImage = kImageName(@"tabbar_line.png");
    self.viewControllers = [NSArray arrayWithObjects:homeNav,goodNav,messageNav,mineNav, nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    UIViewController *controller = [viewController.childViewControllers firstObject];
    if ([controller isMemberOfClass:[GoodListController class]]) {
        if (![[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthProcurement]] boolValue]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"没有采购权限";
            return NO;
        }
        return YES;
    }
    return YES;
}

@end
