//
//  SelectedModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SelectedModel.h"

@implementation SelectedModel

- (id)initWithName:(NSString *)name AndID:(NSString *)ID {
    if (self = [super init]) {
        _itemName = name;
        _ID = ID;
        _isSelected = NO;
    }
    return self;
}

@end
