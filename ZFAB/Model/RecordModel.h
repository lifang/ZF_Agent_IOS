//
//  RecordModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property (nonatomic, strong) NSString *recordName;

@property (nonatomic, strong) NSString *recordTime;

@property (nonatomic, strong) NSString *recordContent;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
