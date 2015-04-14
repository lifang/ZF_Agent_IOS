//
//  TerminalBottomView.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TerminalBottomDelegate <NSObject>

- (void)selectedAllTerminal:(BOOL)isSelected;

@end

@interface TerminalBottomView : UIView

@property (nonatomic, assign) id<TerminalBottomDelegate>delegate;

@property (nonatomic, strong) UIButton *selectedButton;
//全选文字 颜色根据是否选中变化
@property (nonatomic, strong) UILabel *selectedLabel;

@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) UIButton *finishButton;

- (void)setSelectedStatus:(BOOL)select;

@end
