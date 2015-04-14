//
//  SerialModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*搜索的终端号*/
#import <Foundation/Foundation.h>

@interface SerialModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *serialNumber;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
