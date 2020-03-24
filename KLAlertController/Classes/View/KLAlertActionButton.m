//
//  KLAlertActionButton.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertActionButton.h"
#import "Masonry.h"

@interface KLAlertActionButton ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation KLAlertActionButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (self.isHighlighted == highlighted) {
        return;
    }
    [super setHighlighted:highlighted];
    
    if (highlighted == YES) {
        self.alpha = 0.7;
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.alpha = 1.0;
        });
    }
}

- (void)setEnabled:(BOOL)enabled {
    if (self.isEnabled == enabled) {
        return;
    }
    
    [super setEnabled:enabled];
    
    if (enabled == YES) {
        self.alpha = 1.0;
        self.titleLabel.alpha = 1.0;
    }else {
        self.alpha = 0.7;
        self.titleLabel.alpha = 0.3;
    }
}

@end
