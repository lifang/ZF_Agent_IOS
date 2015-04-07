//
//  RecordView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface RecordView : UIView

@property (nonatomic, strong) NSArray *recordItems;

@property (nonatomic, assign) CGFloat width;

- (id)initWithRecords:(NSArray *)records
                width:(CGFloat)width;

- (CGFloat)getHeight;

- (void)initAndLayoutUI;

@end
