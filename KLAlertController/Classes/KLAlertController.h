//
//  KLAlertController.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLPopUpViewController.h"
#import "NSParagraphStyle+Shortcut.h"
#import "KLAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(7_0)

//     -----------------------
//    |        ---------      |
//    |       |  title  |     |
//    |       |         |     |  <---- headerView       <-----|
//    |       | message |     |                               |
//    |        ---------      |                               | <---- contentView <-- KLPopUpViewController
//     -----------------------                                |
//    |         button1       |                               |
//    |-----------------------|  <---- actionGroupView  <-----|
//    |         button2       |
//     -----------------------

@interface KLAlertController : KLPopUpViewController

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;


+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (void)addAction:(KLAlertAction *)action;
@property (nonatomic, readonly) NSArray<KLAlertAction *> *actions;


/**
 添加一个自定义内容头视图
 
 @warning 对于KLAlertController来说，这个contentView其实就是headerView
 */
+ (instancetype)alertControllerWithContentView:(nullable UIView *)view
                                preferredStyle:(UIAlertControllerStyle)preferredStyle;
- (void)addContentView:(UIView *)view;

//! 内容区背景颜色
//! @warning 如果要支持黑暗模式，记得color要用colorWithDynamicProvider动态生成
@property (nonatomic, strong) UIColor *contentBackgroundColor;

//! 中间内容区宽度。如果是alertView，默认270；如果是actionSheet，默认为屏幕宽度-8-8，跟系统保持一致
//! 注意：如果是通过alertControllerWithContentView或者addContentView来添加内容，则contentWidth无默认值，除非手动指定
@property (nonatomic, assign) CGFloat contentWidth;

//   -----------------------
//  |        ---------      |
//  |       |  title  |     |
//  |       |         |     |
//  |       | message |     |
//  |        ---------      |
//   -----------------------

//! title和message整体所在区域离四周的距离
//! alert默认为 (20, 16, 20, 16)。当只有title或message时，上下距离分别为insets.top和insets.top，与系统一致
//! sheet默认为 (14.5, 16, 25, 16)。当只有title时，上下距离分别为insets.top和insets.top；
//! 当只有message时，上下距离分别为insets.bottom和insets.bottom，与系统一致
@property (nonatomic, assign) UIEdgeInsets titleMessageAreaContentInsets;

//! title与message竖直方向的间距
//! alert默认为 2，与系统一致
//! sheet默认为 12，与系统一致
@property (nonatomic, assign) CGFloat titleMessageVerticalSpacing;

//! actionSheet的cancelButton距离上边内容的间距，默认为8，跟系统保持一致
@property (nonatomic, assign) CGFloat sheetCancelButtonMarginTop;

//! actionSheet整体内容距离屏幕底部距离，默认为8，跟系统保持一致。注意：刘海屏会自动再加上底部安全区域高度
@property (nonatomic, assign) CGFloat sheetContentMarginBottom;

//! 标题相关属性
@property(nonatomic, strong) NSDictionary<NSString *, id> *titleAttributes;
//! message相关属性
@property(nonatomic, strong) NSDictionary<NSString *, id> *messageAttributes;
//! 按钮相关属性
// 按钮高度。alert默认44.0，sheet默认57.0，跟系统保持一致
@property (nonatomic, assign) CGFloat actionButtonHeight;

/*
 Alert:
 @{NSForegroundColorAttributeName: [UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0],
 NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:17]};
 
 ActionSheet:
 @{NSForegroundColorAttributeName: [UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0],
 NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:20]};
 
 @warning 如果要支持黑暗模式，记得NSForegroundColorAttributeName的方法要用colorWithDynamicProvider动态生成
 */
@property(nonatomic, strong) NSDictionary<NSString *, id> *defaultButtonAttributes;

/*
 Alert:
 @{NSForegroundColorAttributeName: [UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0],
 NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:17]};
 
 ActionSheet:
 @{NSForegroundColorAttributeName: [UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0],
 NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:20]};
 
 @warning 如果要支持黑暗模式，记得NSForegroundColorAttributeName的方法要用colorWithDynamicProvider动态生成
 */
@property(nonatomic, strong) NSDictionary<NSString *, id> *cancelButtonAttributes;

/*
 Alert:
 @{NSForegroundColorAttributeName: [UIColor redColor],
 NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:17]};
 
 ActionSheet:
 @{NSForegroundColorAttributeName: [UIColor redColor],
 NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:20]};
 
 @warning 如果要支持黑暗模式，记得NSForegroundColorAttributeName的方法要用colorWithDynamicProvider动态生成
 */
@property(nonatomic, strong) NSDictionary<NSString *, id> *destructiveButtonAttributes;

//! 圆角值、默认12.0，与系统一致
@property (nonatomic, assign) CGFloat cornerRadius;

//! 线的宽度，默认1px
@property (nonatomic, assign) CGFloat lineHeight;
//! 线的颜色，
//! @warning 如果要支持黑暗模式，记得color要用colorWithDynamicProvider动态生成
@property (nonatomic, strong) UIColor *lineColor;

@end

NS_ASSUME_NONNULL_END
