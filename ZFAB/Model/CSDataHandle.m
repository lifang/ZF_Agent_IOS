//
//  CSDataHandle.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CSDataHandle.h"

@implementation CSDataHandle

+ (NSString *)statusTitleForCSType:(CSType)csType {
    NSString *statusTitle = nil;
    switch (csType) {
        case CSTypeAfterSale:
            statusTitle = @"选择售后单状态";
            break;
        case CSTypeUpdate:
            statusTitle = @"选择更新资料状态";
            break;
        case CSTypeCancel:
            statusTitle = @"选择注销状态";
            break;
        default:
            break;
    }
    return statusTitle;
}

+ (NSString *)titleForDetailWithCSType:(CSType)csType {
    NSString *title = nil;
    switch (csType) {
        case CSTypeAfterSale:
            title = @"售后单详情";
            break;
        case CSTypeUpdate:
            title = @"更新资料详情";
            break;
        case CSTypeCancel:
            title = @"注销详情";
            break;
        default:
            break;
    }
    return title;
}

+ (NSString *)titleForCSType:(CSType)csType {
    NSString *title = nil;
    switch (csType) {
        case CSTypeAfterSale:
            title = @"售后单记录";
            break;
        case CSTypeUpdate:
            title = @"更新资料记录";
            break;
        case CSTypeCancel:
            title = @"注销";
            break;
        default:
            break;
    }
    return title;
}

+ (NSString *)getStatusStringWithCSType:(CSType)csType
                                 status:(int)status {
    NSString *statuString = nil;
    switch (csType) {
        case CSTypeAfterSale:
            statuString = [[self class] aftersaleStatusStringWithStatus:status];
            break;
        case CSTypeUpdate:
            statuString = [[self class] updateStatusStringWithStatus:status];
            break;
        case CSTypeCancel:
            statuString = [[self class] cancelStatusStringWithStauts:status];
            break;
        default:
            break;
    }
    return statuString;
}

+ (NSArray *)statusMenuWithCSType:(CSType)csType
                           target:(id)target
                           action:(SEL)action
                    selectedTitle:(NSString *)title {
    NSArray *menuList = nil;
    NSString *allTitle = [CSDataHandle getStatusStringWithCSType:csType status:CSStatusAll];
    NSString *firstTitle = [CSDataHandle getStatusStringWithCSType:csType status:CSStatusFirst];
    NSString *secondTitle = [CSDataHandle getStatusStringWithCSType:csType status:CSStatusSecond];
    NSString *thirdTitle = [CSDataHandle getStatusStringWithCSType:csType status:CSStatusThird];
    NSString *forthTitle = [CSDataHandle getStatusStringWithCSType:csType status:CSStatusForth];
    NSString *fifthTitle = [CSDataHandle getStatusStringWithCSType:csType status:CSStatusFifth];
    switch (csType) {
        case CSTypeAfterSale: {
            menuList = [NSArray arrayWithObjects:
                        [KxMenuItem menuItem:allTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusAll],
                        [KxMenuItem menuItem:firstTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusFirst],
                        [KxMenuItem menuItem:secondTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusSecond],
                        [KxMenuItem menuItem:thirdTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusThird],
                        [KxMenuItem menuItem:forthTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusForth],
                        
                        nil];
            
        }
            break;
        case CSTypeUpdate: {
            menuList = [NSArray arrayWithObjects:
                        [KxMenuItem menuItem:allTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusAll],
                        [KxMenuItem menuItem:firstTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusFirst],
                        [KxMenuItem menuItem:secondTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusSecond],
                        [KxMenuItem menuItem:forthTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusForth],
                        [KxMenuItem menuItem:fifthTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusFifth],
                        
                        nil];

        }
            break;
        case CSTypeCancel: {
            menuList = [NSArray arrayWithObjects:
                        [KxMenuItem menuItem:allTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusAll],
                        [KxMenuItem menuItem:firstTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusFirst],
                        [KxMenuItem menuItem:secondTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusSecond],
                        [KxMenuItem menuItem:forthTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusForth],
                        [KxMenuItem menuItem:fifthTitle
                                       image:nil
                                      target:target
                                      action:action
                               selectedTitle:title
                                         tag:CSStatusFifth],
                        
                        nil];
        }
            break;
        default:
            break;
    }
    return menuList;
}

+ (NSString *)aftersaleStatusStringWithStatus:(int)status {
    NSString *statusString = nil;
    switch (status) {
        case CSStatusAll:
            statusString = @"全部";
            break;
        case CSStatusFirst:
            statusString = @"待处理";
            break;
        case CSStatusSecond:
            statusString = @"处理中";
            break;
        case CSStatusThird:
            statusString = @"处理完成";
            break;
        case CSStatusForth:
            statusString = @"已取消";
            break;
        case CSStatusFifth:
            break;
        default:
            break;
    }
    return statusString;
}

+ (NSString *)updateStatusStringWithStatus:(int)status {
    NSString *statusString = nil;
    switch (status) {
        case CSStatusAll:
            statusString = @"全部";
            break;
        case CSStatusFirst:
            statusString = @"待处理";
            break;
        case CSStatusSecond:
            statusString = @"处理中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            statusString = @"处理完成";
            break;
        case CSStatusFifth:
            statusString = @"已取消";
            break;
        default:
            break;
    }
    return statusString;
}

+ (NSString *)cancelStatusStringWithStauts:(int)status {
    NSString *statusString = nil;
    switch (status) {
        case CSStatusAll:
            statusString = @"全部";
            break;
        case CSStatusFirst:
            statusString = @"待处理";
            break;
        case CSStatusSecond:
            statusString = @"处理中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            statusString = @"处理完成";
            break;
        case CSStatusFifth:
            statusString = @"已取消";
            break;
        default:
            break;
    }
    return statusString;
}

@end
