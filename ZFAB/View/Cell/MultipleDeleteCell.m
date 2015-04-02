//
//  MultipleDeleteCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/17.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MultipleDeleteCell.h"

@implementation MultipleDeleteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    if (self.isEditing) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
                for (UIImageView *imageView in view.subviews) {
                    if (self.isSelected) {
                        imageView.image = kImageName(@"btn_selected.png");
                    }
                    else {
                        imageView.image = kImageName(@"btn_unselected.png");
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    [super didTransitionToState:state];
}

@end
