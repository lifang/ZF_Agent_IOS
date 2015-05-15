//
//  CancelDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CancelDetailController.h"

@interface CancelDetailController ()

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *terminalNum;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantPhone;

@end

@implementation CancelDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initSubViews {
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpce = 20.f;
    CGFloat space = 2.f;       //label之间垂直间距
    CGFloat lineSpace = 20.f;  //划线前后间距
    CGFloat titleLabelHeight = 20.f;
    
    //右侧按钮宽度
    CGFloat btnWidth = 80.f;
    
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont systemFontOfSize:18.f];
    [self.scrollView addSubview:statusLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce - btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.f]];
    
    //申请时间
    UILabel *applyTimeLabel = [[UILabel alloc] init];
    [self setLabel:applyTimeLabel withTopView:statusLabel middleSpace:space];
    applyTimeLabel.textColor = [UIColor blackColor];
    //划线 90
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(222, 220, 220, 1);
    [self.scrollView addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:applyTimeLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //终端信息 111
    UILabel *terminalTitleLabel = [[UILabel alloc] init];
    terminalTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    terminalTitleLabel.backgroundColor = [UIColor clearColor];
    terminalTitleLabel.textColor = kColor(108, 108, 108, 1);
    terminalTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:terminalTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线 133
    UIView *secondLine = [[UIView alloc] init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.backgroundColor = kMainColor;
    [self.scrollView addSubview:secondLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //终端号136
    UILabel *terminalNumberLabel = [[UILabel alloc] init];
    [self setLabel:terminalNumberLabel withTopView:secondLine middleSpace:space];
    //POS品牌
    UILabel *brandLabel = [[UILabel alloc] init];
    [self setLabel:brandLabel withTopView:terminalNumberLabel middleSpace:space];
    //POS型号
    UILabel *modelLabel = [[UILabel alloc] init];
    [self setLabel:modelLabel withTopView:brandLabel middleSpace:space];
    //支付平台
    UILabel *channelLabel = [[UILabel alloc] init];
    [self setLabel:channelLabel withTopView:modelLabel middleSpace:space];
    //商户名
    UILabel *merchantNameLabel = [[UILabel alloc] init];
    [self setLabel:merchantNameLabel withTopView:channelLabel middleSpace:space];
    //商户电话 236
    UILabel *merchantPhoneLabel = [[UILabel alloc] init];
    [self setLabel:merchantPhoneLabel withTopView:merchantNameLabel middleSpace:space];
    
    
    
    CGFloat resourceHeight = 0.f;
    CGFloat tempHeight = lineSpace; //计算资料高度
    //资料
    if ([self.resources count] > 0) {
        UILabel *resourceLabel = [[UILabel alloc] init];
        resourceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        resourceLabel.backgroundColor = [UIColor clearColor];
        resourceLabel.textColor = kColor(108, 108, 108, 1);
        resourceLabel.font = [UIFont systemFontOfSize:16.f];
        resourceLabel.text = @"注销所需资料";
        [self.scrollView addSubview:resourceLabel];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:merchantPhoneLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:tempHeight]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-rightSpce]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:titleLabelHeight]];
        //划线
        UIView *tempLine = [[UIView alloc] init];
        tempLine.translatesAutoresizingMaskIntoConstraints = NO;
        tempLine.backgroundColor = kMainColor;
        [self.scrollView addSubview:tempLine];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:resourceLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-rightSpce]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tempLine
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:1.0]];
        tempHeight += titleLabelHeight + space * 2 + 1;
        //资料
        for (int i = 0; i < [self.resources count]; i++) {
            ResourceModel *model = [self.resources objectAtIndex:i];
            UILabel *resourceTitleLabel = [[UILabel alloc] init];
            resourceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            resourceTitleLabel.backgroundColor = [UIColor clearColor];
            resourceTitleLabel.font = [UIFont systemFontOfSize:13.f];
            resourceTitleLabel.textColor = kColor(108, 108, 108, 1);
            resourceTitleLabel.text = model.title;
            resourceTitleLabel.adjustsFontSizeToFitWidth = YES;
            [self.scrollView addSubview:resourceTitleLabel];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:merchantPhoneLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:tempHeight]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:leftSpace]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:0.0
                                                                   constant:80.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:40.f]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            if (model.path && ![model.path isEqualToString:@""]) {
                [button setTitleColor:kMainColor forState:UIControlStateNormal];
                [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(scanResource:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i + 1;
                [button setTitle:@"点击查看" forState:UIControlStateNormal];
            }
            else {
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [button setTitle:@"未提交" forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            }
            button.tag = i + 1;
            [self.scrollView addSubview:button];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:merchantPhoneLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:tempHeight]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:resourceTitleLabel
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:0.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:0.0
                                                                   constant:80.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:40.f]];
            tempHeight += 40.f;
        }
        resourceHeight = tempHeight;
    }
    //417
    CGFloat recordHeight = 0.f;
    //追踪记录
