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

#define kAddressCellHeight 90.f

@interface AddressCell : UITableViewCell

@property (nonatomic, strong) UILabel *receiveLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *defaultLabel;

@property (nonatomic, strong) UIImageView *selectedImageView;

- (void)setAddressDataWithModel:(AddressModel *)addressModel;

@end
