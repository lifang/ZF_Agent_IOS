//
//  ZFSearchBar.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/29.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ZFSearchBar.h"

@implementation ZFSearchBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSearchBarStyle];
    }
    return self;
}

- (void)setSearchBarStyle {
    [self setImage:kImageName(@"good_search.png") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    NSArray *subviews = nil;
    if (kDeviceVersion >= 7.0) {
        subviews = [[self.subviews objectAtIndex:0] subviews];
    }
    else {
        subviews = self.subviews;
    }
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textFeild = (UITextField *)view;
            textFeild.font = [UIFont systemFontOfSize:14.f];
            if (kDeviceVersion >= 7.0) {
                textFeild.backgroundColor = kColor(95, 152, 237, 1);
                textFeild.layer.cornerRadius = 4;
                textFeild.layer.masksToBounds = YES;
                textFeild.textColor = [UIColor whiteColor];
                _inputField = textFeild;
                [self setAttrPlaceHolder:@"搜索商品"];
            }
        }
        else {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)setAttrPlaceHolder:(NSString *)string {
    NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor whiteColor],NSForegroundColorAttributeName,
                              nil];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttributes:textDict range:NSMakeRange(0, [attrString length])];
    _inputField.attributedPlaceholder = attrString;
}

@end
