//
//  CommonViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "MobClick.h"

static NSDictionary *s_mappingPlist = nil;

@interface CommonViewController ()

@end

@implementation CommonViewController

- (NSDictionary *)getMappingDictionary {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MappingPlist" ofType:@"plist"];
        NSDictionary *mappingDict = [NSDictionary dictionaryWithContentsOfFile:path];
        s_mappingPlist = [mappingDict objectForKey:@"Mapping"];
    });
    return s_mappingPlist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleDone
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *pageKey = [[self getMappingDictionary] objectForKey:NSStringFromClass(self.class)];
    NSLog(@"++++++++++++++++++++++++++++++++++++++++%@",pageKey);
    if (pageKey) {
        [MobClick beginLogPageView:pageKey];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSString *pageKey = [[self getMappingDictionary] objectForKey:NSStringFromClass(self.class)];
    NSLog(@"========================================%@",pageKey);
    if (pageKey) {
        [MobClick endLogPageView:pageKey];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

//监听事件  子类重写
- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {

}

- (void)handleKeyboardDidHidden {

}

@end
