//
//  AfterSaleDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AfterSaleDetailController.h"

@interface AfterSaleDetailController ()

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *terminalNums;

@end

@implementation AfterSaleDetailController

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
    CGFloat textHeight = 0;
    NSArray *terminalList = [_terminalNums componentsSeparatedByString:@","];
    if ([terminalList count] > 0) {
        textHeight = space;
        for (int i = 0; i < [terminalList count]; i++) {
            UILabel *terminalLabel = [[UILabel alloc] init];
            [self setLabel:terminalLabel withTopView:secondLine middleSpace:textHeight];
            terminalLabel.text = [terminalList objectAtIndex:i];
            textHeight += 18.f;
        }
    }
    
    //收货地址
    UILabel *addressTitleLabel = [[UILabel alloc] init];
    addressTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    addressTitleLabel.backgroundColor = [UIColor clearColor];
    addressTitleLabel.textColor = kColor(108, 108, 108, 1);
    addressTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:addressTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:addressTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:secondLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace + textHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:addressTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:addressTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:addressTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.translatesAutoresizingMaskIntoConstraints = NO;
    thirdLine.backgroundColor = kMainColor;
    [self.scrollView addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:addressTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:1.0]];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    [self setLabel:addressLabel withTopView:thirdLine middleSpace:space];
    
    //售后原因
    UILabel *reasonTitleLabel = [[UILabel alloc] init];
    reasonTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    reasonTitleLabel.backgroundColor = [UIColor clearColor];
    reasonTitleLabel.textColor = kColor(108, 108, 108, 1);
    reasonTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.scrollView addSubview:reasonTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reasonTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:addressLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reasonTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reasonTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reasonTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    
    UIView *forthLine = [[UIView alloc] init];
    forthLine.translatesAutoresizingMaskIntoConstraints = NO;
    forthLine.backgroundColor = kMainColor;
    [self.scrollView addSubview:forthLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forthLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:reasonTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forthLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forthLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forthLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:1.0]];
    UILabel *reasonLabel = [[UILabel alloc] init];
    [self setLabel:reasonLabel withTopView:forthLine middleSpace:space];
    
    CGFloat recordHeight = 0.f;
    //追踪记录
//    if ([self.records count] > 0) {
//        UILabel *tipLabel = [[UILabel alloc] init];
//        [self setLabel:tipLabel withTopView:reasonLabel middleSpace:lineSpace];
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
//                                                                 toItem:reasonLabel
//                                                              attribute:NSLayoutAttributeBottom
//                                                             multiplier:1.0
//                                                               constant:lineSpace * 2]];
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
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 320 + textHeight + recordHeight);
    terminalTitleLabel.text = @"终端号";
    addressTitleLabel.text = @"收货地址";
    reasonTitleLabel.text = @"售后原因";
    statusLabel.text = [CSDataHandle getStatusStringWithCSType:self.csType status:self.status];
    applyTimeLabel.text = [NSString stringWithFormat:@"申请时间：%@",_applyTime];
    addressLabel.text = _address;
    reasonLabel.text = _reason;
    
    
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
        case CSStatusFifth:
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
    if ([infoDict objectForKey:@"terminals_list"]) {
        _terminalNums = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"terminals_list"]];
    }
    if ([infoDict objectForKey:@"address"]) {
        _address = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"address"]];
    }
    if ([infoDict objectForKey:@"reason"]) {
        _reason = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"reason"]];
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

- (IBAction)cancelApply:(id)sender {
    [self cancelApply];
}


@end
