//
//  ProtocolView.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/5/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProtocolAgreeDelegate;

@interface ProtocolView : UIView

@property (nonatomic, assign) id<ProtocolAgreeDelegate>delegate;

@property (nonatomic, strong) UIView *panelView;

@property (nonatomic, strong) UIView *markView;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) NSString *content;

- (id)initWithFrame:(CGRect)frame string:(NSString *)content;

@end

@protocol ProtocolAgreeDelegate <NSObject>

- (void)protocolView:(ProtocolView *)view agreeProtocolWithStatus:(BOOL)isSelected;

@end
