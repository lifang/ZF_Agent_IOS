//
//  AfterSaleView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/***********售后按钮***********/

typedef enum {
    AfterSaleNone = 0,
    ///售后单记录
    AfterSaleBill,
    ///更新资料记录
    AfterSaleUpdate,
    ///注销记录
    AfterSaleCancel,
}AfterSaleTag;

#import <UIKit/UIKit.h>

@interface AfterSaleView : UIButton

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *titleName;

- (void)setTitleName:(NSString *)titleName
           imageName:(NSString *)imageName;

@end
