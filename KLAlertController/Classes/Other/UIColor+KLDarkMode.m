//
//  UIColor+KLDarkMode.m
//  KLAlertController
//
//  Created by liqian on 2020/3/24.
//

#import "UIColor+KLDarkMode.h"

@implementation UIColor (KLDarkMode)

+ (UIColor * _Nonnull (^)(UIColor * _Nonnull, UIColor * _Nullable))kl_LightAndDark {
    return ^(UIColor *lightColor, UIColor *darkColor) {
        if (@available(iOS 13.0, *)) {
            return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return darkColor ?: lightColor;
                } else {
                    return lightColor;
                }
            }];
        }
        
        return lightColor;
    };
}

@end
