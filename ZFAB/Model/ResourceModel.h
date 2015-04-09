//
//  ResourceModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*售后记录 资料对象*/
#import <Foundation/Foundation.h>

@interface ResourceModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *path;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
