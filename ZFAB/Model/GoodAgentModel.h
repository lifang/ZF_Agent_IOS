//
//  GoodAgentModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*配货 调货代理商*/
#import <Foundation/Foundation.h>

@interface GoodAgentModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *name;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
