//
//  KLPopUpViewController.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLAlertControllerConstant.h"
#import "UIColor+KLDarkMode.h"

NS_ASSUME_NONNULL_BEGIN

// 弹框显示优先级：高优先级的弹窗会优先显示，显示时会暂时移除同优先级和低优先级的弹窗。低优先级的弹窗在显示时不会移除高优先级的弹窗
typedef NSInteger KLPopUpControllerPriority;

static const KLPopUpControllerPriority KLPopUpControllerPriorityRequired = 1000;
static const KLPopUpControllerPriority KLPopUpControllerPriorityDefault = 750;
static const KLPopUpControllerPriority KLPopUpControllerPriorityLow = 250;

typedef NS_ENUM(NSInteger, KLPopUpControllerMaskType) {
    // maskView背景为普通颜色背景
    KLPopUpControllerMaskTypeDefault = 0,
    // maskView背景为高斯模糊效果
    KLPopUpControllerMaskTypeVisualEffect = 1,
};

NS_CLASS_AVAILABLE_IOS(7_0)

@interface KLPopUpViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (instancetype)initWithContentView:(nullable UIView *)contentView
                     preferredStyle:(UIAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithContentView:(nullable UIView *)contentView
                             preferredStyle:(UIAlertControllerStyle)preferredStyle;
- (void)addContentView:(UIView *)contentView;

@property (nonatomic, assign) UIAlertControllerStyle preferredStyle;
@property (nonatomic, strong, readonly) UIView *contentView;

#pragma mark - Show。不建议用presentViewController:animated:completion:的方式弹出，否则无法支持多个弹框同时弹出的效果。建议后期适配。
- (void)kl_show;
- (void)kl_showWithAnimated:(BOOL)animated;
- (void)kl_showWithAnimated:(BOOL)animated
                 completion:(nullable void(^)(void))completionHandler;

#pragma mark - Dismiss
- (void)kl_dismiss;
- (void)kl_dismissWithAnimated:(BOOL)animated;
- (void)kl_dismissWithAnimated:(BOOL)animated
                 completion:(nullable void(^)(void))completionHandler;

@property (nonatomic, copy) void (^dismissCompletion)(void);
@property (nonatomic, copy) void (^viewDidLayoutSubviewsBlock)(void);

//! 弹出视图的唯一id，默认是一个UUID String。
//! 默认情况下，同时弹出多个弹框时，弹框之间是互斥的，后面的弹框显示时会暂时移除前一个弹框。当后面的弹框消失后，前面被移除的弹框会再次显示出来。
//! 如果弹出多个弹框时，指定他们的identifier一样，则前面的弹框会被永久性移除，不会再显示。
@property (nonatomic, strong) NSString *identifier;

//! 中间内容区宽度。默认为0，由conteView自身frame或者autoLayout计算的宽度决定，也可以手动指定宽度。
@property (nonatomic, assign) CGFloat contentWidth;

//! 中间内容区最大高度。默认为ScreenHeight-2*MAX(safeArea.top, safeArea.bottom)，实际高度由内部视图本身的高度决定。
//! 注意：内部实际计算时，如果是sheet还会多减去sheetContentMarginBottom的高度。所以外部指定时，不用考虑sheetContentMarginBottom的高度。
@property (nonatomic, assign) CGFloat contentMaximumHeightForPortrait;
@property (nonatomic, assign) CGFloat contentMaximumHeightForLandscape;

- (void)setContentMaximumHeight:(CGFloat)contentMaximumHeight;

//! actionSheet整体内容距离屏幕底部距离，默认为0。注意：刘海屏会自动再加上底部安全区域高度
@property (nonatomic, assign) CGFloat sheetContentMarginBottom;

//! 是否自动为actionSheet添加底部安全距离，默认为为YES。
@property (nonatomic, assign) BOOL shouldAutoAddBottomSafePaddingForActionSheet;

//! maskView是否可以响应dismiss手势。默认alert不响应，sheet响应
@property (nonatomic, assign) BOOL shouldRespondsMaskViewTouch;

// maskView的背景模式
@property (nonatomic, assign) KLPopUpControllerMaskType maskType;

//! maskView背景色。
@property (nonatomic, strong) UIColor *maskBackgroundColor;

//! 弹框出现的顺序：
//! 假设同时需要弹出2个弹框，第一个弹框优先级更高，那么第一个出现的弹框不会被后面的弹框遮挡。只有当第一个弹框消失后，第二个弹框才会显示。
//! 假设同时需要弹出2个弹框，第一个弹框优先级更低，那么第二个弹框会遮挡第一个弹框。只有当第二个弹框消失后，，第一个弹框才会显示。
@property (nonatomic, assign) KLPopUpControllerPriority showPriority;

#pragma mark - 动画时间
//! 弹出时间
@property (nonatomic, assign) CGFloat presentDelayTimeInterval;
@property (nonatomic, assign) CGFloat presentTimeInterval;
//! 消失时间
@property (nonatomic, assign) CGFloat dismissDelayTimeInterval;
@property (nonatomic, assign) CGFloat dismissTimeInterval;

#pragma mark - 暗黑模式适配
+ (void)setUserInterfaceStyle:(UIUserInterfaceStyle)userInterfaceStyle
                     animated:(BOOL)animated
                     duration:(CGFloat)duration API_AVAILABLE(ios(13.0));

#pragma mark - Override
//! 屏幕方向发生变化时，子类可以重载
- (void)deviceOrientationWillChangeWithContentMaximumHeight:(CGFloat)contentMaximumHeight
                                                   duration:(NSTimeInterval)duration;
@end



@interface UIViewController (KLAlertController)

//! 判断当前是否有弹框显示
- (BOOL)isKLAlertControllerCurrentShowed;

//! 通过identifier移除指定alertController
- (void)removeKLAlertControllerWithIdentifier:(NSString *)identifier
                                      animated:(BOOL)animated
                                    completion:(nullable void(^)(void))completion;

//! 移除当前显示的和暂时隐藏在栈区的所有alertController
- (void)removeAllKLAlertConrollerAnimated:(BOOL)animated
                                completion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
