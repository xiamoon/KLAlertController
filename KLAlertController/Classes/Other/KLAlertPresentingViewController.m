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

@interface KLAlertPresentingViewController ()
@property (nonatomic, strong) UIWindow *window;

@property (atomic, assign) BOOL isAnimating;
@property (nonatomic, strong) KLPopUpViewController *currentPrentedVc;
// 已经弹出过的KLPopUpViewController的栈
@property (nonatomic, strong) NSMutableArray<KLPopUpViewController *> *alertedStack;
// 将要弹出的KLPopUpViewController，来不及弹出的KLPopUpViewController都会被放在这个数组里
@property (nonatomic, strong) NSMutableArray<KLPendingPopUpModel *> *pendingStack;
@end

@implementation KLAlertPresentingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                
        UIWindow *window = nil;
#ifdef __IPHONE_13_0
        if (@available(iOS 13, *)) {
            window = [[UIWindow alloc] initWithWindowScene:UIApplication.sharedApplication.keyWindow.windowScene];
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
        
        self.isAnimating = NO;
        self.alertedStack = [NSMutableArray array];
        self.pendingStack = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public
- (void)kl_presentPopUpViewController:(KLPopUpViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion {
    
    __weak typeof(self) weakSelf = self;
    if (self.window.isHidden == YES) {
        self.window.rootViewController = weakSelf;
        self.window.hidden = NO;
    }
    
    if (self.isAnimating == YES) { // 如果正在进行跳转/消失动画，移入pending中
        KLPendingPopUpModel *model = [[KLPendingPopUpModel alloc] init];
        model.popController = viewControllerToPresent;
        model.animated = flag;
        model.completion = completion;
        if (viewControllerToPresent.showPriority == KLPopUpControllerPriorityDefault) {
            [self insertToPendingWith:model atIndex:0];
        } else {
            [self addToPendingWith:model];
        }
        return;
    }
    
    if (self.currentPrentedVc) { // 当前屏幕上有正在显示的alert
        if ([self.currentPrentedVc.identifier isEqualToString:viewControllerToPresent.identifier]) {
            if (completion) completion();
            
            return;
        }
        
        if (viewControllerToPresent.showPriority == KLPopUpControllerPriorityDefault) { // 暂时隐藏旧的，弹出新的
            self.isAnimating = YES;
            // 注意：这里不能调用kl_dismiss方法，因为这会触发下面"pop消失回调"的那两个方法。
            [self.currentPrentedVc dismissViewControllerAnimated:NO completion:^{
                self.isAnimating = NO;
                self.currentPrentedVc = nil;
                [self kl_presentPopUpViewController:viewControllerToPresent animated:flag completion:completion];
            }];
        } else if (viewControllerToPresent.showPriority == KLPopUpControllerPriorityLow) { // 旧的不隐藏，新的暂存
            [self insertToStackWith:viewControllerToPresent atIndex:0];
        }
    } else { // 当前没有正在显示的alert
        self.isAnimating = YES;
        // 注意：这里不能调用kl_presentPopUpViewController方法，否则会进入死循环。
        [self presentViewController:viewControllerToPresent animated:flag completion:^{
            [self addToStackWith:viewControllerToPresent];
            
            self.currentPrentedVc = viewControllerToPresent;
            self.isAnimating = NO;
            
            if (completion) completion();
            
            [self checkToPresentPendingPopUpController];
        }];
    }
}

- (BOOL)kl_isAlertControllerCurrentShowed {
    return (self.currentPrentedVc != nil);
}

- (void)kl_removeAlertConrollerWithIdentifier:(NSString *)identifier
                                     animated:(BOOL)animated
                                   completion:(nullable void (^)(void))completion {
    if (self.currentPrentedVc && [self.currentPrentedVc.identifier isEqualToString:identifier]) {
        [self.currentPrentedVc kl_dismissWithAnimated:animated completion:completion];
    }else {
        [self removeEqualVcFromStackWithIdentifier:identifier];
        
        if (completion) completion();
    }
}

- (void)kl_removeAllAlertConrollerAnimated:(BOOL)animated
                                completion:(nullable void (^)(void))completion {
    if (self.currentPrentedVc) {
        [self.alertedStack removeAllObjects];
        [self.currentPrentedVc kl_dismissWithAnimated:animated completion:^{
            if (completion) completion();
        }];
    }else {
        self.window.rootViewController = nil;
        self.window.hidden = YES;
        [[KLAlertSingleton sharedInstance] destoryKLAlertSingleton];
        if (completion) completion();
    }
}

#pragma mark - pop消失回调
//! 注意：只有调用kl_dismissWithAnimated:方法才会有下面两个回调，
//! 而调用系统的dismissViewControllerAnimated:不会有下面的回调
- (void)kl_popUpViewControllerWillDismiss:(KLPopUpViewController *)popUpViewController {
    self.isAnimating = YES;
    
    [self.alertedStack removeObject:popUpViewController];
}

- (void)kl_popUpViewControllerDidDismiss {
    self.currentPrentedVc = nil;
    self.isAnimating = NO;
    
    if (self.alertedStack.count == 0) {
        self.window.rootViewController = nil;
        self.window.hidden = YES;
        [[KLAlertSingleton sharedInstance] destoryKLAlertSingleton];
    }else {
        KLPopUpViewController *previousVc = self.alertedStack.lastObject;
        
        // 这里的completon不能再回调回去了，否则会重复
        // 优化：这个animated不应该写死，最好在alertedStack里也存储KLPopUpModel
        [self kl_presentPopUpViewController:previousVc animated:YES completion:^{}];
    }
}

#pragma mark - Private.
// 继续跳转到之前将要跳转的alertController
- (void)checkToPresentPendingPopUpController {
    if (self.pendingStack.count == 0) {
        return;
    }
    
    KLPendingPopUpModel *pendingPopUpModel = self.pendingStack.firstObject;
    [self kl_presentPopUpViewController:pendingPopUpModel.popController animated:pendingPopUpModel.animated completion:^{
        [self.pendingStack removeObject:pendingPopUpModel];
        
        if (pendingPopUpModel.completion) pendingPopUpModel.completion();
    }];
}

// 移除alertedStack里相同identifier的alertController
- (void)removeEqualVcFromStackWithIdentifier:(NSString *)identifier {
    for (NSInteger i = self.alertedStack.count-1; i >= 0; i --) {
        KLPopUpViewController *popUpVc = self.alertedStack[i];
        if ([popUpVc.identifier isEqualToString:identifier]) {
            [self.alertedStack removeObject:popUpVc];
        }
    }
}

- (void)addToStackWith:(KLPopUpViewController *)popUpViewController {
    if ([self.alertedStack containsObject:popUpViewController]) {
        [self removeEqualVcFromStackWithIdentifier:popUpViewController.identifier];
    }
    [self.alertedStack addObject:popUpViewController];
}

- (void)insertToStackWith:(KLPopUpViewController *)popUpViewController atIndex:(NSUInteger)index {
    if ([self.alertedStack containsObject:popUpViewController]) {
        [self removeEqualVcFromStackWithIdentifier:popUpViewController.identifier];
    }
    [self.alertedStack insertObject:popUpViewController atIndex:index];
}

- (void)addToPendingWith:(KLPendingPopUpModel *)popUpModel {
    if ([self.pendingStack containsObject:popUpModel]) {
        return;
    }
    [self.pendingStack addObject:popUpModel];
}

- (void)insertToPendingWith:(KLPendingPopUpModel *)popUpModel atIndex:(NSUInteger)index {
    if ([self.pendingStack containsObject:popUpModel]) {
        return;
    }
    [self.pendingStack insertObject:popUpModel atIndex:index];
}

- (void)logStack {
    NSLog(@">>> stack: %@", self.alertedStack);
}

- (void)logPending {
    NSLog(@">>> pending: %@\n\n", self.pendingStack);
}

- (void)log {
    [self logStack];
    [self logPending];
}

- (void)dealloc {
    self.window = nil;
    NSLog(@"KLAlertPresentingViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end


@implementation KLPendingPopUpModel

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        KLPendingPopUpModel *popUpModel = (KLPendingPopUpModel *)object;
        return [self.popController.identifier isEqualToString:popUpModel.popController.identifier];
    }
    return NO;
}

- (NSUInteger)hash {
    return self.popController.identifier.hash;
}

@end

