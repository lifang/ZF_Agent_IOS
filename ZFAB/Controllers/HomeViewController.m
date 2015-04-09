//
//  HomeViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "HomeViewController.h"
#import "PollingView.h"
#import "ModuleView.h"
#import "AppDelegate.h"
#import "GoodsViewController.h"
#import "DealFlowViewController.h"
#import "CSMenuController.h"
#import "OrderManagerController.h"
#import "UserManagerController.h"
#import "StockManagerController.h"
#import "OpenApplyController.h"
#import "TerminalManagerController.h"

@interface HomeViewController ()

@property (nonatomic, strong) PollingView *pollingView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"home_back.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"blue.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(21, 1, 21, 1)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    //导航栏
    [self initNavigationView];
    //轮询图片
    [self initPollingView];
    //模块按钮
    [self initModuleView];
}

//********导航栏*********
- (void)initNavigationView {
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"home_back.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 26)];
    topView.image = kImageName(@"home_logo.png");
    self.navigationItem.titleView = topView;
    
    UIImageView *itemImageView = [[UIImageView alloc] initWithImage:kImageName(@"home_right.png")];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:itemImageView];
    rightItem.tintColor = kColor(165, 139, 106, 1);
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleDone
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

//********轮询图片*******
- (void)initPollingView {
    //图片比例 40:17
    _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 17 / 40)];
    [self.view addSubview:_pollingView];
}

- (void)initModuleView {
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = kDeviceVersion >= 7.0 ? [[UIApplication sharedApplication] statusBarFrame].size.height : 0;
    CGFloat tabbarHeight = self.tabBarController.tabBar.bounds.size.height;
    CGFloat spaceHeight = kScreenHeight - navHeight - statusBarHeight - tabbarHeight - _pollingView.bounds.size.height;
    
    CGFloat moduleHeight = (spaceHeight - kLineHeight * 2) / 3;        //高度
    CGFloat moduleFirstWidth = (kScreenWidth - kLineHeight) / 2;       //第一排宽度
    CGFloat moduleSecondWidth = (kScreenWidth - kLineHeight * 2) / 3;  //后两排宽度
    
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"我要进货",
                          @"订单管理",
                          @"库存管理",
                          @"交易流水",
                          @"终端管理",
                          @"用户管理",
                          @"售后记录",
                          @"申请开通",
                          nil];
    
    CGFloat originY = _pollingView.frame.origin.y + _pollingView.frame.size.height;
    CGRect rect = CGRectMake(0, 0, moduleFirstWidth, moduleHeight);
    for (int i = 0; i < [nameArray count]; i++) {
        if (i < 2) {
            //第一排
            rect.origin.x = (moduleFirstWidth + kLineHeight) * i;
            rect.origin.y = originY;
            rect.size.width = moduleFirstWidth;
        }
        else if (i < 5) {
            //第二排
            rect.origin.x = (moduleSecondWidth + kLineHeight) * (i - 2);
            rect.origin.y = originY + moduleHeight + kLineHeight;
            rect.size.width = moduleSecondWidth;
        }
        else {
            //第三排
            rect.origin.x = (moduleSecondWidth + kLineHeight) * (i - 5);
            rect.origin.y = originY + (moduleHeight + kLineHeight) * 2;
            rect.size.width = moduleSecondWidth;
        }
        ModuleView *moduleView = [ModuleView buttonWithType:UIButtonTypeCustom];
        moduleView.backgroundColor = [UIColor whiteColor];
        moduleView.frame = rect;
        moduleView.tag = i + 1;
        NSString *titleName = [nameArray objectAtIndex:i];
        NSString *imageName = [NSString stringWithFormat:@"module%d.png",i + 1];
        [moduleView setTitleName:titleName imageName:imageName];
        [moduleView addTarget:self action:@selector(moduleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:moduleView];
    }
    //划线
    CGFloat borderSpace = 10.f;
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(moduleFirstWidth, _pollingView.frame.origin.y + _pollingView.frame.size.height + borderSpace, kLineHeight, moduleHeight - borderSpace)];
    firstLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(borderSpace, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight, kScreenWidth - borderSpace * 2 , kLineHeight)];
    secondLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:secondLine];
    
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(borderSpace, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight * 2 + kLineHeight, kScreenWidth - borderSpace * 2 , kLineHeight)];
    thirdLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:thirdLine];
    
    UIView *forthLine = [[UIView alloc] initWithFrame:CGRectMake(moduleSecondWidth, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight, kLineHeight , moduleHeight * 2 + kLineHeight - borderSpace)];
    forthLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:forthLine];
    
    UIView *fifthLine = [[UIView alloc] initWithFrame:CGRectMake(moduleSecondWidth * 2 + kLineHeight, _pollingView.frame.origin.y + _pollingView.frame.size.height + moduleHeight, kLineHeight , moduleHeight * 2 + kLineHeight - borderSpace)];
    fifthLine.backgroundColor = kColor(226, 225, 225, 1);
    [self.view addSubview:fifthLine];
}


#pragma mark - Action

- (IBAction)moduleSelected:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    ModuleView *moduleView = (ModuleView *)sender;
    switch (moduleView.tag) {
        case ModuleBuy: {
            //我要进货
            GoodsViewController *goodC = [[GoodsViewController alloc] init];
            goodC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodC animated:YES];
        }
            break;
        case ModuleOrderManager: {
            //订单管理
            OrderManagerController *orderC = [[OrderManagerController alloc] init];
            orderC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderC animated:YES];
        }
            break;
        case ModuleStockManager: {
            //库存管理
            StockManagerController *stockC = [[StockManagerController alloc] init];
            stockC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stockC animated:YES];
        }
            break;
        case ModuletDealFlow: {
            //交易流水
            DealFlowViewController *flowC = [[DealFlowViewController alloc] init];
            flowC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:flowC animated:YES];
        }
            break;
        case ModuleTerminalManager: {
            //终端管理
            TerminalManagerController *terminalC = [[TerminalManagerController alloc] init];
            terminalC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:terminalC animated:YES];
        }
            break;
        case ModuleUserManager: {
            //用户管理
            UserManagerController *userC = [[UserManagerController alloc] init];
            userC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userC animated:YES];
        }
            break;
        case ModuleAfterSale: {
            //售后记录
            CSMenuController *csC = [[CSMenuController alloc] init];
            csC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:csC animated:YES];
        }
            break;
        case ModuleOpenApply: {
            //申请开通
            OpenApplyController *applyC = [[OpenApplyController alloc] init];
            applyC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
