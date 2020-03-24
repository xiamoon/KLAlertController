//
//  KLAlertController.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertController.h"
#import "KLAlertContentView.h"
#import "KLSheetContentView.h"
#import "KLAlertCustomizeHeaderView.h"
#import "KLAlertHeaderView.h"
#import "KLSheetHeaderView.h"
#import "KLAlertActionGroupView.h"
#import "KLSheetActionGroupView.h"
#import "Masonry.h"

@interface KLAlertController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) KLAlertContentView *alertContentView; //! 整个content
@property (nonatomic, strong) KLAlertHeaderView *headerView; //! title和message
@property (nonatomic, strong) KLAlertActionGroupView *actionGroupView; //! 按钮区域
@end

@implementation KLAlertController
@synthesize contentWidth = _contentWidth;
@synthesize sheetContentMarginBottom = _sheetContentMarginBottom;
@synthesize cornerRadius = _cornerRadius;

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle {
    KLAlertController *alertVc = [[KLAlertController alloc] initInternalWithTitle:title message:message preferredStyle:preferredStyle];
    return alertVc;
}

+ (instancetype)alertControllerWithContentView:(UIView *)view preferredStyle:(UIAlertControllerStyle)preferredStyle {
    KLAlertController *alertVc = [[KLAlertController alloc] initInternalWithPreferredStyle:preferredStyle];
    [alertVc addContentView:view];
    return alertVc;
}

- (void)addContentView:(UIView *)view {
    self.headerView = [[KLAlertCustomizeHeaderView alloc] initWithCustomizeView:view];
}

- (void)viewDidLoad {
    BOOL needLayout = [self.actionGroupView layoutActions];
    [self.alertContentView insertHeaderView:self.headerView];
    [self.alertContentView insertActionGroupView:needLayout ? self.actionGroupView : nil];
    
    [super addContentView:self.alertContentView];
    [super viewDidLoad];
}

- (void)addAction:(KLAlertAction *)action {
    // ActionSheet的cancel按钮需要特殊处理，因为这个按钮不是添加在actionGroupView中的，而是在contentView中
    BOOL isSheetCancelAction = NO;
    if (self.preferredStyle == UIAlertControllerStyleActionSheet && action.style == UIAlertActionStyleCancel) {
        isSheetCancelAction = YES;
    }
    
    if (isSheetCancelAction) {
        [[self sheetContentView] addCancelAction:action];
    }else {
        [self.actionGroupView addAction:action];
    }
}

#pragma mark - Private.
- (instancetype)initInternalWithTitle:(NSString *)title
                              message:(NSString *)message
                       preferredStyle:(UIAlertControllerStyle)preferredStyle {
    self = [[[self class] alloc] initInternalWithPreferredStyle:preferredStyle];
    if (self) {
        CGFloat defaultContentWidth = 0;
        KLAlertHeaderView *header = nil;
        
        if (preferredStyle == UIAlertControllerStyleAlert) {
            header = [[KLAlertHeaderView alloc] initWithTitle:title message:message];
            defaultContentWidth = 270.0;
        }else if (preferredStyle == UIAlertControllerStyleActionSheet) {
            header = [[KLSheetHeaderView alloc] initWithTitle:title message:message];
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGFloat minWidth = MIN(screenSize.width, screenSize.height);
            defaultContentWidth = minWidth-8-8;
        }
        [self setContentWidth:defaultContentWidth];
        self.headerView = header;
    }
    return self;
}

- (instancetype)initInternalWithPreferredStyle:(UIAlertControllerStyle)preferredStyle {
    self = [super init];
    if (self) {
        self.preferredStyle = preferredStyle;
        
        KLAlertContentView *content = nil;
        if (preferredStyle == UIAlertControllerStyleAlert) {
            content = [[KLAlertContentView alloc] init];
            content.contentMaximumHeight = self.contentMaximumHeight;
        }else if (preferredStyle == UIAlertControllerStyleActionSheet) {
            [self setSheetContentMarginBottom:8.0];
            content = [self sheetContentView];
            content.contentMaximumHeight = self.contentMaximumHeight-self.sheetContentMarginBottom;
        }
        self.contentBackgroundColor = UIColor.kl_LightAndDark([UIColor whiteColor], [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]);
        content.backgroundViewColor = self.contentBackgroundColor;
        self.alertContentView = content;
        [self setCornerRadius:12.0];
    }
    return self;
}

- (void)deviceOrientationWillChangeWithContentMaximumHeight:(CGFloat)contentMaximumHeight
                                                   duration:(NSTimeInterval)duration {
    CGFloat newContentMaximumHeight = contentMaximumHeight;
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        newContentMaximumHeight = contentMaximumHeight-self.sheetContentMarginBottom;
    }
    [self.alertContentView deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:duration];
    
    [super deviceOrientationWillChangeWithContentMaximumHeight:contentMaximumHeight duration:duration];
}

