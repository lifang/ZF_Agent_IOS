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

#define UMENG_APPKEY @"553defc8e0f55a043500022e"  //友盟key

#define kAppChannel  5  //推送channel

#define kAppVersionType  2   //版本更新

//#define kServiceURL @"http://121.40.224.25:9090/api" //YUFA
//#define kServiceURL @"http://121.40.84.2:28080/ZFAgent/api"
#define kServiceURL @"http://agent.ebank007.com/api"

//#define kVideoAuthIP    @"121.40.84.2"
#define kVideoAuthIP      @"121.40.64.120"   //线上
#define kVideoAuthPort  8906

//视频提示地址
//#define kVideoServiceURL @"http://121.40.84.2:38080/ZFManager/notice/video"
#define kVideoServiceURL @"http://admin.ebank007.com/notice/video"   //线上

//支付地址
#define kWhalesaleCallBackURL   @"http://121.40.84.2:28080/ZFAgent/deposit_app_notify_url.jsp"
#define kProcurementCallBackURL @"http://121.40.84.2:28080/ZFAgent/app_notify_url.jsp"

//线上
//#define kWhalesaleCallBackURL    @"http://agent.ebank007.com/deposit_app_notify_url.jsp"
//#define kProcurementCallBackURL  @"http://agent.ebank007.com/app_notify_url.jsp"

//UnionPay
#define kMode_Production             @"01" //测试
#define kUnionPayURL  @"http://121.40.84.2:28080/ZFAgent/unionpay.do" //测试

//#define kMode_Production             @"00"  //线上
//#define kUnionPayURL  @"http://agent.ebank007.com/unionpay.do" //线上

//#define kMode_Production             @"00"  //YUFA
//#define kUnionPayURL  @"http://121.40.224.25:9090/unionpay.do" //YUFA



#define kImageName(name) [UIImage imageNamed:name]

#define kServiceReturnWrong  @"服务端数据返回错误"
#define kNetworkFailed       @"网络连接失败"
