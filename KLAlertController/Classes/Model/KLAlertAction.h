//
//  KLAlertAction.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KLAlertActionButton;

@interface KLAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title
                              style:(UIAlertActionStyle)style
                            handler:(void (^ __nullable)(KLAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, assign, readonly) UIAlertActionStyle style;
@property (nullable, nonatomic, copy, readonly) void(^alertActionHandler)(KLAlertAction *action);

// 按钮的enable属性。Default YES
@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, assign) BOOL shouldAutoDismissAlertController; //!< 点击按钮之后是否自动隐藏整个alertController。默认YES

// KLAlertAction所对应的按钮，可能为空。
// 注：actionButton只有在controller调用了kl_show后才能获取到。
@property (nonatomic, strong, nullable) KLAlertActionButton *actionButton;

@end

NS_ASSUME_NONNULL_END