#pragma mark - Setter.
- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor {
    _contentBackgroundColor = contentBackgroundColor;
    self.alertContentView.backgroundViewColor = contentBackgroundColor;
}

- (void)setContentWidth:(CGFloat)contentWidth {
    _contentWidth = contentWidth;
    [super setContentWidth:contentWidth];
}

- (void)setTitleMessageAreaContentInsets:(UIEdgeInsets)titleMessageAreaContentInsets {
    _titleMessageAreaContentInsets = titleMessageAreaContentInsets;
    [self.headerView setTitleMessageAreaContentInsets:titleMessageAreaContentInsets];
}

- (void)setTitleMessageVerticalSpacing:(CGFloat)titleMessageVerticalSpacing {
    _titleMessageVerticalSpacing = titleMessageVerticalSpacing;
    [self.headerView setTitleMessageVerticalSpacing:titleMessageVerticalSpacing];
}

- (void)setSheetCancelButtonMarginTop:(CGFloat)sheetCancelButtonMarginTop {
    _sheetCancelButtonMarginTop = sheetCancelButtonMarginTop;
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        [self sheetContentView].sheetCancelButtonMarginTop = sheetCancelButtonMarginTop;
    }
}

- (void)setSheetContentMarginBottom:(CGFloat)sheetContentMarginBottom {
    _sheetContentMarginBottom = sheetContentMarginBottom;
    [super setSheetContentMarginBottom:sheetContentMarginBottom];
}

- (void)setTitleAttributes:(NSDictionary<NSString *,id> *)titleAttributes {
    [self.headerView setTitleAttributes:titleAttributes];
}

- (void)setMessageAttributes:(NSDictionary<NSString *,id> *)messageAttributes {
    [self.headerView setMessageAttributes:messageAttributes];
}

- (void)setActionButtonHeight:(CGFloat)actionButtonHeight {
    _actionButtonHeight = actionButtonHeight;
    [self.actionGroupView setActionButtonHeight:actionButtonHeight];
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        [self sheetContentView].cancelActionButtonHeight = actionButtonHeight;
    }
}

- (void)setDefaultButtonAttributes:(NSDictionary<NSString *,id> *)defaultButtonAttributes {
    [self.actionGroupView setDefaultButtonAttributes:defaultButtonAttributes];
}

- (void)setCancelButtonAttributes:(NSDictionary<NSString *,id> *)cancelButtonAttributes {
    [self.actionGroupView setCancelButtonAttributes:cancelButtonAttributes];
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        [self sheetContentView].cancelButtonAttributes = cancelButtonAttributes;
    }
}

- (void)setDestructiveButtonAttributes:(NSDictionary<NSString *,id> *)destructiveButtonAttributes {
    [self.actionGroupView setDestructiveButtonAttributes:destructiveButtonAttributes];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.alertContentView.cornerRadius = cornerRadius;
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    self.alertContentView.separatorHeight = lineHeight;
    self.actionGroupView.lineHeight = lineHeight;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.alertContentView.separatorColor = lineColor;
    self.actionGroupView.lineColor = lineColor;
}

#pragma mark - Getter.
- (KLSheetContentView *)sheetContentView {
    KLSheetContentView *sheetContentView = (KLSheetContentView *)self.alertContentView;
    if (!sheetContentView) {
        sheetContentView = [[KLSheetContentView alloc] init];
        __weak typeof(self)weakSelf = self;
        sheetContentView.klCancelAlertActionButtonHandler = ^(KLAlertAction * _Nonnull action) {
            if (action.shouldAutoDismissAlertController) {
                [weakSelf kl_dismissWithAnimated:YES completion:^{
                    if (action.alertActionHandler) {
                        action.alertActionHandler(action);
                    }
                }];
            } else {
                if (action.alertActionHandler) {
                    action.alertActionHandler(action);
                }
            }
        };
    }
    return sheetContentView;
}

- (KLAlertActionGroupView *)actionGroupView {
    if (!_actionGroupView) {
        if (self.preferredStyle == UIAlertControllerStyleAlert) {
            _actionGroupView = [[KLAlertActionGroupView alloc] init];
        }else if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
            _actionGroupView = [[KLSheetActionGroupView alloc] init];
        }
        
        __weak typeof(self)weakSelf = self;
        _actionGroupView.klAlertActionButtonHandler = ^(KLAlertAction * _Nonnull action) {
            if (action.shouldAutoDismissAlertController) {
                [weakSelf kl_dismissWithAnimated:YES completion:^{
                    if (action.alertActionHandler) {
                        action.alertActionHandler(action);
                    }
                }];
            } else {
                if (action.alertActionHandler) {
                    action.alertActionHandler(action);
                }
            }
        };
    }
    return _actionGroupView;
}

- (NSArray<KLAlertAction *> *)actions {
    return self.actionGroupView.actions;
}

- (CGFloat)sheetContentMarginBottom {
    CGFloat safePaddingBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        safePaddingBottom = safeInsets.bottom;
    }
    return _sheetContentMarginBottom+safePaddingBottom;
}

@end
