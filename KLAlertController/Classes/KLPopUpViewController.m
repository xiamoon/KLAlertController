//
//  KLPopUpViewController.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLPopUpViewController.h"
#import "KLAlertAnimation.h"
#import "KLActionSheetAnimation.h"
#import "KLAlertSingleton.h"
#import "KLAlertPresentingViewController.h"
#import "Masonry.h"

@interface KLPopUpViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, assign) CGFloat contentMaximumHeightInset;
@property (nonatomic, strong) KLAlertBaseAnimation *animation;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation KLPopUpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = self;
        self.identifier = [NSUUID UUID].UUIDString;
        self.maskBackgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.showPriority = KLPopUpControllerPriorityDefault;
        self.maskType = KLPopUpControllerMaskTypeDefault;
    }
    return self;
}

+ (instancetype)alertControllerWithContentView:(UIView *)view
                             preferredStyle:(UIAlertControllerStyle)preferredStyle {
    KLPopUpViewController *popUpController = [[KLPopUpViewController alloc] init];
    popUpController.preferredStyle = preferredStyle;
    [popUpController addContentView:view];
    return popUpController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    
    CGFloat contentMaximumHeight = self.contentMaximumHeight;
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        contentMaximumHeight = self.contentMaximumHeight-self.sheetContentMarginBottom;
    }
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.contentWidth != 0) {
            make.width.mas_equalTo(self.contentWidth);
        }
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_lessThanOrEqualTo(contentMaximumHeight);
    }];
    [self.view layoutIfNeeded];
    self.view.bounds = self.contentView.bounds;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    !self.viewDidLayoutSubviewsBlock ?: self.viewDidLayoutSubviewsBlock();
}

#pragma mark - 监听屏幕方向变化
#ifdef __IPHONE_8_0
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGFloat safePadding = 0;
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
            safePadding = MAX(safeInsets.top, safeInsets.bottom);
        }else {
            KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
            safePadding = MAX(presentingVc.topLayoutGuide.length, presentingVc.bottomLayoutGuide.length);
        }
        if (safePadding == 0) {
            safePadding = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)?:20;
        }
        
        CGFloat newContentMaximumHeight = 0;
        if (self.contentMaximumHeightInset > 2*safePadding) {
            newContentMaximumHeight = size.height - self.contentMaximumHeightInset;
        }else {
            newContentMaximumHeight = size.height - 2*safePadding;
        }
        
        [self deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:context.transitionDuration];
    } completion:nil];
}
#else
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
    
    CGFloat safePadding = MAX(presentingVc.topLayoutGuide.length, presentingVc.bottomLayoutGuide.length);
    if (safePadding == 0) {
        safePadding = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)?:20;
    }
    
    CGFloat newContentMaximumHeight = 0;
    if (self.contentMaximumHeightInset > 2*safePadding) {
        newContentMaximumHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - self.contentMaximumHeightInset;
    }else {
        newContentMaximumHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - 2*safePadding;
    }
    
    [self deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:duration];
}
#endif



- (void)deviceOrientationWillChangeWithContentMaximumHeight:(CGFloat)contentMaximumHeight
                                                  duration:(NSTimeInterval)duration {
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        contentMaximumHeight = contentMaximumHeight-self.sheetContentMarginBottom;
    }
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_lessThanOrEqualTo(contentMaximumHeight);
    }];
    [self.view layoutIfNeeded];
    self.view.bounds = self.contentView.bounds;
    
    [self.animation deviceOrientationDidChangeDuration:duration];
}

#pragma mark - Public.
- (void)setPreferredStyle:(UIAlertControllerStyle)preferredStyle {
    _preferredStyle = preferredStyle;
    
    CGFloat safePadding = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        safePadding = MAX(safeInsets.top, safeInsets.bottom);
    }else {
        KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
        safePadding = MAX(presentingVc.topLayoutGuide.length, presentingVc.bottomLayoutGuide.length);
    }
    
    if (safePadding == 0) {
        safePadding = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)?:20;
    }
    
    if (preferredStyle == UIAlertControllerStyleAlert) {
        self.presentDelayTimeInterval = 0;
        self.presentTimeInterval = 0.25;
        self.dismissDelayTimeInterval = 0.1;
        self.dismissTimeInterval = 0.22;
        self.shouldRespondsMaskViewTouch = NO;
    }else if (preferredStyle == UIAlertControllerStyleActionSheet) {
        self.presentDelayTimeInterval = 0.1;
        self.presentTimeInterval = 0.18;
        self.dismissDelayTimeInterval = 0.1;
        self.dismissTimeInterval = 0.16;
        self.shouldRespondsMaskViewTouch = YES;
    }
    
    self.contentMaximumHeight = CGRectGetHeight([UIScreen mainScreen].bounds)-2*safePadding;
}

