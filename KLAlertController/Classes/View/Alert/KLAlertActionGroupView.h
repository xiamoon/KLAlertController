//
//  KLAlertActionGroupView.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KLAlertAction;
@interface KLAlertActionGroupView : UIView

- (void)addAction:(KLAlertAction *)action;

- (BOOL)layoutActions;

@property (nonatomic, strong, readonly) NSArray<KLAlertAction *> *actions;

@property (nonatomic, strong) void (^klAlertActionButtonHandler)(KLAlertAction *action);

//MARK: 按钮相关属性
// alert默认44.0，sheet默认57.0，跟系统保持一致
@property (nonatomic, assign) CGFloat actionButtonHeight;

@property(nonatomic, strong) NSDictionary<NSString *, id> *defaultButtonAttributes;
@property(nonatomic, strong) NSDictionary<NSString *, id> *cancelButtonAttributes;
@property(nonatomic, strong) NSDictionary<NSString *, id> *destructiveButtonAttributes;

//! 线的宽度，默认1px
@property (nonatomic, assign) CGFloat lineHeight;
//! 线的颜色，
@property (nonatomic, strong) UIColor *lineColor;

@end

NS_ASSUME_NONNULL_END
