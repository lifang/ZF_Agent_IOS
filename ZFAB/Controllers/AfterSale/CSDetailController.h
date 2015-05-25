//
//  CSDetailController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "CSDataHandle.h"
#import "RecordView.h"
#import "ResourceModel.h"
#import "ChannelWebsiteController.h"

typedef enum {
    OperationBtnFirst = 1,
    OperationBtnSecond,
}OperationBtn; //详情有几个操作按钮 用来定位置

@interface CSDetailController : CommonViewController

@property (nonatomic, assign) CSType csType;

@property (nonatomic, strong) NSString *csID;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *records; //保存追踪记录

@property (nonatomic, strong) NSMutableArray *resources; //保存资料

- (void)parseCSDetailDataWithDictionary:(NSDictionary *)dict;

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action;

- (void)layoutButton:(UIButton *)button
            position:(OperationBtn)position;

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space;

- (CGFloat)setLabel:(UILabel *)label
        withTopView:(UIView *)topView
        middleSpace:(CGFloat)space
            content:(NSString *)content;

//取消申请
- (void)cancelApply;

//重新提交注销申请
- (void)submitCanncelApply;

@end
