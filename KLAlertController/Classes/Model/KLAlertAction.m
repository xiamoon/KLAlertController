//
//  KLAlertAction.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertAction.h"

@interface KLAlertAction ()
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, assign) UIAlertActionStyle style;
@property (nonatomic, copy) void(^alertActionHandler)(KLAlertAction *action);
@end

@implementation KLAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                              style:(UIAlertActionStyle)style
                            handler:(void (^)(KLAlertAction * _Nonnull))handler {
    KLAlertAction *action = [[KLAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.alertActionHandler = handler;
    action.enabled = YES;
    action.shouldAutoDismissAlertController = YES;
    action.actionButton = nil;
    return action;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.actionButton.enabled = enabled;
}

@end
