//
//  KLAlertPresentingViewController.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KLPopUpViewController;
@interface KLAlertPresentingViewController : UIViewController

/// 统一present方法
- (void)kl_presentPopUpViewController:(KLPopUpViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(nullable void (^)(void))completion;

/// 统一dismiss方法
- (void)kl_dismissPopUpViewController:(KLPopUpViewController *)viewControllerToDismiss
                             animated:(BOOL)flag
                           completion:(nullable void(^)(void))completion;

/// 当前屏幕上是否有popUpController存在
- (BOOL)kl_isAlertControllerCurrentShowed;

/// 通过identifier移除popUpController
- (void)kl_removeAlertControllerWithIdentifier:(NSString *)identifier
                                     animated:(BOOL)animated
                                completion:(nullable void (^)(void))completion;

/// 移除所有popUpController
- (void)kl_removeAllAlertControllerAnimated:(BOOL)animated
                                completion:(nullable void (^)(void))completion;

/// Dark 和 Light 模式切换时调用
- (void)traitCollectionDidChange;

@end

NS_ASSUME_NONNULL_END
