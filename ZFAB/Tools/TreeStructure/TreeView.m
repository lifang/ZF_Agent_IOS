//
//  TreeView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "TreeView.h"
#import "TreeNodeCollection.h"
#import "TreeNode.h"

@interface TreeView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TreeNodeCollection *treeNodeCollection;

@end

@implementation TreeView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initTableView];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.delegate = (id<UITableViewDelegate>)self;
    _tableView.dataSource = (id<UITableViewDataSource>)self;
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    _tableView.backgroundColor = kColor(244, 244, 244, 1);
    [self addSubview:_tableView];
}

- (void)reloadData {
    //初始化树形结构
    [self createTreeStructure];
    [_tableView reloadData];
}

#pragma mark - 建树

- (void)createTreeStructure {
    _treeNodeCollection = [[TreeNodeCollection alloc] init];
    //建树
    [self createTreeStructureWithParentNode:nil treeDepthLevel:0];
}

- (void)createTreeStructureWithParentNode:(TreeNode *)parentTreeNode
                           treeDepthLevel:(NSInteger)treeDepthLevel {
    NSArray *children = [self childrenForItem:parentTreeNode.item];
    for (id item in children) {
        //初始创建节点折叠
        BOOL expanded = NO;
        //创建一个折叠的子节点 初始时父节点为nil
        TreeNode *treeNode = [[TreeNode alloc] initWithItem:item
                                                     parent:parentTreeNode
                                                   expanded:expanded];
        //递归添加子节点
        [self createTreeStructureWithParentNode:treeNode
                                 treeDepthLevel:treeDepthLevel + 1];
        //将节点添加到树中
        [self.treeNodeCollection addTreeNode:treeNode];
    }
}

- (NSArray *)childrenForItem:(id)item {
    NSMutableArray *children = [NSMutableArray array];
    NSInteger numberOfChildren = [self.TreeDelegate treeView:self
                                      numberOfChildrenOfItem:item];
    for (int i = 0; i < numberOfChildren; i++) {
        [children addObject:[self.TreeDelegate treeView:self
                                                  child:i
                                                 ofItem:item]];
    }
    return [NSArray arrayWithArray:children];
}

- (TreeNode *)treeNodeForIndex:(NSInteger)index {
    return [self.treeNodeCollection treeNodeForIndex:index];
}

#pragma mark - 折叠与展开

//折叠某一节点
- (void)collapseCellForTreeNode:(TreeNode *)treeNode {
    [_tableView beginUpdates];
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    for (int index = (int)[treeNode startIndex] + 1; index <= [treeNode endIndex]; index++) {
        [indexes addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    [treeNode collapse];
    [_tableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

//展开某一节点
- (void)expandCellForTreeNode:(TreeNode *)treeNode {
    [_tableView beginUpdates];
    [treeNode expand];
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    for (int index = (int)[treeNode startIndex] + 1; index <= [treeNode endIndex]; index++) {
        [indexes addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    [_tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_treeNodeCollection == nil) {
        [self createTreeStructure];
    }
    return [_treeNodeCollection.root numberOfVisibleDescendants];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TreeNode *treeNode = [_treeNodeCollection treeNodeForIndex:indexPath.row];
    return [_TreeDelegate treeView:self cellForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    if ([_TreeDelegate respondsToSelector:@selector(treeView:didSelectRowForCell:ofItem:treeNodeInfo:)]) {
        [_TreeDelegate treeView:self didSelectRowForCell:cell ofItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
    }
    if ([[treeNode treeNodeInfo].children count] == 0) {
        return;
    }
    if (treeNode.expanded) {
        [self collapseCellForTreeNode:treeNode];
    }
    else {
        [self expandCellForTreeNode:treeNode];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_TreeDelegate respondsToSelector:@selector(treeView:indentationLevelForRowForItem:treeNodeInfo:)]) {
        TreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
        return [_TreeDelegate treeView:self indentationLevelForRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_TreeDelegate respondsToSelector:@selector(treeView:willDisplayCell:forItem:treeNodeInfo:)]) {
        TreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
        [_TreeDelegate treeView:self willDisplayCell:cell forItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 上下拉刷新使用，若不用可删除

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_TreeDelegate respondsToSelector:@selector(treeViewWillBeginDragging:)]) {
        [_TreeDelegate treeViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_TreeDelegate respondsToSelector:@selector(treeViewDidScroll:)]) {
        [_TreeDelegate treeViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([_TreeDelegate respondsToSelector:@selector(treeViewDidEndDragging:)]) {
        [_TreeDelegate treeViewDidEndDragging:scrollView];
    }
}

@end
