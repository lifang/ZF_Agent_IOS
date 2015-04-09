//
//  OpeningModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/*终端管理 开通资料信息*/
#import <Foundation/Foundation.h>

typedef enum {
    ResourceNone = 0,
    ResourceText,      //文字
    ResourceImage,     //图片
}ResourceType;

@interface OpeningModel : NSObject

@property (nonatomic, strong) NSString *resourceKey;
@property (nonatomic, strong) NSString *resourceValue;
@property (nonatomic, assign) ResourceType type;

@property (nonatomic, assign) NSInteger index;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
