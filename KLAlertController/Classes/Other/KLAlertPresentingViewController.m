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

@property (atomic, assign, readonly) BOOL isAnimating;
@property (atomic, assign) BOOL isPresenting;
@property (atomic, assign) BOOL isDismissing;

// 已经弹出过的KLPopUpViewController的栈
//TODO: 把Mode存进去
@property (nonatomic, strong) NSMutableArray<KLPopUpViewController *> *alertedStack;
// 将要弹出的KLPopUpViewController，来不及弹出的KLPopUpViewController都会被放在这个数组里
@property (nonatomic, strong) NSMutableArray<KLPendingPopUpModel *> *pendingStack;

@property (nonatomic, strong) NSMutableArray<KLPopUpViewController *> *popUpStack;

@end

@implementation KLAlertPresentingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIWindow *window = nil;
#ifdef __IPHONE_13_0
        if (@available(iOS 13, *)) {
            window = [[UIWindow alloc] initWithWindowScene:UIApplication.sharedApplication.keyWindow.windowScene];
#warning - dfasdfas
//            window.traitCollection.userInterfaceStyle = UIApplication.sharedApplication.keyWindow.traitCollection.userInterfaceStyle;
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

        self.alertedStack = [NSMutableArray array];
        self.pendingStack = [NSMutableArray array];
        self.popUpStack = [NSMutableArray array];
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
    
    if (self.isAnimating) { // 如果正在进行跳转或消失的动画，则移入pending中
        KLPendingPopUpModel *model = [[KLPendingPopUpModel alloc] init];
        model.popController = viewControllerToPresent;
        model.animated = flag;
        model.completion = completion;
        [self addToPendingWith:model];
        return;
    }
    
    if (self.presentedViewController) { // 当前屏幕上有正在显示的alert
        
        KLPopUpViewController *presentedViewController = (KLPopUpViewController *)self.presentedViewController;
        
        if ([viewControllerToPresent isEqual:presentedViewController]) {
            
            if (completion) completion();
            
            [self checkToPresentPendingPopUpController];
            
            return;
        }
        
        if (viewControllerToPresent.showPriority >= presentedViewController.showPriority) {
            
            [self kl_dismissPopUpViewController:presentedViewController animated:NO completion:^{
                
                [self kl_presentPopUpViewController:viewControllerToPresent animated:flag completion:completion];
            }];
            
        } else {
            [self addToStackWith:viewControllerToPresent];

            if (completion) completion();
            
            [self checkToPresentPendingPopUpController];
        }
        
    } else { // 当前没有正在显示的alert
        
        self.isPresenting = YES;
        [self addToStackWith:viewControllerToPresent];
        
        [self presentViewController:viewControllerToPresent animated:flag completion:^{
            
            self.isPresenting = NO;
            
            if (completion) completion();
            
            [self checkToPresentPendingPopUpController];
        }];
    }
}

- (void)kl_dismissPopUpViewController:(KLPopUpViewController *)viewControllerToDismiss
                             animated:(BOOL)flag
                           completion:(nullable void(^)(void))completion {
    
    // 确保相同的vc不会同时被调用系统的dismiss方法多次
    if (!viewControllerToDismiss) {
        if (completion) completion();
        return;
    }
    
    if (self.isAnimating) { // self.presentedViewController正在被present或dismiss
        if ([viewControllerToDismiss isEqual:self.presentedViewController]) {
            
        } else {
            [self removeFromStackAndPendingWith:viewControllerToDismiss];
        }
        
        if (completion) completion();
        return;
    }
    
    [self removeFromStackAndPendingWith:viewControllerToDismiss];

    if ([viewControllerToDismiss isEqual:self.presentedViewController]) {
        
        self.isDismissing = YES;
        
        [viewControllerToDismiss dismissViewControllerAnimated:flag completion:^{
            
            self.isDismissing = NO;
            
            if (completion) completion();
            
            if (self.pendingStack.count != 0) {
                [self checkToPresentPendingPopUpController];
            } else {
                if (self.alertedStack.count != 0) {
                    [self checkToPresentStackedPopUpController];
                } else {
                    [self clearUpResource];
                }
            }
        }];
    }
}

- (BOOL)kl_isAlertControllerCurrentShowed {
    return (self.presentedViewController != nil);
}

- (void)kl_removeAlertControllerWithIdentifier:(NSString *)identifier
                                     animated:(BOOL)animated
                                   completion:(nullable void (^)(void))completion {
    
    // 1.从pendingStack中移除
    [self.pendingStack enumerateObjectsUsingBlock:^(KLPendingPopUpModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.popController.identifier isEqualToString:identifier]) {
            [self.pendingStack removeObject:obj];
        }
    }];
    
    // 2.从alertedStack中移除
    __block KLPopUpViewController *viewControllerToRemove = nil;
    [self.alertedStack enumerateObjectsUsingBlock:^(KLPopUpViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier]) {
            viewControllerToRemove = obj;
            *stop = YES;
        }
    }];
    
    [self kl_dismissPopUpViewController:viewControllerToRemove animated:animated completion:completion];
}

- (void)kl_removeAllAlertControllerAnimated:(BOOL)animated
                                completion:(nullable void (^)(void))completion {
    
    [self.pendingStack removeAllObjects];
    [self.alertedStack removeAllObjects];
    
    if (self.presentedViewController) {
        // 保证在调用kl_dismissPopUpViewController时，alertedStack里存在self.presentedViewController
        [self.alertedStack addObject:(KLPopUpViewController *)self.presentedViewController];
        [self kl_dismissPopUpViewController:(KLPopUpViewController *)self.presentedViewController animated:animated completion:completion];
    } else {
        [self clearUpResource];
        if (completion) completion();
    }
}

