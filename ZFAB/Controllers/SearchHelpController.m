//
//  SearchHelpController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/20.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SearchHelpController.h"
#import "NavigationBarAttr.h"

@interface SearchHelpController ()

@end

@implementation SearchHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)showSearchView {
    SearchViewController *searchC = [[SearchViewController alloc] init];
    searchC.delegate = self;
    searchC.keyword = _searchInfo;
    searchC.type = _historyType;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchC];
    [NavigationBarAttr setNavigationBarStyle:nav];
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma mark - SearchDelegate

- (void)getSearchKeyword:(NSString *)keyword {
    //子类重写
}

@end
