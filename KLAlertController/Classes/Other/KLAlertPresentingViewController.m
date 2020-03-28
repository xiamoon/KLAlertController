//
//  KLAlertPresentingViewController.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertPresentingViewController.h"
#import "KLPopUpViewController.h"
#import "KLAlertSingleton.h"

NSString * const KLPOPUPCONTROLLER_USERINTERFACESTYPE_KEY = @"com.kl.popUpController.userInterfaceStyle.key";

@interface KLPopUpControllerModel : NSObject
@property (nonatomic, strong) KLPopUpViewController *popUpController;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong, nullable) void(^completion)(void);
@end

@implementation KLPopUpControllerModel

- (BOOL)isEqual:(id)object {
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (object == self) {
        return YES;
    }
    
    KLPopUpControllerModel *popUpModel = (KLPopUpControllerModel *)object;
    return [popUpModel.popUpController isEqual:self.popUpController];
}

@end


@interface KLAlertPresentingViewController ()
@property (nonatomic, strong) UIWindow *window;

@property (atomic, assign, readonly) BOOL isAnimating;
@property (atomic, assign) BOOL isPresenting;
@property (atomic, assign) BOOL isDismissing;

@property (nonatomic, strong) NSMutableArray<KLPopUpControllerModel *> *popUpStack;
@end

@implementation KLAlertPresentingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIWindow *window = nil;
#ifdef __IPHONE_13_0
        if (@available(iOS 13, *)) {
            window = [[UIWindow alloc] initWithWindowScene:UIApplication.sharedApplication.keyWindow.windowScene];
            
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            
            NSNumber *userInterfaceStyleNum = [userdefaults valueForKey:KLPOPUPCONTROLLER_USERINTERFACESTYPE_KEY];
            
            UIUserInterfaceStyle userInterfaceStyle = userInterfaceStyleNum ? userInterfaceStyleNum.integerValue : UIUserInterfaceStyleUnspecified;
            [window setOverrideUserInterfaceStyle:userInterfaceStyle];
        } else {
            window = [[UIWindow alloc] init];
        }
#else
        window = [[UIWindow alloc] init];
#endif
        window.backgroundColor = [UIColor clearColor];
        window.frame = [UIScreen mainScreen].bounds;
        window.windowLevel = UIWindowLevelAlert;
        self.window = window;

        self.popUpStack = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public
- (void)kl_presentPopUpViewController:(KLPopUpViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion {
    
    if (viewControllerToPresent == nil) {
        if (completion) completion();
        [self checkToPresentNextPopUpController];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if (self.window.isHidden == YES) {
        self.window.rootViewController = weakSelf;
        self.window.hidden = NO;
    }
    
    if (self.isAnimating) { // 如果正在进行跳转或消失的动画，则移入pending中
        KLPopUpControllerModel *model = [self createModelWith:viewControllerToPresent animated:flag completion:completion];
        [self addToStackWithModel:model];
        return;
    }
    
    if (self.presentedViewController) { // 当前屏幕上有已经显示的alert
        
        KLPopUpViewController *presentedViewController = (KLPopUpViewController *)self.presentedViewController;
        
        if ([viewControllerToPresent isEqual:presentedViewController]) {
            
            if (completion) completion();
            [self checkToPresentNextPopUpController];
            return;
        }
        
        KLPopUpControllerModel *model = [self createModelWith:viewControllerToPresent animated:flag completion:completion];
        [self addToStackWithModel:model];
        
        if (viewControllerToPresent.showPriority >= presentedViewController.showPriority) {
            
            // 暂时隐藏当前的，并弹出新的
            [self _kl_dismissPopUpViewController:presentedViewController animated:NO completion:nil];
        } else {

            if (completion) completion();
            [self checkToPresentNextPopUpController];
        }
        
    } else { // 当前没有正在显示的alert
        
        KLPopUpControllerModel *model = [self createModelWith:viewControllerToPresent animated:flag completion:completion];
        [self addToStackWithModel:model];
        
        self.isPresenting = YES;

        [self presentViewController:viewControllerToPresent animated:flag completion:^{
            
            self.isPresenting = NO;
            
            if (completion) completion();
            [self checkToPresentNextPopUpController];
        }];
    }
}

- (void)kl_dismissPopUpViewController:(KLPopUpViewController *)viewControllerToDismiss
                             animated:(BOOL)flag
                           completion:(nullable void(^)(void))completion {
    
    if (!viewControllerToDismiss) {
        if (completion) completion();
        return;
    }
    
    [self removeFromStackWithController:viewControllerToDismiss];

    // 确保相同的vc不会同时被调用系统的dismiss方法多次
    if (self.isAnimating) { // 当前的self.presentedViewController正在present或者dismiss
        if (completion) completion();
        return;
    }
    
    if ([viewControllerToDismiss isEqual:self.presentedViewController]) {
        [self _kl_dismissPopUpViewController:viewControllerToDismiss animated:flag completion:completion];
    } else {
        if (completion) completion();
    }
}

- (void)_kl_dismissPopUpViewController:(KLPopUpViewController *)viewControllerToDismiss
                              animated:(BOOL)flag
                            completion:(nullable void(^)(void))completion {
    self.isDismissing = YES;
    
    [viewControllerToDismiss dismissViewControllerAnimated:flag completion:^{
        
        self.isDismissing = NO;
        
        if (completion) completion();
        
        [self checkToPresentNextPopUpController];
    }];
}

- (BOOL)kl_isAlertControllerCurrentShowed {
    return (self.presentedViewController != nil);
}

- (void)kl_removeAlertControllerWithIdentifier:(NSString *)identifier
                                     animated:(BOOL)animated
                                   completion:(nullable void (^)(void))completion {
    
    __block KLPopUpViewController *viewControllerToRemove = nil;
    [self.popUpStack enumerateObjectsUsingBlock:^(KLPopUpControllerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.popUpController.identifier isEqualToString:identifier]) {
            viewControllerToRemove = obj.popUpController;
            *stop = YES;
        }
    }];
    
    [self kl_dismissPopUpViewController:viewControllerToRemove animated:animated completion:completion];
}

