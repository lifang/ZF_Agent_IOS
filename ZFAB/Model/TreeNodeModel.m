//
//  TreeNodeModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TreeNodeModel.h"

@implementation TreeNodeModel

- (id)initWithDirectoryName:(NSString *)name
                   children:(NSArray *)children
                     nodeID:(NSString *)nodeID {
    if (self = [super init]) {
        _nodeName = name;
        _children = children;
        _nodeID = nodeID;
    }
    return self;
}

@end
