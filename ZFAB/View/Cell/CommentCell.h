//
//  CommentCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

#define kNormalHeight 85.f

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSString *content;

- (id)initWithContent:(NSString *)content
      reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCommentData:(CommentModel *)model;

@end
