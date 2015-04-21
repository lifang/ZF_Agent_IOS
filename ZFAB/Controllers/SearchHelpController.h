//
//  SearchHelpController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/20.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*列表中搜索操作*/

#import "CommonViewController.h"
#import "SearchViewController.h"

@interface SearchHelpController : CommonViewController<SearchDelegate>

@property (nonatomic, strong) NSString *searchInfo;

@property (nonatomic, assign) HistoryType historyType;

- (void)showSearchView;

@end
