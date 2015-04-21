//
//  BenefitCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "BenefitCell.h"

@implementation BenefitCell

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
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 38, 10, 24, 24);
    [deleteBtn setBackgroundImage:kImageName(@"deleteblue.png") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteChannel:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    
    UIImageView *vLine = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 8, 1, 28)];
    vLine.image = kImageName(@"gray.png");
    [self.contentView addSubview:vLine];
}

#pragma mark - Action

- (IBAction)deleteChannel:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(benefitCellDeleteChannel:)]) {
        [_delegate benefitCellDeleteChannel:_benefitModel];
    }
}

@end
