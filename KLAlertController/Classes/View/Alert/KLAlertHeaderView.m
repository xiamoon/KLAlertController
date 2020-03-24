//
//  KLAlertHeaderView.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertHeaderView.h"
#import "NSParagraphStyle+Shortcut.h"
#import "Masonry.h"
#import "UIColor+KLDarkMode.h"

@interface KLAlertHeaderView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSArray *childViews;
@end

@implementation KLAlertHeaderView

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message {
    BOOL hasTitle = NO;
    BOOL hasMessage = NO;
    if ([title isKindOfClass:[NSString class]] && title.length) {
        hasTitle = YES;
    }
    if ([message isKindOfClass:[NSString class]] && message.length) {
        hasMessage = YES;
    }
    if (!hasTitle && !hasMessage) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        
        self.titleAttributes = @{NSForegroundColorAttributeName: UIColor.kl_LightAndDark([UIColor blackColor], [UIColor whiteColor]),
                             NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:17],
                             NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithLineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]
                             };
        self.messageAttributes = @{NSForegroundColorAttributeName: UIColor.kl_LightAndDark([UIColor blackColor], [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0]),
                               NSFontAttributeName: [UIFont systemFontOfSize:13],
                               NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithLineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]
                               };
        
        self.titleMessageAreaContentInsets = UIEdgeInsetsMake(20, 16, 20, 16);
        self.titleMessageVerticalSpacing = 2;
        
        NSMutableArray *subviews = [NSMutableArray array];
        if (hasTitle) {
            self.titleLabel = [[UILabel alloc] init];
            self.titleLabel.tag = 100;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.titleAttributes];
            [self addSubview:self.titleLabel];
            [subviews addObject:self.titleLabel];
        }
        
        if (hasMessage) {
            self.messageLabel = [[UILabel alloc] init];
            self.messageLabel.tag = 101;
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:self.messageAttributes];
            [self addSubview:self.messageLabel];
            [subviews addObject:self.messageLabel];
        }
        self.childViews = subviews.copy;
    }
    return self;
}

// TODO: 目前这种布局是一次性的，下次改为主动调用布局，同时相关属性改变之后会有布局的更新
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && self.subviews.count) {
        [self layoutTitleAndMessage:self.childViews];
    }
}

- (void)layoutTitleAndMessage:(NSArray<UIView *> *)subviews {
    UIView *firstView = subviews.firstObject;
    UIEdgeInsets insets = self.titleMessageAreaContentInsets;
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(insets.left);
        make.right.offset(-insets.right);
        make.top.offset(insets.top);
        if (subviews.count == 1) {
            make.bottom.offset(-insets.top);
        }
    }];
    
    if (subviews.count == 2) {
        UIView *secondView = subviews.lastObject;
        [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(insets.left);
            make.right.offset(-insets.right);
            make.top.mas_equalTo(firstView.mas_bottom).offset(self.titleMessageVerticalSpacing);
            make.bottom.offset(-insets.bottom);
        }];
    }
}

#pragma mark - Setter.
- (void)setTitleAttributes:(NSDictionary<NSString *,id> *)titleAttributes {
    if (![self.title isKindOfClass:[NSString class]] || !self.title.length) return;
    
    _titleAttributes = titleAttributes;
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:self.titleAttributes];
}

- (void)setMessageAttributes:(NSDictionary<NSString *,id> *)messageAttributes {
    if (![self.message isKindOfClass:[NSString class]] || !self.message.length) return;

    _messageAttributes = messageAttributes;
    self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:self.message attributes:self.messageAttributes];
}

@end
