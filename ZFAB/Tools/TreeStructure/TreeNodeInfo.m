//
//  TreeNodeInfo.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "TreeNodeInfo.h"
#import "TreeNode.h"

@implementation TreeNodeInfo

- (id)initWithParent:(TreeNode *)parent
            children:(NSArray *)children {
    if (self = [super init]) {
        _parentTreeNode = parent;
        _childrenTreeNodes = children;
    }
    return self;
}

- (TreeNodeInfo *)parent {
    if (_parent == nil) {
        _parent = [self.parentTreeNode treeNodeInfo];
    }
    return _parent;
}

- (NSArray *)children {
    if (_children == nil) {
        NSMutableArray *treeNodesInfos = [[NSMutableArray alloc] init];
        for (TreeNode *treeNode in self.childrenTreeNodes) {
            [treeNodesInfos addObject:[treeNode treeNodeInfo]];
        }
        _children = treeNodesInfos;
    }
    return _children;
}

@end
