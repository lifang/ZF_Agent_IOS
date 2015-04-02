//
//  TreeNodeCollection.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "TreeNodeCollection.h"
#import "TreeNode.h"

@implementation TreeNodeCollection

- (id)init {
    if (self = [super init]) {
        //根节点一定是展开的，否则为空列表
        _root = [[TreeNode alloc] initWithItem:nil parent:nil expanded:YES];
    }
    return self;
}

- (void)addTreeNode:(TreeNode *)treeNode {
    //将节点加入到树中，没有父节点，则设置父节点为根节点，有父节点，父节点添加子节点
    if (treeNode.parent == nil) {
        [_root addChildNode:treeNode];
        treeNode.parent = _root;
    }
    else {
        [treeNode.parent addChildNode:treeNode];
        //若子节点是展开的，其父节点一定展开
        if (treeNode.expanded) {
            [treeNode expand];
        }
    }
}

//在tableview显示某一行节点
- (TreeNode *)treeNodeForIndex:(NSInteger)index {
    if (index < 0) {
        return nil;
    }
    return [self treeNodeForIndex:index treeNode:_root];
}

- (TreeNode *)treeNodeForIndex:(NSInteger)index treeNode:(TreeNode *)currentNode {
    for (TreeNode *treeNode in currentNode.children) {
        if ([treeNode startIndex] == index) {
            return treeNode;
        }
        else if (index <= [treeNode endIndex]) {
            //大于该节点的startIndex，小于等于该节点的endIndex，说明该行是该节点的子节点，递归
            return [self treeNodeForIndex:index treeNode:treeNode];
        }
    }
    return nil;
}

@end
