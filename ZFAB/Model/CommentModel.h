//
//  CommentModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, strong) NSString *contentID;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, assign) CGFloat score;

@property (nonatomic, strong) NSString *content;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
