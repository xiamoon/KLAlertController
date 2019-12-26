//
//  KLAlertBaseAnimation.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KLAlertControllerConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLAlertBaseAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, assign) CGFloat presentDelayTimeInterval;
@property (nonatomic, assign) CGFloat presentTimeInterval;

@property (nonatomic, assign) CGFloat dismissDelayTimeInterval;
@property (nonatomic, assign) CGFloat dismissTimeInterval;

- (void)deviceOrientationDidChangeDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
