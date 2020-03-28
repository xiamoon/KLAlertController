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

/// 设置暗黑模式
- (void)setUserInterfaceStyle:(UIUserInterfaceStyle)userInterfaceStyle
                     animated:(BOOL)animated
                     duration:(CGFloat)duration API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
