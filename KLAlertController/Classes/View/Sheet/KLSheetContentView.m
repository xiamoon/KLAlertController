//
//  KLSheetContentView.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLSheetContentView.h"
#import "KLSheetHeaderView.h"
#import "KLSheetActionGroupView.h"
#import "KLAlertActionButton.h"
#import "KLAlertAction.h"
#import "Masonry.h"

@interface KLSheetContentView ()
@property (nonatomic, strong) KLAlertAction *cancelAction;
@property (nonatomic, strong) UIView *cancelButtonWrapperView;

@property (nonatomic, strong) KLSheetHeaderView *headerView;
@property (nonatomic, strong) KLSheetActionGroupView *actionGroupView;
@end

@implementation KLSheetContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sheetCancelButtonMarginTop = 8.0;
        self.cancelActionButtonHeight = 57.0;
        self.cancelButtonAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0],
                                        NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:20]                             };
    }
    return self;
}

// TODO: 目前这种布局是一次性的，下次改为主动调用布局，同时相关属性改变之后会有布局的更新
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.cancelButtonWrapperView.layer.cornerRadius = self.cornerRadius;
        
        if (self.cancelButtonWrapperView) {
            [self.backContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-self.sheetCancelButtonMarginTop-self.cancelActionButtonHeight);
            }];
            
            [self.cancelButtonWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.offset(0);
                make.height.mas_equalTo(self.cancelActionButtonHeight);
            }];
        }
    }
}

- (void)insertHeaderView:(UIView *)headerView {
    self.headerView = (KLSheetHeaderView *)headerView;
    [super insertHeaderView:headerView];
}

- (void)insertActionGroupView:(UIView *)actionGroupView {
    self.actionGroupView = (KLSheetActionGroupView *)actionGroupView;
    [super insertActionGroupView:actionGroupView];
}


- (void)addCancelAction:(KLAlertAction *)action {
    if (!action) return;
    self.cancelAction = action;

    UIView *cancelView = [[UIView alloc] init];
    cancelView.backgroundColor = [UIColor whiteColor];
    cancelView.layer.masksToBounds = YES;
    [self addSubview:cancelView];

    KLAlertActionButton *cancelButton = [[KLAlertActionButton alloc] init];
    cancelButton.enabled = action.enabled;
    cancelButton.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.cancelAction.title attributes:self.cancelButtonAttributes];
    [cancelButton addTarget:self action:@selector(handleCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancelButton];
    action.actionButton = cancelButton;
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    self.cancelButtonWrapperView = cancelView;
}

#pragma mark - Override.
- (CGFloat)headerViewMaximumHeight {
    if (self.actionGroupView && self.actionGroupView.actions.count) {
        CGFloat cancelAreaTotalHeight = 0;
        if (self.cancelAction) {
            cancelAreaTotalHeight = self.cancelActionButtonHeight+self.sheetCancelButtonMarginTop;
        }
        
        NSUInteger count = self.actionGroupView.actions.count;
        if (count <= 1) {
            return self.contentMaximumHeight-self.separatorHeight-count*self.actionGroupView.actionButtonHeight-cancelAreaTotalHeight;
        }else {
            // 露出1.5个按钮
            // 多露出0.5个按钮，不然用户以为按钮区域不能滚动
            return self.contentMaximumHeight-self.separatorHeight-1.5*self.actionGroupView.actionButtonHeight-1*self.actionGroupView.lineHeight-cancelAreaTotalHeight;
        }
    }else {
        return self.contentMaximumHeight;
    }
    return 0;
}

- (void)handleCancelButtonAction:(UIButton *)button {
    if (self.klCancelAlertActionButtonHandler) {
        self.klCancelAlertActionButtonHandler(self.cancelAction);
    }
}

@end
