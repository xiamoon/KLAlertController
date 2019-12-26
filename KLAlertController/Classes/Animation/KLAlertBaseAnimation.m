//
//  KLAlertBaseAnimation.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertBaseAnimation.h"

@implementation KLAlertBaseAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {}


- (void)deviceOrientationDidChangeDuration:(NSTimeInterval)duration {}

- (void)dealloc {
    NSLog(@"animation dealloc");
}

@end
