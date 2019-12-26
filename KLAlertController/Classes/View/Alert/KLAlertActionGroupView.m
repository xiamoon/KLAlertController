//
//  KLAlertActionGroupView.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertActionGroupView.h"
#import "Masonry.h"
#import "KLAlertActionButton.h"
#import "KLAlertAction.h"

@interface KLAlertActionGroupView ()
@property (nonatomic, strong) NSArray<KLAlertAction *> *actions;
@property (nonatomic, strong) UIView *actionGroupArea;
@end

@implementation KLAlertActionGroupView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.actions = [NSArray array];
        
        self.actionButtonHeight = 44.0;
        self.lineHeight = 1.0/[UIScreen mainScreen].scale;
        self.lineColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        
        self.defaultButtonAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0],
                                         NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:17]                             };
        self.cancelButtonAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0],
                                        NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:17]                             };
        self.destructiveButtonAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                             NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:17]                             };
    }
    return self;
}

- (void)addAction:(KLAlertAction *)action {
    NSMutableArray *actions = self.actions.mutableCopy;
    [actions addObject:action];
    self.actions = actions.copy;
}

- (BOOL)layoutActions {
    if (self.actions.count == 0) {
        return NO;
    }
    [self removeAllSubviews];
    
    // 添加按钮区域
    self.actionGroupArea = [[UIView alloc] init];
    [self addSubview:self.actionGroupArea];
    [self.actionGroupArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    if (self.actions.count == 2 && [self isMemberOfClass:[KLAlertActionGroupView class]]) {
        [self layoutForTwoActions];
    }else {
        [self layoutForNotTwoActions];
    }
    return YES;
}

- (void)layoutForTwoActions {
    UIView *verticalLineView = [[UIView alloc] init];
    verticalLineView.backgroundColor = self.lineColor;
    [self.actionGroupArea addSubview:verticalLineView];
    [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.width.mas_equalTo(self.lineHeight);
        make.centerX.mas_equalTo(self.actionGroupArea.mas_centerX);
    }];
    
    for (int i = 0; i < 2; i ++) {
        KLAlertAction *action = self.actions[i];
        KLAlertActionButton *button = [[KLAlertActionButton alloc] init];
        button.enabled = action.enabled;
        button.tag = i;
        [self setAttributedTextWith:action.title forButton:button style:action.style];
        [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionGroupArea addSubview:button];
        action.actionButton = button;
    
        if (i == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.offset(0);
                make.right.mas_equalTo(verticalLineView.mas_left);
                make.height.mas_equalTo(self.actionButtonHeight);
            }];
        }else if (i == 1) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.offset(0);
                make.left.mas_equalTo(verticalLineView.mas_right);
                make.height.mas_equalTo(self.actionButtonHeight);
            }];
        }
    }
}

- (void)layoutForNotTwoActions {
    NSMutableArray *lines = [NSMutableArray array];
    [self.actions enumerateObjectsUsingBlock:^(KLAlertAction *action, NSUInteger idx, BOOL * _Nonnull stop) {
        KLAlertActionButton *button = [[KLAlertActionButton alloc] init];
        button.enabled = action.enabled;
        button.tag = idx;
        [self setAttributedTextWith:action.title forButton:button style:action.style];
        [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionGroupArea addSubview:button];
        action.actionButton = button;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = self.lineColor;
        [self.actionGroupArea addSubview:lineView];
        [lines addObject:lineView];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(self.actionButtonHeight);
            if (idx == 0) {
                make.top.offset(0);
            }else {
                UIView *lastLine = lines[idx-1];
                make.top.mas_equalTo(lastLine.mas_bottom);
            }
            
            if (idx == self.actions.count-1) {
                make.bottom.offset(0);
            }
        }];
        
        if (idx != self.actions.count-1) {
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.height.mas_equalTo(self.lineHeight);
                make.top.mas_equalTo(button.mas_bottom);
            }];
        }
    }];
}

- (void)handleButtonAction:(UIButton *)button {
    if (self.klAlertActionButtonHandler) {
        KLAlertAction *action = self.actions[button.tag];
        self.klAlertActionButtonHandler(action);
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (void)setAttributedTextWith:(NSString *)text
            forButton:(KLAlertActionButton *)button
                style:(UIAlertActionStyle)style {
    if (style == UIAlertActionStyleDefault) {
        button.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.defaultButtonAttributes];
    }else if (style == UIAlertActionStyleCancel) {
        button.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.cancelButtonAttributes];
    }else if (style == UIAlertActionStyleDestructive) {
        button.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.destructiveButtonAttributes];
    }
}

@end
