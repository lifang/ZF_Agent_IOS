//
//  FilterViewController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

//列表界面刷新数据
static NSString *UpdateGoodListNotification = @"UpdateGoodListNotification";

@interface FilterViewController : CommonViewController

///保存用户选择的筛选条件
@property (nonatomic, strong) NSMutableDictionary *filterDict;

@end
