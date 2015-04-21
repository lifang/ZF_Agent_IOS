//
//  BenefitCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BenefitModel.h"

@protocol BenefitCellDelegate <NSObject>

- (void)benefitCellDeleteChannel:(BenefitModel *)benefitModel;

@end

@interface BenefitCell : UITableViewCell

@property (nonatomic, assign) id<BenefitCellDelegate>delegate;

@property (nonatomic, strong) BenefitModel *benefitModel;

@end
