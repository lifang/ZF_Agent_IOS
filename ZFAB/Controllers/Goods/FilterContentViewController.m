//
//  FilterContentViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "FilterContentViewController.h"
#import "TreeDataHandle.h"
#import "TreeView.h"

@interface FilterContentViewController ()<TreeDelegate>

@property (nonatomic, strong) TreeView *treeView;

@end

@implementation FilterContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(filterFinished:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
    [self setSelectedStatusWithArray:_dataItem];
    [_treeView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGRect rect = self.view.bounds;
    rect.size.height -= self.navigationController.navigationBar.frame.size.height;
    if (kDeviceVersion >= 7.0) {
        rect.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    _treeView = [[TreeView alloc] initWithFrame:rect];
    _treeView.backgroundColor = kColor(244, 244, 244, 1);
    _treeView.TreeDelegate = self;
    [self.view addSubview:_treeView];
}

#pragma mark - Data
//进入界面默认选中上次条件
- (void)setSelectedStatusWithArray:(NSArray *)item {
    for (TreeNodeModel *node in item) {
        BOOL isContain = [self isSelectedFilterContainNode:node.nodeID];
        if (isContain) {
            node.isSelected = YES;
        }
        if (node.children) {
            [self setSelectedStatusWithArray:node.children];
        }
    }
}

//查询某一条件是否被选中
- (BOOL)isSelectedFilterContainNode:(NSString *)nodeID {
    NSArray *selectedItem = [_selectedFilterDict objectForKey:_key];
    for (TreeNodeModel *node in selectedItem) {
        if ([nodeID isEqualToString:node.nodeID]) {
            return YES;
        }
    }
    return NO;
}

//选择完成后将选中的条件放到数组中
- (void)saveSelectedFilterWithArray:(NSArray *)item
                        resultArray:(NSMutableArray *)resultItem {
    for (TreeNodeModel *node in item) {
        if (node.isSelected) {
            [resultItem addObject:node];
        }
        if (node.children) {
            [self saveSelectedFilterWithArray:node.children
                                  resultArray:resultItem];
        }
    }
}

//若选中的条件中包括全部,删除其他的
- (void)removeFilterIfContainAll:(NSMutableArray *)selectedItem {
    BOOL isContainAll = NO;
    for (TreeNodeModel *node in selectedItem) {
        if ([node.nodeID isEqualToString:kNoneFilterID]) {
            isContainAll = YES;
            break;
        }
    }
    if (isContainAll) {
        for (TreeNodeModel *node in selectedItem) {
            if (![node.nodeID isEqualToString:kNoneFilterID]) {
                node.isSelected = NO;
            }
        }
        [selectedItem removeAllObjects];
        TreeNodeModel *node = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
                                                                  children:nil
                                                                    nodeID:kNoneFilterID];
        [selectedItem addObject:node];
    }
}

- (void)clearAllStatus:(NSArray *)item {
    for (TreeNodeModel *node in item) {
        node.isSelected = NO;
        if (node.children) {
            [self clearAllStatus:node.children];
        }
    }
}

#pragma mark - Action

- (IBAction)filterFinished:(id)sender {
    NSMutableArray *selectedFilterItem = [[NSMutableArray alloc] init];
    [self saveSelectedFilterWithArray:_dataItem
                          resultArray:selectedFilterItem];
    [self removeFilterIfContainAll:selectedFilterItem];
    if ([selectedFilterItem count] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请至少选择一项条件"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        [_selectedFilterDict setObject:selectedFilterItem forKey:_key];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TreeDelegate

- (NSInteger)treeView:(TreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return [self.dataItem count];
    }
    return [[(TreeNodeModel *)item children] count];
}

- (id)treeView:(TreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return [self.dataItem objectAtIndex:index];
    }
    return [[(TreeNodeModel *)item children] objectAtIndex:index];
}

- (UITableViewCell *)treeView:(TreeView *)treeView cellForItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [treeView.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.text = [(TreeNodeModel *)item nodeName];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if ([(TreeNodeModel *)item isSelected]) {
        cell.imageView.image = kImageName(@"btn_selected.png");
    }
    else {
        cell.imageView.image = kImageName(@"btn_unselected.png");
    }
    if ([treeNodeInfo.childrenTreeNodes count] > 0) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 10)];
//        imageView.image = [UIImage imageNamed:@"arrow_down.png"];
//        cell.accessoryView = imageView;
        cell.accessoryView = nil;
    }
    else {
        cell.accessoryView = nil;
    }
    return cell;
}

- (void)treeView:(TreeView *)treeView didSelectRowForCell:(UITableViewCell *)cell ofItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//    if (treeNodeInfo.expanded) {
//        animation.values = [NSArray arrayWithObjects:
//                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 2, 0, 0, 1)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],nil];
//    }
//    else {
//        animation.values = [NSArray arrayWithObjects:
//                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 2, 0, 0, 1)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)],nil];
//    }
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    [cell.accessoryView.layer addAnimation:animation forKey:@"transform"];
    
//    if ([treeNodeInfo.childrenTreeNodes count] <= 0) {
        TreeNodeModel *node = (TreeNodeModel *)item;
        if ([_key isEqualToString:s_category]) {
            [self clearAllStatus:_dataItem];
            node.isSelected = !node.isSelected;
            [_treeView reloadData];
        }
        else {
            node.isSelected = !node.isSelected;
        }
        if (node.isSelected) {
            cell.imageView.image = kImageName(@"btn_selected.png");
        }
        else {
            cell.imageView.image = kImageName(@"btn_unselected.png");
        }
//    }
}

- (NSInteger)treeView:(TreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (void)treeView:(TreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
    if (treeNodeInfo.treeDepthLevel == 1) {
        cell.contentView.backgroundColor = kColor(230, 229, 229, 1);
    }
    else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
}


@end
