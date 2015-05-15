//
//  AddressCell.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"
#import "AddressModel.h"
#import "MultipleDeleteCell.h"

#define kAddressCellHeight 90.f

@interface AddressCell : MultipleDeleteCell

@property (nonatomic, strong) UILabel *receiveLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *defaultLabel;

@property (nonatomic, strong) UIImageView *selectedImageView;

@property (nonatomic, strong) NSLayoutConstraint *originYConstraint;

- (void)setAddressDataWithModel:(AddressModel *)addressModel;

- (void)updateDefaultLayout;

@end
