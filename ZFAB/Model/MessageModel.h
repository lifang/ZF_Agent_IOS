//
//  MessageModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

/*我的消息对象*/
@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *messageID;

@property (nonatomic, strong) NSString *messageTitle;

@property (nonatomic, strong) NSString *messageContent;

@property (nonatomic, strong) NSString *messageTime;

@property (nonatomic, assign) BOOL messageRead;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
