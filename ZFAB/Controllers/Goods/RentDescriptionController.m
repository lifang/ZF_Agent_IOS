//
//  RentDescriptionController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RentDescriptionController.h"

@interface RentDescriptionController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat viewHeight;

@end

@implementation RentDescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"租赁说明";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initSubView];
}

- (void)initSubView {
    UIView *topView = nil;
    NSString *minDate = [NSString stringWithFormat:@"%@个月",_goodDetail.minTime];
    NSString *maxDate = [NSString stringWithFormat:@"%@个月",_goodDetail.maxTime];
    topView = [self addRowsWithTitle:@"最短租赁时间" content:minDate topView:topView];
    topView = [self addRowsWithTitle:@"最长租赁时间" content:maxDate topView:topView];
    topView = [self addRowsWithTitle:@"每月租金" content:[NSString stringWithFormat:@"￥%.2f",_goodDetail.leasePrice] topView:topView];
    topView = [self addRowsWithTitle:@"说明" content:_goodDetail.leaseDescription topView:topView];
    topView = [self addRowsWithTitle:@"租赁协议" content:_goodDetail.leaseProtocol topView:topView];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, _viewHeight);
}

- (UIView *)addRowsWithTitle:(NSString *)title
                 content:(NSString *)content
                 topView:(UIView *)topView {
    CGFloat topSpace = 30.f;
    CGFloat leftSpace = 20.f;
    CGFloat titleLabelHeight = 30.f;
    CGFloat middleSpace = 5.f;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = title;
    [_scrollView addSubview:titleLabel];
    if (!topView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scrollView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:topSpace]];
    }
    else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:topSpace]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(204, 202, 203, 1);
    [_scrollView addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:middleSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:kLineHeight]];
    //内容
    UIFont *font = [UIFont systemFontOfSize:14.f];
    CGFloat contentHeight = [self heightForContent:content
                                          withFont:font
                                             width:kScreenWidth - 2 * leftSpace];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = font;
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    [_scrollView addSubview:contentLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:middleSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:contentHeight]];
    _viewHeight += topSpace + titleLabelHeight + middleSpace * 2 + kLineHeight + contentHeight;
    return contentLabel;
}

#pragma mark - Data

- (CGFloat)heightForContent:(NSString *)content
                   withFont:(UIFont *)font
                      width:(CGFloat)width {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          font,NSFontAttributeName,
                          nil];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height + 1 > 20.f ? rect.size.height + 1 : 20.f;
}

@end