- (void)kl_removeAllAlertControllerAnimated:(BOOL)animated
                                completion:(nullable void (^)(void))completion {
    
    [self.popUpStack removeAllObjects];
    
    if (self.presentedViewController) {
        [self kl_dismissPopUpViewController:(KLPopUpViewController *)self.presentedViewController animated:animated completion:completion];
    } else {
        [self clearUpResource];
        if (completion) completion();
    }
}

- (void)setUserInterfaceStyle:(UIUserInterfaceStyle)userInterfaceStyle animated:(BOOL)animated duration:(CGFloat)duration {
    
    if (@available(iOS 13, *)) {
        [_window setOverrideUserInterfaceStyle:userInterfaceStyle];
        
        if (animated) {
            [self addTransitionForUserInterfaceStyleChangedDuration:duration];
        }
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setValue:@(userInterfaceStyle) forKey:KLPOPUPCONTROLLER_USERINTERFACESTYPE_KEY];
        [userdefaults synchronize];
    }
}

#pragma mark - Private.
// 检查是否还有下一个popUpController可以弹出
- (void)checkToPresentNextPopUpController {
    
    if (self.popUpStack.count == 0) {
        [self kl_removeAllAlertControllerAnimated:NO completion:nil];
        return;
    }
    
    KLPopUpControllerModel *lastModel = self.popUpStack.lastObject;

    if (self.presentedViewController) { // 如果当前popUpController已被presented
        
        // 如果当前popUpController不是popUpStack中的最后一个，则需要寻找最后一个并弹出
        if ([self.presentedViewController isEqual:lastModel.popUpController] == NO) {
            
            KLPopUpViewController *presentedViewController = (KLPopUpViewController *)self.presentedViewController;
            
            // 如果当前popUpController的优先级小于等于popUpStack中最后一个的优先级
            if (lastModel.popUpController.showPriority >= presentedViewController.showPriority) {
                [self kl_presentPopUpViewController:lastModel.popUpController animated:lastModel.animated completion:lastModel.completion];

            } else {
                // 如果当前popUpController不是popUpStack中的最后一个，但是其优先级却大于popUpStack中最后一个的优先级。
                // 该情况比较特殊，即当前popUpController在弹出的动画过程中被kl_dismiss了，那么此时，当前popUpController并不在popUpStack中
                [self kl_dismissPopUpViewController:presentedViewController animated:NO completion:nil];
            }
        } else { // 如果当前popUpController就是popUpStack中的最后一个，则没有需要弹出的
            
        }
    } else { // 如果当前popUpController已被dismiss
        [self kl_presentPopUpViewController:lastModel.popUpController animated:lastModel.animated completion:lastModel.completion];
    }
}

- (BOOL)isAnimating {
    return (self.isPresenting || self.isDismissing);
}

- (void)removeFromStackWithController:(KLPopUpViewController *)popUpViewController {
    [self.popUpStack enumerateObjectsUsingBlock:^(KLPopUpControllerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.popUpController isEqual:popUpViewController]) {
            [self.popUpStack removeObject:obj];
        }
    }];
}
 
- (void)addToStackWithModel:(KLPopUpControllerModel *)popUpModel {
    if ([self.popUpStack containsObject:popUpModel]) {
        [self.popUpStack removeObject:popUpModel];
    }
    [self.popUpStack addObject:popUpModel];
    
    // 升序排序
    [self.popUpStack sortUsingComparator:^NSComparisonResult(KLPopUpControllerModel *obj1, KLPopUpControllerModel *obj2) {
        if (obj2.popUpController.showPriority >= obj1.popUpController.showPriority) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

- (KLPopUpControllerModel *)createModelWith:(KLPopUpViewController *)popUpController
                                animated:(BOOL)animated
                              completion:(nullable void(^)(void))completion {
    KLPopUpControllerModel *model = [[KLPopUpControllerModel alloc] init];
    model.popUpController = popUpController;
    model.animated = animated;
    model.completion = completion;
    return model;
}

- (void)addTransitionForUserInterfaceStyleChangedDuration:(CGFloat)duration {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    [_window.layer addAnimation:animation forKey:nil];
}

- (void)clearUpResource {
    [self.popUpStack removeAllObjects];
    self.popUpStack = nil;
    self.window.rootViewController = nil;
    self.window.hidden = YES;
    [[KLAlertSingleton sharedInstance] destoryKLAlertSingleton];
}

- (void)dealloc {
    _window = nil;
    NSLog(@"KLAlertPresentingViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end

