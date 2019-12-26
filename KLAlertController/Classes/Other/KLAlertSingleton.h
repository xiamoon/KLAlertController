//
//  KLAlertSingleton.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KLAlertPresentingViewController;

@interface KLAlertSingleton : NSObject

+ (KLAlertSingleton *)sharedInstance;

- (KLAlertPresentingViewController *)KLAlertPresentViewController;

//! 销毁单例
- (void)destoryKLAlertSingleton;

@end

NS_ASSUME_NONNULL_END
