//
//  StatisticTradeController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "StatisticTradeController.h"
#import "AppDelegate.h"
#import "PorfitCell.h"

@interface StatisticTradeController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *blackView;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) NSMutableArray *dataItems;

@end

@implementation StatisticTradeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"统计结果";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    _dataItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self downloadStatisticData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 161)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    CGFloat blackViewHeight = 130.f;
    
    _blackView = [[UIView alloc] init];
    _blackView.translatesAutoresizingMaskIntoConstraints = NO;
    _blackView.backgroundColor = kColor(33, 32, 42, 1);
    [headerView addSubview:_blackView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_blackView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:headerView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_blackView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_blackView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_blackView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:blackViewHeight]];
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:14.f];
    infoLabel.text = @"交易金额";
    [_blackView addSubview:infoLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:20.f]];
    //金额
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.font = [UIFont boldSystemFontOfSize:48.f];
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    [_blackView addSubview:_priceLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:infoLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:60.f]];
    //交易笔数
    _countLabel = [[UILabel alloc] init];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:14.f];
    [_blackView addSubview:_countLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:20.f]];
    
    CGFloat statusLabelWidth = 60.f;
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = kColor(86, 86, 85, 1);
    _timeLabel.font = [UIFont systemFontOfSize:13.f];
    [headerView addSubview:_timeLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-(rightSpace + statusLabelWidth)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:20.f]];
    //状态
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.textColor = kColor(86, 86, 85, 1);
    _typeLabel.font = [UIFont systemFontOfSize:13.f];
    _typeLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:_typeLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_blackView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_timeLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:statusLabelWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:20.f]];
//    //划线
//    UIView *line = [[UIView alloc] init];
//    line.translatesAutoresizingMaskIntoConstraints = NO;
//    line.backgroundColor = kColor(190, 190, 190, 1);
//    [headerView addSubview:line];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:_timeLabel
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:10.f]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
//                                                          attribute:NSLayoutAttributeRight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1.0
//                                                           constant:-10.f]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:nil
//                                                          attribute:NSLayoutAttributeNotAnAttribute
//                                                         multiplier:0.0
//                                                           constant:kLineHeight]];
}

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setHeaderView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self setHeaderView];
}

#pragma mark - Request

- (void)downloadStatisticData {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    int hasPorfit = 1;
    if (delegate.hasProfit) {
        hasPorfit = 2;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getTradeStatistWithAgentID:delegate.agentID token:delegate.token tradeType:_tradeType subAgentID:_subAgentID terminalNumber:_terminalNumber startTime:_startTime endTime:_endTime hasProfit:hasPorfit finished:^(BOOL success, NSData *response) {
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
                    [self parseStatisticDataWithDictionary:object];
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

- (void)parseStatisticDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_dataItems removeAllObjects];
    NSArray *profitList = [dict objectForKey:@"result"];
    for (int i = 0; i < [profitList count]; i++) {
        id profitDict = [profitList objectAtIndex:i];
        if ([profitDict isKindOfClass:[NSDictionary class]]) {
            ProfitModel *model = [[ProfitModel alloc] initWithParseDictionary:profitDict];
            [_dataItems addObject:model];
        }
    }
    NSString *start = [self transformDateStringWithStrting:_startTime];
    NSString *end = [self transformDateStringWithStrting:_endTime];
    int count = 0;
    CGFloat summaryPrice = 0.f;
    for (ProfitModel *model in _dataItems) {
        count += model.totalCount;
        summaryPrice += model.amount;
    }
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",summaryPrice];
    _countLabel.text = [NSString stringWithFormat:@"交易笔数：%d",count];
    _timeLabel.text = [NSString stringWithFormat:@"%@-%@",start,end];
    _typeLabel.text = [NSString stringWithFormat:@"%@",[self tradeTypeWithIndex:_tradeType]];
    [_tableView reloadData];
}

- (NSString *)tradeTypeWithIndex:(int)index{
    NSString *tradeString = nil;;
    switch (index) {
        case TradeTypeTransfer:
            tradeString = @"转账";
            break;
        case TradeTypeConsume:
            tradeString = @"消费";
            break;
        case TradeTypeRepayment:
            tradeString = @"还款";
            break;
        case TradeTypeLife:
            tradeString = @"生活充值";
            break;
        case TradeTypeTelephoneFare:
            tradeString = @"话费充值";
            break;
        default:
            break;
    }
    return tradeString;
}

//将yyyy-MM-dd格式改成yyyy/MM/dd
- (NSString *)transformDateStringWithStrting:(NSString *)string {
    NSMutableString *primaryString = [NSMutableString stringWithString:string];
    [primaryString replaceOccurrencesOfString:@"-" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [primaryString length])];
    return primaryString;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if (!delegate.hasProfit) {
        return 0;
    }
    return [_dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Profit";
    PorfitCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PorfitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ProfitModel *model = [_dataItems objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kProfitCellHeight;
}

@end
