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
#import "NetworkInterface.h"
#import "HomeImageModel.h"
#import "ChannelWebsiteController.h"
#import "GoodListController.h"
#import "GoodDetailController.h"

@interface HomeViewController ()

@property (nonatomic, strong) PollingView *pollingView;

@property (nonatomic, strong) NSMutableArray *pictureItem;

@property (nonatomic, strong) NSString *updateURL;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    _pictureItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self loadHomeImageList];
    [self checkVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"home_back.png")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

#pragma mark - Request

- (void)loadHomeImageList {
    [NetworkInterface getHomeImageListFinished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [self parseImageDataWithDict:object];
                }
            }
        }
    }];
}

#pragma mark - Data

- (void)parseImageDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id imageList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    [_pictureItem removeAllObjects];
    for (int i = 0; i < [imageList count]; i++) {
        id imageDict = [imageList objectAtIndex:i];
        if ([imageDict isKindOfClass:[NSDictionary class]]) {
            HomeImageModel *model = [[HomeImageModel alloc] initWithParseDictionary:imageDict];
            [_pictureItem addObject:model];
        }
    }
    NSMutableArray *urlList = [[NSMutableArray alloc] init];
    for (HomeImageModel *model in _pictureItem) {
        [urlList addObject:model.pictureURL];
    }
    [_pollingView downloadImageWithURLs:urlList target:self action:@selector(tapPicture:) scaleImage:YES];
}


#pragma mark - Action

- (IBAction)moduleSelected:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    ModuleView *moduleView = (ModuleView *)sender;
    switch (moduleView.tag) {
        case ModuleBuy: {
            //我要进货
//            GoodsViewController *goodC = [[GoodsViewController alloc] init];
//            goodC.hidesBottomBarWhenPushed = YES;
//            goodC.navigationItem.title = @"进货";
//            [self.navigationController pushViewController:goodC animated:YES];
            
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthProcurement]] boolValue]) {
                GoodListController *listC = [[GoodListController alloc] init];
                listC.hidesBottomBarWhenPushed = YES;
                listC.supplyType = SupplyGoodsProcurement;
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
            break;
        case ModuleOrderManager: {
            //订单管理
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthOrder]] boolValue]) {
                OrderManagerController *orderC = [[OrderManagerController alloc] init];
                orderC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:orderC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"没有订单管理权限";
            }
        }
            break;
        case ModuleStockManager: {
            //库存管理
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthStock]] boolValue]) {
                StockManagerController *stockC = [[StockManagerController alloc] init];
                stockC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:stockC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"没有库存权限";
            }
        }
            break;
        case ModuletDealFlow: {
            //交易流水
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthT_B]] boolValue]) {
                DealFlowViewController *flowC = [[DealFlowViewController alloc] init];
                flowC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:flowC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"没有交易流水权限";
            }
        }
            break;
        case ModuleTerminalManager: {
            //终端管理
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthTM_CS]] boolValue]) {
                TerminalManagerController *terminalC = [[TerminalManagerController alloc] init];
                terminalC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:terminalC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"没有终端管理权限";
            }
        }
            break;
        case ModuleUserManager: {
            //用户管理
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthUM]] boolValue]) {
                UserManagerController *userC = [[UserManagerController alloc] init];
                userC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"没有用户管理权限";
            }
        }
            break;
        case ModuleAfterSale: {
            //售后记录
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthTM_CS]] boolValue]) {
                CSMenuController *csC = [[CSMenuController alloc] init];
                csC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:csC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"没有售后记录权限";
            }
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

- (void)tapPicture:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)[tap view];
    NSInteger index = imageView.tag - 1;
    if (index >= 0 && index < [_pictureItem count]) {
        HomeImageModel *imageModel = [_pictureItem objectAtIndex:index];
        if (imageModel.goodID) {
            GoodDetailController *detailC = [[GoodDetailController alloc] init];
            detailC.goodID = imageModel.goodID;
            detailC.supplyType = SupplyGoodsProcurement;
            detailC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailC animated:YES];
        }
    }
}

/*
- (void)checkVersion {
    
    [NetworkInterface checkVersionFinished:^(BOOL success, NSData *response) {
        
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestSuccess) {
                    NSLog(@"shuju:%@",object);
                    id infoDict = [object objectForKey:@"result"];
                    if ([infoDict isKindOfClass:[NSDictionary class]]) {
                        int serviceVersion = [[infoDict objectForKey:@"versions"] intValue];
                        _updateURL = [infoDict objectForKey:@"down_url"];
                        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                        
                        NSLog(@"local:%@",localVersion);
                        if (serviceVersion > [localVersion intValue]) {
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                                message:@"发现新版本，是否前往下载？"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"取消"
                                                                      otherButtonTitles:@"前往下载", nil];
                            [alertView show];
                        }
                        
                    }
                }
            }
        }
    }];
}

*/


 //AppStore 更新
 -(void)checkVersion
 {
 
     _updateURL = @"https://itunes.apple.com/app/id1004337490";
     NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
     NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
     NSArray *localVersionComponents = [localVersion componentsSeparatedByString:@"."];
 
     NSString *strURL=[[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=1004337490"];
     NSURL *url=[NSURL URLWithString:strURL];
 
     NSData *postData = [strURL dataUsingEncoding:NSUTF8StringEncoding];
 
     NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"POST"];
     [request setHTTPBody:postData];
 
     NSOperationQueue *queue=[NSOperationQueue mainQueue];
     [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data) {//请求成功
             NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
             NSLog(@"%@",dict);
             NSString *error=dict[@"error"];
             if (error) {
 
             }
             else
             {
                 NSArray *infoArray = [dict objectForKey:@"results"];
                 if ([infoArray count]) {
                     NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                     NSString *AppStoreVersion = [releaseInfo objectForKey:@"version"];
                     NSArray *AppStoreVersionComponents = [AppStoreVersion componentsSeparatedByString: @"."];
 
                     if ([localVersionComponents count] == 3 && [AppStoreVersionComponents count] == 3) {
                         if ([AppStoreVersionComponents[0] integerValue] > [localVersionComponents[0] integerValue])
                         { // A.b.c
                             [self displayUpdateMessage];
                         }
                         else if([AppStoreVersionComponents[1] integerValue] > [localVersionComponents[1] integerValue])
                         { // a.B.c
                             [self displayUpdateMessage];
                         }
                         else if
                             ([AppStoreVersionComponents[2] integerValue] > [localVersionComponents[2] integerValue])
                         { // a.b.C
                             [self displayUpdateMessage];
                         }
                     }
                 }
             }
         }
     }];
 }
 
 
 
 -(void)displayUpdateMessage
 {
 
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                         message:@"发现新版本，是否前往下载？"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"前往下载", nil];
     [alertView show];
 
 }
 


#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
    }
}

@end
