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

- (void)kl_presentPopUpViewController:(KLPopUpViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion;

- (BOOL)kl_isAlertControllerCurrentShowed;

- (void)kl_removeAlertConrollerWithIdentifier:(NSString *)identifier
                                     animated:(BOOL)animated
                                completion:(nullable void (^)(void))completion;

- (void)kl_removeAllAlertConrollerAnimated:(BOOL)animated
                                completion:(nullable void (^)(void))completion;

#pragma mark - 通知
- (void)kl_popUpViewControllerWillDismiss:(KLPopUpViewController *)popUpViewController;
- (void)kl_popUpViewControllerDidDismiss;

@end


@interface KLPendingPopUpModel : NSObject
@property (nonatomic, strong) KLPopUpViewController *popController;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong, nullable) void(^completion)(void);
@end

NS_ASSUME_NONNULL_END
