//
//  Constants.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define kMainColor kColor(0, 111, 213, 1)

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScaling  kScreenWidth / 320   //用于计算高度

#define kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kLineHeight   0.5f

#define kPageSize 10   //分页加载每页行数

//#define kServiceURL @"http://114.215.149.242:28080/ZFAgent/api"
#define kServiceURL @"http://121.40.84.2:28080/ZFAgent/api"

#define kImageName(name) [UIImage imageNamed:name]



#define kServiceReturnWrong  @"服务端数据返回错误"
#define kNetworkFailed       @"网络连接失败"