- (BOOL)isAnimating {
    return (self.isPresenting || self.isDismissing);
}

- (void)clearUpResource {
    [self.pendingStack removeAllObjects];
    [self.alertedStack removeAllObjects];
    self.window.rootViewController = nil;
    self.window.hidden = YES;
    [[KLAlertSingleton sharedInstance] destoryKLAlertSingleton];
}

#pragma mark - Private.
#warning - 确认
// 检查并弹出之前将要跳转的alertController
- (void)checkToPresentPendingPopUpController {
    
    if (self.pendingStack.count == 0) return;
    
    __weak typeof(self) weakSelf = self;
    KLPendingPopUpModel *pendingPopUpModel = self.pendingStack.firstObject;
    [self kl_presentPopUpViewController:pendingPopUpModel.popController animated:pendingPopUpModel.animated completion:^{
        [weakSelf.pendingStack removeObject:pendingPopUpModel];
        
        if (pendingPopUpModel.completion) pendingPopUpModel.completion();
    }];
}

// 检查并弹出栈中的alertController
- (void)checkToPresentStackedPopUpController {
    
    if (self.alertedStack.count == 0) return;
    
    KLPopUpViewController *previousVc = self.alertedStack.lastObject;
    [self.alertedStack removeLastObject];
    // 注意：这里的completon不能再回调回去了，否则会重复，因为第一次弹出的时候已经回调过一次了
    // 优化：这个animated不应该写死，最好在alertedStack里也存储KLPopUpModel
    [self kl_presentPopUpViewController:previousVc animated:YES completion:nil];
}

- (void)removeFromStackAndPendingWith:(KLPopUpViewController *)popUpViewController {
    
    [self.alertedStack removeObject:popUpViewController];
    
    [self.pendingStack enumerateObjectsUsingBlock:^(KLPendingPopUpModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.popController isEqual:popUpViewController]) {
            [self.pendingStack removeObject:obj];
        }
    }];
}

- (void)addToStackWith:(KLPopUpViewController *)popUpViewController {
    
    if ([self.alertedStack containsObject:popUpViewController]) {
        [self.alertedStack removeObject:popUpViewController];
    }
    
    NSInteger inserIndex = NSNotFound; // 必须小于等于 self.alertStack.count
    inserIndex = [self recursiveFindWithArray:self.alertedStack targetController:popUpViewController];
    if (inserIndex != NSNotFound) {
        inserIndex = MIN(inserIndex, self.alertedStack.count);
    }
    [self.alertedStack insertObject:popUpViewController atIndex:inserIndex];
    
    
    [self.pendingStack sortUsingComparator:^NSComparisonResult(KLPendingPopUpModel *obj1, KLPendingPopUpModel *obj2) {
        if (obj1.popController.showPriority >= obj2.popController.showPriority) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

/// 二分法查找下标。subarrayWithRange(a, b): a <= x < (a+b)，x为下标
- (NSInteger)recursiveFindWithArray:(NSArray *)array targetController:(KLPopUpViewController *)targetController {
    
    if (array.count == 0) {
        return 0;
    } else if (array.count == 1) {
        return [self findIndexWithOneElementArray:array targetController:targetController];
    }
    
    NSInteger middleIndex = array.count/2;
    KLPopUpViewController *middleController = array[middleIndex];
    
    if (targetController.showPriority < middleController.showPriority) {
        NSArray *a = [array subarrayWithRange:NSMakeRange(0, middleIndex)];
        if (a.count == 1) {
            return [self findIndexWithOneElementArray:a targetController:targetController];
        } else {
            return [self recursiveFindWithArray:a targetController:targetController];
        }
    } else if (targetController.showPriority >= middleController.showPriority) {
        NSArray *b = [array subarrayWithRange:NSMakeRange(middleIndex, array.count-middleIndex)];
        if (b.count == 1) {
            return [self findIndexWithOneElementArray:b targetController:targetController];
        } else {
            return [self recursiveFindWithArray:b targetController:targetController];
        }
    }
    
    return NSNotFound;
}

- (NSInteger)findIndexWithOneElementArray:(NSArray *)array targetController:(KLPopUpViewController *)targetController {
    
    NSInteger inserIndex = NSNotFound;

    KLPopUpViewController *controller = array.firstObject;
    NSInteger originalIndex = [self.alertedStack indexOfObject:controller];
    
    if (targetController.showPriority < controller.showPriority) {
        inserIndex = originalIndex;
    } else {
        inserIndex = originalIndex + 1;
    }
    
    return inserIndex;
}

- (void)addToPendingWith:(KLPendingPopUpModel *)popUpModel {
    if ([self.pendingStack containsObject:popUpModel]) {
        [self.pendingStack removeObject:popUpModel];
    }
    [self.pendingStack addObject:popUpModel];
}

- (void)addToStackWith:(KLPendingPopUpModel *)popUpModel {
    
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
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (object == self) {
        return YES;
    }
    
    KLPendingPopUpModel *popUpModel = (KLPendingPopUpModel *)object;
    return [popUpModel.popController.identifier isEqualToString:self.popController.identifier];
}

@end

