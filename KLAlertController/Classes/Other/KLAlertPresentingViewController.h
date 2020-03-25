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

- (BOOL)kl_isAlertControllerCurrentShowed;

- (void)kl_removeAlertControllerWithIdentifier:(NSString *)identifier
                                     animated:(BOOL)animated
                                completion:(nullable void (^)(void))completion;

- (void)kl_removeAllAlertControllerAnimated:(BOOL)animated
                                completion:(nullable void (^)(void))completion;

@end


@interface KLPendingPopUpModel : NSObject
@property (nonatomic, strong) KLPopUpViewController *popController;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong, nullable) void(^completion)(void);
@end

NS_ASSUME_NONNULL_END