//    if ([self.records count] > 0) {
//        UILabel *tipLabel = [[UILabel alloc] init];
//        [self setLabel:tipLabel withTopView:merchantPhoneLabel middleSpace:resourceHeight + lineSpace];
//        tipLabel.font = [UIFont systemFontOfSize:10.f];
//        tipLabel.text = @"追踪记录：";
//        RecordView *recordView = [[RecordView alloc] initWithRecords:self.records
//                                                               width:(kScreenWidth - leftSpace * 2)];
//        recordView.translatesAutoresizingMaskIntoConstraints = NO;
//        recordHeight = [recordView getHeight];
//        [self.scrollView addSubview:recordView];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
//                                                              attribute:NSLayoutAttributeTop
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:merchantPhoneLabel
//                                                              attribute:NSLayoutAttributeBottom
//                                                             multiplier:1.0
//                                                               constant:lineSpace * 2 + resourceHeight]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
//                                                              attribute:NSLayoutAttributeLeft
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeLeft
//                                                             multiplier:1.0
//                                                               constant:leftSpace]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
//                                                              attribute:NSLayoutAttributeRight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeRight
//                                                             multiplier:1.0
//                                                               constant:-rightSpce]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
//                                                              attribute:NSLayoutAttributeHeight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:nil
//                                                              attribute:NSLayoutAttributeNotAnAttribute
//                                                             multiplier:1.0
//                                                               constant:recordHeight]];
//        [recordView initAndLayoutUI];
//    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 300 + resourceHeight + recordHeight);
    terminalTitleLabel.text = @"终端信息";
    statusLabel.text = [CSDataHandle getStatusStringWithCSType:self.csType status:_status];
    applyTimeLabel.text = [NSString stringWithFormat:@"申请时间：%@",_applyTime];
    terminalNumberLabel.text = [NSString stringWithFormat:@"终 端  号  %@",_terminalNum];
    brandLabel.text = [NSString stringWithFormat:@"POS品牌  %@",_brandName];
    modelLabel.text = [NSString stringWithFormat:@"POS型号 %@",_modelName];
    channelLabel.text = [NSString stringWithFormat:@"支付平台  %@",_channelName];
    merchantNameLabel.text = [NSString stringWithFormat:@"商 户  名  %@",_merchantName];
    merchantPhoneLabel.text = [NSString stringWithFormat:@"商户电话  %@",_merchantPhone];
    
    //添加按钮
    [self addButton];
}

- (void)addButton {
    switch (_status) {
        case CSStatusFirst: {
            //待处理
            UIButton *cancelBtn = [self buttonWithTitle:@"取消申请" action:@selector(cancelApply:)];
            [self layoutButton:cancelBtn position:OperationBtnFirst];
        }
            break;
        case CSStatusSecond:
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            break;
        case CSStatusFifth: {
            //已取消
            UIButton *sendBtn = [self buttonWithTitle:@"重新提交注销" action:@selector(submit:)];
            [self layoutButton:sendBtn position:OperationBtnFirst];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 重写

- (void)parseCSDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    if ([infoDict objectForKey:@"status"]) {
        _status = [[infoDict objectForKey:@"status"] intValue];
    }
    if ([infoDict objectForKey:@"apply_time"]) {
        _applyTime = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"apply_time"]];
    }
    else {
        _applyTime = @"";
    }
    if ([infoDict objectForKey:@"terminal_num"]) {
        _terminalNum = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"terminal_num"]];
    }
    else {
        _terminalNum = @"";
    }
    if ([infoDict objectForKey:@"brand_name"]) {
        _brandName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"brand_name"]];
    }
    else {
        _brandName = @"";
    }
    if ([infoDict objectForKey:@"brand_number"]) {
        _modelName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"brand_number"]];
    }
    else {
        _modelName = @"";
    }
    if ([infoDict objectForKey:@"zhifu_pingtai"]) {
        _channelName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"zhifu_pingtai"]];
    }
    else {
        _channelName = @"";
    }
    if ([infoDict objectForKey:@"merchant_name"]) {
        _merchantName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"merchant_name"]];
    }
    else {
        _merchantName = @"";
    }
    if ([infoDict objectForKey:@"merchant_phone"]) {
        _merchantPhone = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"merchant_phone"]];
    }
    else {
        _merchantPhone = @"";
    }
    
    id resourceObject = [infoDict objectForKey:@"resource_info"];
    if ([resourceObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [resourceObject count]; i++) {
            ResourceModel *model = [[ResourceModel alloc] initWithParseDictionary:[resourceObject objectAtIndex:i]];
            [self.resources addObject:model];
        }
    }
    
    id object = [[infoDict objectForKey:@"comments"] objectForKey:@"list"];
    if ([object isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [object count]; i++) {
            RecordModel *model = [[RecordModel alloc] initWithParseDictionary:[object objectAtIndex:i]];
            [self.records addObject:model];
        }
    }
    [self initSubViews];
}

#pragma mark - Action

- (IBAction)scanResource:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ResourceModel *model = [self.resources objectAtIndex:btn.tag - 1];
    ChannelWebsiteController *websiteC = [[ChannelWebsiteController alloc] init];
    websiteC.title = @"资料详情";
    websiteC.urlString = model.path;
    [self.navigationController pushViewController:websiteC animated:YES];
}

- (IBAction)cancelApply:(id)sender {
    [self cancelApply];
}

- (IBAction)submit:(id)sender {
    [self submitCanncelApply];
}


@end
