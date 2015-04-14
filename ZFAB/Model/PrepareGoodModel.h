//
//  PrepareGoodModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*配货*/
#import <Foundation/Foundation.h>

@interface PrepareGoodModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *agentName;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, assign) int count;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
