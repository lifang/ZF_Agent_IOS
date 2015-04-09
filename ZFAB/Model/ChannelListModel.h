//
//  ChannelListModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillingModel : NSObject

@property (nonatomic, strong) NSString *billID;
@property (nonatomic, strong) NSString *billName;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

@interface ChannelListModel : NSObject

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSString *channelName;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
