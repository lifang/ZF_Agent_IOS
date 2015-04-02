//
//  TreeNode.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

/*
 节点对象，树中的主体
 */

#import <Foundation/Foundation.h>

@class TreeNodeInfo;

@interface TreeNode : NSObject

//节点是否展开
@property (nonatomic, assign) BOOL expanded;

//节点深度
@property (nonatomic, assign) NSInteger treeDepthLevel;

//节点所对应的数据对象，自定义
@property (nonatomic, strong) id item;

//节点后代数组
@property (nonatomic, strong) NSArray *descendants;

//子节点数组
@property (nonatomic, strong) NSArray *children;

//节点说明对象
@property (nonatomic, strong) TreeNodeInfo *treeNodeInfo;

//父节点
@property (nonatomic, weak) TreeNode *parent;

//初始化
- (id)initWithItem:(id)item
            parent:(TreeNode *)parent
          expanded:(BOOL)expanded;

//添加子节点
- (void)addChildNode:(TreeNode *)child;

//节点可视后代数量
- (NSInteger)numberOfVisibleDescendants;

//展开与折叠
- (void)expand;
- (void)collapse;

//节点起止位置
- (NSInteger)startIndex;
- (NSInteger)endIndex;

@end
