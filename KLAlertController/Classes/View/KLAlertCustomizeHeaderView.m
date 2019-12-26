//
//  KLAlertCustomizeHeaderView.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertCustomizeHeaderView.h"
#import "Masonry.h"

@interface KLAlertCustomizeHeaderView ()
@property (nonatomic, strong) UIView *customizeView;
@end

@implementation KLAlertCustomizeHeaderView

- (instancetype)initWithCustomizeView:(UIView *)view {
    self = [super init];
    if (self) {
        while (self.subviews.count) {
            [self.subviews.lastObject removeFromSuperview];
        }
        
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            if (CGRectGetWidth(view.frame) != 0) {
                make.width.mas_equalTo(CGRectGetWidth(view.frame));
            }
            if (CGRectGetHeight(view.frame) != 0) {
                make.height.mas_equalTo(CGRectGetHeight(view.frame));
            }
        }];
        
        self.customizeView = view;
    }
    return self;
}

@end
