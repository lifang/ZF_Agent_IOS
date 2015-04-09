//
//  CSDataHandle.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkInterface.h"
#import "CSModel.h"
#import "KxMenu.h"

@interface CSDataHandle : NSObject

//状态选择提示信息
+ (NSString *)statusTitleForCSType:(CSType)csType;

//详情标题
+ (NSString *)titleForDetailWithCSType:(CSType)csType;

//标题
+ (NSString *)titleForCSType:(CSType)csType;

//状态
+ (NSString *)getStatusStringWithCSType:(CSType)csType
                                 status:(int)status;

//menu
+ (NSArray *)statusMenuWithCSType:(CSType)csType
                           target:(id)target
                           action:(SEL)action
                    selectedTitle:(NSString *)title;

@end