- (void)addContentView:(UIView *)view {
    self.contentView = view;
}

#pragma mark - Show
- (void)kl_show {
    [self kl_showWithAnimated:YES];
}

- (void)kl_showWithAnimated:(BOOL)animated {
    [self kl_showWithAnimated:animated completion:nil];
}

- (void)kl_showWithAnimated:(BOOL)animated
              completion:(nullable void(^)(void))completionHandler {
    dispatch_main_async_safe(^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window endEditing:YES];
        
        KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
        
        [presentingVc kl_presentPopUpViewController:self animated:animated completion:completionHandler];
    });
}

#pragma mark - Dismiss
- (void)kl_dismiss {
    [self kl_dismissWithAnimated:YES];
}

- (void)kl_dismissWithAnimated:(BOOL)animated {
    [self kl_dismissWithAnimated:animated completion:nil];
}

- (void)kl_dismissWithAnimated:(BOOL)animated
                 completion:(nullable void (^)(void))completionHandler {
    dispatch_main_async_safe(^{
        KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
        [presentingVc kl_popUpViewControllerWillDismiss:self];
        
        [self dismissViewControllerAnimated:animated completion:^{
            if (self.dismissCompletion) {
                self.dismissCompletion();
            }
            [presentingVc kl_popUpViewControllerDidDismiss];
            
            if (completionHandler) {
                completionHandler();
            }
        }];
    });
}

#pragma mark - UIViewControllerTransitioningDelegate.
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    KLAlertBaseAnimation *animation = self.animation;
    animation.isPresented = YES;
    return animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    KLAlertBaseAnimation *animation = self.animation;
    animation.isPresented = NO;
    return animation;
}

#pragma mark - Setter.
- (void)setContentMaximumHeight:(CGFloat)contentMaximumHeight {
    _contentMaximumHeight = contentMaximumHeight;
    _contentMaximumHeightInset =(CGRectGetHeight([UIScreen mainScreen].bounds)-contentMaximumHeight>=0)?:0;
}

- (void)setPresentDelayTimeInterval:(CGFloat)presentDelayTimeInterval {
    _presentDelayTimeInterval = presentDelayTimeInterval;
    self.animation.presentDelayTimeInterval = presentDelayTimeInterval;
}

- (void)setPresentTimeInterval:(CGFloat)presentTimeInterval {
    _presentTimeInterval = presentTimeInterval;
    self.animation.presentTimeInterval = presentTimeInterval;
}

- (void)setDismissDelayTimeInterval:(CGFloat)dismissDelayTimeInterval {
    _dismissDelayTimeInterval = dismissDelayTimeInterval;
    self.animation.dismissDelayTimeInterval = dismissDelayTimeInterval;
}

- (void)setDismissTimeInterval:(CGFloat)dismissTimeInterval {
    _dismissTimeInterval = dismissTimeInterval;
    self.animation.dismissTimeInterval = dismissTimeInterval;
}

#pragma mark - Getter.
- (KLAlertBaseAnimation *)animation {
    if (!_animation) {
        if (self.preferredStyle == UIAlertControllerStyleAlert) {
            _animation = [[KLAlertAnimation alloc] init];
        }else if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
            _animation = [[KLActionSheetAnimation alloc] init];
        }
    }
    return _animation;
}

- (CGFloat)sheetContentMarginBottom {
    CGFloat safePaddingBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        safePaddingBottom = safeInsets.bottom;
    }
    return _sheetContentMarginBottom+safePaddingBottom;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        KLPopUpViewController *popUpViewController = (KLPopUpViewController *)object;
        return [self.identifier isEqualToString:popUpViewController.identifier];
    }
    return NO;
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

- (void)dealloc {
    NSLog(@"KLPopUpViewController dealloc");
}

@end


@implementation UIViewController (KLAlertController)

- (BOOL)isKLAlertControllerCurrentShowed {
    KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
    return [presentingVc kl_isAlertControllerCurrentShowed];
}

- (void)removeKLAlertControllerWithIdentifier:(NSString *)identifier
                                      animated:(BOOL)animated
                                    completion:(nullable void (^)(void))completion {
    KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
    [presentingVc kl_removeAlertConrollerWithIdentifier:identifier animated:animated completion:completion];
}

- (void)removeAllKLAlertConrollerAnimated:(BOOL)animated
                                completion:(nullable void (^)(void))completion {
    KLAlertPresentingViewController *presentingVc = [[KLAlertSingleton sharedInstance] KLAlertPresentViewController];
    [presentingVc kl_removeAllAlertConrollerAnimated:animated completion:completion];
}

@end
