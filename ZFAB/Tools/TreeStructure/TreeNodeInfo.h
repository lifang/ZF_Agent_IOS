//
//  TreeNodeInfo.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

/*
 节点说明对象，节点的详细信息
 */

#import <Foundation/Foundation.h>

@class TreeNode;

@interface TreeNodeInfo : NSObject

//相对于TreeNode的父节点、子节点
@property (nonatomic, strong) TreeNode *parentTreeNode;
@property (nonatomic, strong) NSArray *childrenTreeNodes;

//深度
@property (nonatomic, assign) NSInteger treeDepthLevel;
//兄弟个数
@property (nonatomic, assign) NSInteger siblingsNumber;
//在兄弟中第几个
@property (nonatomic, assign) NSInteger postionInSiblings;

//是否展开
@property (nonatomic, assign) BOOL expanded;
//节点所对应的数据对象，自定义
@property (nonatomic, strong) id item;

//节点说明对象的父节点（与parentTreeNode区分）
@property (nonatomic, strong) TreeNodeInfo *parent;
//节点说明对象的子节点（与childrenTreenNodes区分）
@property (nonatomic, strong) NSArray *children;

//初始化
- (id)initWithParent:(TreeNode *)parent
            children:(NSArray *)children;

@end
