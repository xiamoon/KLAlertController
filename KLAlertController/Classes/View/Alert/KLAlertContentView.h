//
//  KLAlertContentView.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLAlertContentView : UIView

@property (nonatomic, strong, readonly) UIView *backgroundView;

//! 内容区高度
@property (nonatomic, assign) CGFloat contentMaximumHeight;
//! 圆角值
@property (nonatomic, assign) CGFloat cornerRadius;

//! 背景颜色
@property (nonatomic, strong) UIColor *backgroundViewColor;
//! 线的宽度，默认1px
@property (nonatomic, assign) CGFloat separatorHeight;
//! 线的颜色，
@property (nonatomic, strong) UIColor *separatorColor;


- (void)insertHeaderView:(nullable UIView *)headerView;
- (void)insertActionGroupView:(nullable UIView *)actionGroupView;
- (void)deviceOrientationWillChangeWithContentMaximumHeight:(CGFloat)contentMaximumHeight
                                                   duration:(NSTimeInterval)duration;

// Override.
//! 通过计算返回headerView的最大高度。通过观察系统弹框，最大高度有一定算法。
//! 需要考虑的几个点：
//! 1. 如果没有添加actionButton，则应返回self.contentMaximumHeight
//! 2. 如果有添加actionButton，要根据添加的actionButton的个数决定要在self.contentMaximumHeight的基础上减去多少。
//! 3. alert和sheet的情况不一样，因为sheet有cancelAction
- (CGFloat)headerViewMaximumHeight;

@end

NS_ASSUME_NONNULL_END
