//
//  POSModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*申请售后pos选择*/

#import <Foundation/Foundation.h>

@interface POSModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *title;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (id)initWithParsePrepareGoodDictionary:(NSDictionary *)dict;

@end
