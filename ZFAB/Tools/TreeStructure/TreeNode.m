//
//  TreeNode.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "TreeNode.h"
#import "TreeNodeInfo.h"

typedef enum {
    TreenDepthLevelNotInitialzed,
}TreeDepthLevel;

@implementation TreeNode

- (id)initWithItem:(id)item
            parent:(TreeNode *)parent
          expanded:(BOOL)expanded {
    if (self = [super init]) {
        _treeDepthLevel = TreenDepthLevelNotInitialzed;
        _item = item;
        _parent = parent;
        _expanded = expanded;
        _children = [[NSArray alloc] init];
    }
    return self;
}

- (void)addChildNode:(TreeNode *)child {
    NSMutableArray *children = [self.children mutableCopy];
    [children addObject:child];
    self.children = [NSArray arrayWithArray:children];
}

- (void)expand {
    _expanded = YES;
    [self.parent expand];
}

- (void)collapse {
    _expanded = NO;
    for (TreeNode *treeNode in self.children) {
        [treeNode collapse];
    }
}

- (NSInteger)numberOfVisibleDescendants {
    return [[self visibleDescendants] count];
}

//计算可视节点数
- (NSArray *)visibleDescendants {
    if (_expanded) {
        NSMutableArray *visibleDesendants = [[NSMutableArray alloc] init];
        for (TreeNode *treeNode in self.children) {
            [visibleDesendants addObject:treeNode];
            if (treeNode.expanded) {
                [visibleDesendants addObjectsFromArray:[treeNode visibleDescendants]];
            }
        }
        return visibleDesendants;
    }
    else {
        return nil;
    }
}

- (NSInteger)startIndex {
    NSInteger starIndex;
    if (self.parent.parent == nil) {
        //父节点的父节点为nil，说明是一级节点，其父节点为root
        starIndex = 0;
    }
    else {
        starIndex = [self.parent startIndex] + 1;
    }
    //上面都只是将startIndex指向该组（即父节点下）的第一个，下面循环找到该节点在该组的第几个
    for (TreeNode *treeNode in self.parent.children) {
        if (treeNode != self) {
            starIndex += 1;
            if (treeNode.expanded) {
                /*
                 若在该父节点下，且在需要显示节点前的节点展开，需要加上前节点的子节点个数
                 如计算A2的startIndex，需要加上A1子节点的个数
                 A---A1
                 ---A11
                 ---A12
                 ---A13
                 ---A2
                 */
                starIndex += [treeNode numberOfVisibleDescendants];
            }
        }
        else {
            break;
        }
    }
    return starIndex;
}

- (NSInteger)endIndex {
    NSInteger startIndex = [self startIndex];
    //某一个节点子节点结束的位置，因为该节点本身就占一行，所以不用-1
    return startIndex + [self numberOfVisibleDescendants];
}

//节点说明对象
- (TreeNodeInfo *)treeNodeInfo {
    if (_treeNodeInfo == nil) {
        _treeNodeInfo = [[TreeNodeInfo alloc] initWithParent:self.parent
                                                    children:self.children];
        _treeNodeInfo.treeDepthLevel = [self treeDepthLevel];
        _treeNodeInfo.siblingsNumber = [self.parent.children count];
        _treeNodeInfo.postionInSiblings = [self.parent.children indexOfObject:self];
    }
    _treeNodeInfo.item = self.item;
    _treeNodeInfo.expanded = self.expanded;
    return _treeNodeInfo;
}

//后代节点
- (NSArray *)descendants {
    if (_descendants == nil) {
        NSMutableArray *descendants = [[NSMutableArray alloc] init];
        for (TreeNode *treeNode in self.children) {
            [descendants addObject:treeNode];
            [descendants addObjectsFromArray:[treeNode descendants]];
        }
        _descendants = descendants;
    }
    return _descendants;
}

//节点深度
- (NSInteger)treeDepthLevel {
    if (_treeDepthLevel == TreenDepthLevelNotInitialzed) {
        NSInteger treeDepthLevel = 0;
        TreeNode *current = self.parent.parent;
        while (current != nil) {
            treeDepthLevel++;
            current = current.parent;
        }
        _treeDepthLevel = treeDepthLevel;
    }
    return _treeDepthLevel;
}


@end
