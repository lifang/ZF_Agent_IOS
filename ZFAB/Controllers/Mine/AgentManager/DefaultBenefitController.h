//
//  DefaultBenefitController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

@protocol UpdateDefaultBenefitDelegate <NSObject>

- (void)getNewDefaultBenefit:(CGFloat)newBenefit;

@end

@interface DefaultBenefitController : CommonViewController

@property (nonatomic, assign) CGFloat benefit;

@property (nonatomic, assign) id<UpdateDefaultBenefitDelegate>delegate;

@end
