//
//  ZFSearchBar.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/29.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFSearchBar : UISearchBar

@property (nonatomic, strong) UITextField *inputField;

- (void)setAttrPlaceHolder:(NSString *)string;

@end
