//
//  PGDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PGDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface PGDetailController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSString *agentName;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *opreationer;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSString *terminalString;

@end

@implementation PGDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配货详情";
    [self initAndLayoutUI];
    [self getPrepareDetail];
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
}

- (void)initSubViewWithAllTerminals:(BOOL)isAll {
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat originY = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    CGFloat labelHeight = 20.f;
    CGFloat lineSpace = 2.f;
    CGFloat middleSpace = 20.f;
    CGFloat rightLabelWidth = 100.f; //右边label宽度
    //配货对象
    UILabel *preprareLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:preprareLabel withContent:@"配货对象"];
    //划线
    originY += labelHeight + lineSpace;
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, 1)];
    firstLine.backgroundColor = kMainColor;
    [_scrollView addSubview:firstLine];
    
    //代理商
    originY += 1 + lineSpace;
    UILabel *agentLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace - rightLabelWidth, labelHeight)];
    [self setLabel:agentLabel withContent:_agentName];
    //总计
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - rightSpace - rightLabelWidth, originY, rightLabelWidth, labelHeight)];
    [self setLabel:totalLabel withContent:[NSString stringWithFormat:@"总计%d件",_count]];
    totalLabel.textAlignment = NSTextAlignmentRight;
    
    //配货日期
    originY += labelHeight + middleSpace;
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:timeTitleLabel withContent:@"配货日期"];
    //划线
    originY += labelHeight + lineSpace;
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, 1)];
    secondLine.backgroundColor = kMainColor;
    [_scrollView addSubview:secondLine];
    //时间
    originY += 1 + lineSpace;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:timeLabel withContent:_createTime];
    
    //操作人标题
    originY += labelHeight + middleSpace;
    UILabel *operationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:operationTitleLabel withContent:@"操作人"];
    //划线
    originY += labelHeight + lineSpace;
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, 1)];
    thirdLine.backgroundColor = kMainColor;
    [_scrollView addSubview:thirdLine];
    //操作人
    originY += 1 + lineSpace;
    UILabel *operationLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabel:operationLabel withContent:_opreationer];
    
    //终端号标题
    originY += labelHeight + middleSpace;
    UILabel *terminalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace - rightLabelWidth, labelHeight)];
    [self setLabel:terminalTitleLabel withContent:@"终端号"];
    
    //总计
    NSArray *terminalList = [_terminalString componentsSeparatedByString:@","];
    UILabel *terminalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - rightSpace - rightLabelWidth, originY, rightLabelWidth, labelHeight)];
    [self setLabel:terminalCountLabel withContent:[NSString stringWithFormat:@"总计%ld件",[terminalList count]]];
    terminalCountLabel.textAlignment = NSTextAlignmentRight;
    //划线
    originY += labelHeight + lineSpace;
    UIView *forthLine = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, 1)];
    forthLine.backgroundColor = kMainColor;
    [_scrollView addSubview:forthLine];
    
    originY += 1 + lineSpace;
    //终端
    if (isAll) {
        for (int i = 0; i < [terminalList count]; i++) {
            UILabel *terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
            [self setLabel:terminalLabel withContent:[terminalList objectAtIndex:i]];
            originY += labelHeight;
        }
    }
    else {
        if ([terminalList count] > 5) {
            for (int i = 0; i < 5; i++) {
                UILabel *terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
                [self setLabel:terminalLabel withContent:[terminalList objectAtIndex:i]];
                originY += labelHeight;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(leftSpace, originY + 5, 100, 30);
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1.f;
            button.layer.borderColor = kMainColor.CGColor;
            [button setTitleColor:kMainColor forState:UIControlStateNormal];
            [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:11.f];
            [button setTitle:@"查看全部终端号" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(scanAllTerminal:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            originY += 40;
        }
        else {
            for (int i = 0; i < [terminalList count]; i++) {
                UILabel *terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
                [self setLabel:terminalLabel withContent:[terminalList objectAtIndex:i]];
                originY += labelHeight;
            }
        }
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth, originY);
}

- (void)setLabel:(UILabel *)label withContent:(NSString *)content {
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = content;
    [_scrollView addSubview:label];
}

#pragma mark - Action

- (IBAction)scanAllTerminal:(id)sender {
    [self initSubViewWithAllTerminals:YES];
}

#pragma mark - Request

- (void)getPrepareDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getPrepareGoodDetailWithToken:delegate.token prapareID:_prepareID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parsePrepareDetailWithDictionary:object];
                    [self initSubViewWithAllTerminals:NO];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parsePrepareDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *detailDict = [dict objectForKey:@"result"];
    _agentName = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"company_name"]];
    _createTime = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"created_at"]];
    _opreationer = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"creator"]];
    _count = [[detailDict objectForKey:@"quantity"] intValue];
    _terminalString = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"terminal_list"]];
}

@end
