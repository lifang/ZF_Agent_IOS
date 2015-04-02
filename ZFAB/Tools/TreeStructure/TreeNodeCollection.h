//
//  TreeNodeCollection.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

/*
 在树型结构中对应于树，将所有节点添加到此类中
 */

#import <Foundation/Foundation.h>

@class TreeNode;
@class TreeNodeInfo;

@interface TreeNodeCollection : NSObject

//根节点
@property (nonatomic, strong) TreeNode *root;

//将子节点添加到树中
- (void)addTreeNode:(TreeNode *)treeNode;

//找到指定index的节点对象
- (TreeNode *)treeNodeForIndex:(NSInteger)index;

@end
