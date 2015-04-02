//
//  NavigationBarAttr.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NavigationBarAttr.h"

@implementation NavigationBarAttr

+ (void)setNavigationBarStyle:(UINavigationController *)nav {
    [nav.navigationBar setBackgroundImage:[kImageName(@"blue.png")
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(21, 1, 21, 1)]
                            forBarMetrics:UIBarMetricsDefault];
    NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor whiteColor],NSForegroundColorAttributeName,
                              nil];
    nav.navigationBar.titleTextAttributes = textDict;
    nav.navigationBar.tintColor = [UIColor whiteColor];
}

@end
