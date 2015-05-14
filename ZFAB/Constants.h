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

#define kCoolDownTime  120   //冷却时间

//#define kServiceURL @"http://121.40.64.167:9090/api"
#define kServiceURL @"http://121.40.84.2:28080/ZFAgent/api"
//#define kServiceURL @"http://agent.ebank007.com/api"

//#define kVideoAuthIP    @"121.40.84.2"
#define kVideoAuthIP      @"121.40.64.120"   //线上
#define kVideoAuthPort  8906


//视频提示地址
#define kVideoServiceURL @"http://121.40.64.120:8080/notice/video"
//#define kVideoServiceURL @"http://admin.ebank007.com/notice/video"   //线上

//支付地址
#define kWhalesaleCallBackURL   @"http://121.40.64.167:9090/deposit_app_notify_url.jsp"
#define kProcurementCallBackURL @"http://121.40.64.167:9090/app_notify_url.jsp"
//线上
//#define kWhalesaleCallBackURL    @"http://agent.ebank007.com/deposit_app_notify_url.jsp"
//#define kProcurementCallBackURL  @"http://agent.ebank007.com/app_notify_url.jsp"

#define kImageName(name) [UIImage imageNamed:name]


#define kServiceReturnWrong  @"服务端数据返回错误"
#define kNetworkFailed       @"网络连接失败"
