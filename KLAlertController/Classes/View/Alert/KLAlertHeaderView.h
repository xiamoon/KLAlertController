//
//  KLAlertHeaderView.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLAlertHeaderView : UIView

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message;

//! 标题相关属性
@property(nonatomic, strong) NSDictionary<NSString *, id> *titleAttributes;
//! message相关属性
@property(nonatomic, strong) NSDictionary<NSString *, id> *messageAttributes;

//! title所在文本区域离四周的距离
@property (nonatomic, assign) UIEdgeInsets titleMessageAreaContentInsets;
//! title和message竖直方向的间距
@property (nonatomic, assign) CGFloat titleMessageVerticalSpacing;

#pragma mark - Override.
- (void)layoutTitleAndMessage:(NSArray<UIView *> *)subviews;

@end

NS_ASSUME_NONNULL_END
