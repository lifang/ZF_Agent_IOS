//
//  FindPasswordController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

typedef enum {
    SendTypeNone = 0,
    SendTypeMobile,   //手机找回
    SendTypeEmail,    //邮箱找回
}SendType;

#import "CommonViewController.h"

@interface FindPasswordController : CommonViewController

@end
