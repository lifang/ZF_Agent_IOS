//
//  AddressCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = 20.f;
    CGFloat imageSize = 18.f;
    CGFloat labelHeight = 20.f;
    CGFloat defautlWidth = 40.f;
    _selectedImageView = [[UIImageView alloc] init];
    _selectedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _selectedImageView.image = kImageName(@"btn_selected.png");
    [self.contentView addSubview:_selectedImageView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:30.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    _defaultLabel = [[UILabel alloc] init];
    _defaultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _defaultLabel.backgroundColor = [UIColor clearColor];
    _defaultLabel.font = [UIFont systemFontOfSize:10.f];
    _defaultLabel.textAlignment = NSTextAlignmentCenter;
    _defaultLabel.textColor = kMainColor;
    _defaultLabel.text = @"【默认】";
    [self.contentView addSubview:_defaultLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_defaultLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_selectedImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:2.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_defaultLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_defaultLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.0
                                                                  constant:defautlWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_defaultLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //收件人
    _receiveLabel = [[UILabel alloc] init];
    _receiveLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _receiveLabel.backgroundColor = [UIColor clearColor];
    _receiveLabel.font = [UIFont boldSystemFontOfSize:15.f];
    _receiveLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_receiveLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_receiveLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_receiveLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:defautlWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_receiveLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_receiveLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //地址
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.font = [UIFont systemFontOfSize:14.f];
    _addressLabel.numberOfLines = 2;
    [self.contentView addSubview:_addressLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_receiveLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:defautlWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:36.f]];
}

#pragma mark - Data

- (void)setAddressDataWithModel:(AddressModel *)addressModel {
    if ([addressModel.isDefault intValue] == AddressDefault) {
        _defaultLabel.hidden = NO;
    }
    else {
        _defaultLabel.hidden = YES;
    }
    NSString *receiver = [NSString stringWithFormat:@"收件人：%@",addressModel.addressReceiver];
    NSString *totalString = [NSString stringWithFormat:@"%@   %@",receiver,addressModel.addressPhone];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSDictionary *receiverAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont boldSystemFontOfSize:15.f],NSFontAttributeName,
                                  nil];
    NSDictionary *phoneAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont systemFontOfSize:14],NSFontAttributeName,
                               nil];
    [attrString addAttributes:receiverAttr range:NSMakeRange(0, [receiver length])];
    [attrString addAttributes:phoneAttr range:NSMakeRange([receiver length], [attrString length] - [receiver length])];
    _receiveLabel.attributedText = attrString;
    _addressLabel.text = [NSString stringWithFormat:@"收件地址：%@",addressModel.address];
}

@end
