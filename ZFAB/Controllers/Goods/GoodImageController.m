//
//  GoodImageController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/5/15.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodImageController.h"
#import "NetworkInterface.h"
#import "UIImageView+WebCache.h"

#define kGoodImageViewTag  130

@interface GoodImageModel : NSObject

@property (nonatomic, strong) NSString *imageID;

@property (nonatomic, strong) NSString *imageURL;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

@implementation GoodImageModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _imageID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"urlPath"]) {
            _imageURL = [NSString stringWithFormat:@"%@",[dict objectForKey:@"urlPath"]];
        }
    }
    return self;
}

@end

@interface GoodImageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imageList;

@property (nonatomic, strong) NSMutableArray *imageSizeArray;

@end

@implementation GoodImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"图文详情";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    _imageList = [[NSMutableArray alloc] init];
    _imageSizeArray = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self getGoodImageList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
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
}

#pragma mark - Request

- (void)getGoodImageList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getGoodImageWithGoodID:_goodID finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseDataWithDictionary:object];
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

- (void)parseDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_imageList removeAllObjects];
    NSArray *list = [dict objectForKey:@"result"];
    for (int i = 0; i < [list count]; i++) {
        id imageDict = [list objectAtIndex:i];
        if ([imageDict isKindOfClass:[NSDictionary class]]) {
            GoodImageModel *model = [[GoodImageModel alloc] initWithParseDictionary:imageDict];
            [_imageList addObject:model];
            
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            if ([imageCache diskImageExistsWithKey:model.imageURL]) {
                
                UIImage *image = [imageCache imageFromDiskCacheForKey:model.imageURL];
                CGSize size = image.size;
                [_imageSizeArray addObject:[NSValue valueWithCGSize:size]];
                
            } else
            {
                NSString *imageURL = [NSString stringWithFormat:@"%@",model.imageURL];
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                [[SDImageCache sharedImageCache] storeImage:image forKey:model.imageURL];
                CGSize size = image.size;
                [_imageSizeArray addObject:[NSValue valueWithCGSize:size]];
                
            }

        }
    }
    [_tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_imageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = [NSString stringWithFormat:@"ImageIdentifier%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    CGSize size = [[_imageSizeArray objectAtIndex:indexPath.row] CGSizeValue];
    CGFloat HHH = size.height;
    CGFloat WWW = size.width;
    CGFloat Chight = HHH/WWW * kScreenWidth;

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, Chight)];
        imageView.tag = kGoodImageViewTag;
        [cell.contentView addSubview:imageView];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kGoodImageViewTag];
    GoodImageModel *model = [_imageList objectAtIndex:indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_imageSizeArray == nil) {
        return 44;
    }
    else
    {
        CGSize size = [[_imageSizeArray objectAtIndex:indexPath.row] CGSizeValue];
        CGFloat bilv = size.width*1.0/kScreenWidth;
        CGFloat Chight =  size.height/bilv;
        return Chight;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
