//
//  KLAlertContentView.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertContentView.h"
#import "KLAlertHeaderView.h"
#import "KLAlertActionGroupView.h"
#import "Masonry.h"
#import "UIColor+KLDarkMode.h"

@interface KLAlertContentView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *headerScrollView;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIScrollView *actionScrollview;

@property (nonatomic, strong) KLAlertHeaderView *headerView;
@property (nonatomic, strong) KLAlertActionGroupView *actionGroupView;
@end

@implementation KLAlertContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.separatorHeight = 1.0/[UIScreen mainScreen].scale;
        self.separatorColor = UIColor.kl_LightAndDark([UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0], [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:1.0]);
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.layer.masksToBounds = YES;
        [self addSubview:self.backgroundView];
        
        self.headerScrollView = [[UIScrollView alloc] init];
        [self.backgroundView addSubview:self.headerScrollView];
        
        self.separatorView = [[UIView alloc] init];
        [self.backgroundView addSubview:self.separatorView];
        
        self.actionScrollview = [[UIScrollView alloc] init];
        [self.backgroundView addSubview:self.actionScrollview];
        
        // layout
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
        
        // 添加scrollView的默认占位内容
        UIView *defaultHeader = [[UIView alloc] init];
        [self.headerScrollView addSubview:defaultHeader];
        [defaultHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            make.height.mas_equalTo(0);
        }];
        
        UIView *defaultActionView = [[UIView alloc] init];
        [self.actionScrollview addSubview:defaultActionView];
        [defaultActionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            make.height.mas_equalTo(0);
        }];
        
        
        
        [self.headerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.width.mas_equalTo(defaultHeader.mas_width);
            make.height.mas_equalTo(defaultHeader.mas_height);
        }];
        
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(self.headerScrollView.mas_bottom);
            make.height.mas_equalTo(0);
        }];

        [self.actionScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.separatorView.mas_bottom);
            make.left.right.bottom.offset(0);
            make.width.mas_equalTo(defaultActionView.mas_width);
            make.height.mas_equalTo(defaultActionView.mas_height);
        }];
    }
    return self;
}

// TODO: 目前这种布局是一次性的，下次改为主动调用布局，同时相关属性改变之后会有布局的更新
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.backgroundView.backgroundColor = self.backgroundViewColor;
        self.backgroundView.layer.cornerRadius = self.cornerRadius;
        
        if (self.headerView) {
            [self.headerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.headerView.mas_width);
                make.height.mas_lessThanOrEqualTo([self headerViewMaximumHeight]).priority(750);
                make.height.mas_equalTo(self.headerView.mas_height).priority(500);
            }];
        }
        
        if (self.actionGroupView) {
            self.separatorView.backgroundColor = self.separatorColor;
            [self.separatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.separatorHeight);
            }];
            
            [self.actionScrollview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.actionGroupView.mas_width);
                make.height.mas_equalTo(self.actionGroupView.mas_height).priority(250);
            }];
        }
    }
}

- (void)insertHeaderView:(nullable UIView *)headerView {
    if (!headerView) return;
    
    self.headerView = (KLAlertHeaderView *)headerView;
    
    if (self.headerScrollView.subviews.count) {
        UIView *oldView = self.headerScrollView.subviews.lastObject;
        [oldView removeFromSuperview];
    }
    
    [self.headerScrollView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)insertActionGroupView:(nullable UIView *)actionGroupView {
    if (!actionGroupView) return;
    
    self.actionGroupView = (KLAlertActionGroupView *)actionGroupView;
    
    if (self.actionScrollview.subviews.count) {
        UIView *oldView = self.actionScrollview.subviews.lastObject;
        [oldView removeFromSuperview];
    }
    
    [self.actionScrollview addSubview:actionGroupView];
    [actionGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)deviceOrientationWillChangeWithContentMaximumHeight:(CGFloat)contentMaximumHeight
                                                   duration:(NSTimeInterval)duration {
    self.contentMaximumHeight = contentMaximumHeight;
    
    if (self.headerView) {
        [self.headerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_lessThanOrEqualTo([self headerViewMaximumHeight]).priority(750);
            make.height.mas_equalTo(self.headerView.mas_height).priority(500);
        }];
    }
    
    if (self.actionGroupView) {
        [self.actionScrollview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.actionGroupView.mas_height).priority(250);
        }];
    }
}

#pragma mark - Override.
- (CGFloat)headerViewMaximumHeight {
    if (self.actionGroupView && self.actionGroupView.actions.count) {
        if (self.actionGroupView.actions.count <= 2) {
            // alert中1个按钮和2个按钮都是只占一行的高度
            return self.contentMaximumHeight-self.separatorHeight-(1*self.actionGroupView.actionButtonHeight);
        }else {
            // 露出1.5个按钮
            // 多露出0.5个按钮，不然用户以为按钮区域不能滚动
            return self.contentMaximumHeight-self.separatorHeight-1.5*self.actionGroupView.actionButtonHeight-1*self.actionGroupView.lineHeight;
        }
    }else {
        return self.contentMaximumHeight;
    }
    return 0;
}

@end
