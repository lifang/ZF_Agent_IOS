//
//  SelectedModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedModel : NSObject

@property (nonatomic, strong) NSString *itemName;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithName:(NSString *)name AndID:(NSString *)ID;

@end
