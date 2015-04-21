//
//  HomeImageModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/12.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeImageModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSString *websiteURL;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
