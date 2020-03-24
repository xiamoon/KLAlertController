//
//  UIColor+KLDarkMode.h
//  KLAlertController
//
//  Created by liqian on 2020/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (KLDarkMode)

+ (UIColor * _Nonnull (^)(UIColor * _Nonnull, UIColor * _Nullable))kl_LightAndDark;

@end

NS_ASSUME_NONNULL_END
