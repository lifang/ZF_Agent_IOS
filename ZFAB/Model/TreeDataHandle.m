//
//  TreeDataHandle.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TreeDataHandle.h"

@implementation TreeDataHandle

//解析
+ (NSDictionary *)parseData:(NSDictionary *)object {
    if (![object objectForKey:@"result"] || ![[object objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *allDict = [object objectForKey:@"result"];
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    for (NSString *key in allDict) {
        NSMutableArray *item = [allDict objectForKey:key];
        NSMutableArray *nodes = [[self class] childrenNode:item];
        //需要添加一个全部节点。
        TreeNodeModel *all = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
                                                                 children:nil
                                                                   nodeID:kNoneFilterID];
        [nodes insertObject:all atIndex:0];
        [resultDict setObject:nodes forKey:key];
    }
    return resultDict;
}

//递归解析
+ (NSMutableArray *)childrenNode:(NSArray *)childArray {
    if (!childArray) {
        return nil;
    }
    NSMutableArray *childrenItem = [[NSMutableArray alloc] init];
    for (int i = 0; i < [childArray count]; i++) {
        NSDictionary *directory = [childArray objectAtIndex:i];
        NSString *ID = [NSString stringWithFormat:@"%@",[directory objectForKey:@"id"]];
        NSString *value = [NSString stringWithFormat:@"%@",[directory objectForKey:@"value"]];
        NSArray *children = [directory objectForKey:@"son"];
        TreeNodeModel *node = [[TreeNodeModel alloc] initWithDirectoryName:value
                                                                  children:[[self class] childrenNode:children]
                                                                    nodeID:ID];
        [childrenItem addObject:node];
    }
    return childrenItem;
}

@end
