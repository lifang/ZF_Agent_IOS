//
//  TreeNodeModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNodeModel : NSObject

@property (nonatomic, strong) NSString *nodeName;

@property (nonatomic, strong) NSString *nodeID;

@property (nonatomic, strong) NSArray *children;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithDirectoryName:(NSString *)name
                   children:(NSArray *)children
                     nodeID:(NSString *)nodeID;

@end
