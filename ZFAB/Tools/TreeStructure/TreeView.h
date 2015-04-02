//
//  TreeView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNodeInfo.h"

@protocol TreeDelegate;

@interface TreeView : UIView

@property (nonatomic, assign) id<TreeDelegate> TreeDelegate;

@property (nonatomic, strong) UITableView *tableView;

- (void)reloadData;

@end

@protocol TreeDelegate <NSObject>

@required
//返回某一节点children数量
- (NSInteger)treeView:(TreeView *)treeView numberOfChildrenOfItem:(id)item;
//返回某一节点index位置子节点对象
- (id)treeView:(TreeView *)treeView child:(NSInteger)index ofItem:(id)item;
//tableview显示样式
- (UITableViewCell *)treeView:(TreeView *)treeView cellForItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo;

@optional
//根据深度返回左侧偏移量
- (NSInteger)treeView:(TreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo;
//设置背景色
- (void)treeView:(TreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo;

- (void)treeView:(TreeView *)treeView didSelectRowForCell:(UITableViewCell *)cell ofItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo;

/*
 上下拉刷新使用方法
 */

- (void)treeViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)treeViewDidScroll:(UIScrollView *)scrollView;
- (void)treeViewDidEndDragging:(UIScrollView *)scrollView;

@end
