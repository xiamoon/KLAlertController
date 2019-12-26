//
//  KLSheetHeaderView.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLSheetHeaderView.h"
#import "NSParagraphStyle+Shortcut.h"
#import "Masonry.h"

@implementation KLSheetHeaderView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super initWithTitle:title message:message];
    if (self) {
        self.titleAttributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor],
                             NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:13],
                             NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithLineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]
                             };
        self.messageAttributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor],
                               NSFontAttributeName: [UIFont systemFontOfSize:12],
                               NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithLineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]
                               };
        
        self.titleMessageAreaContentInsets = UIEdgeInsetsMake(14.5, 16, 25, 16);
        self.titleMessageVerticalSpacing = 12;
    }
    return self;
}

#pragma mark - Override
- (void)layoutTitleAndMessage:(NSArray<UIView *> *)subviews {
    UIView *firstView = subviews.firstObject;
    NSInteger firstViewTag = firstView.tag;
    UIEdgeInsets insets = self.titleMessageAreaContentInsets;
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(insets.left);
        make.right.offset(-insets.right);
        make.top.offset(firstViewTag==100 ? insets.top : insets.bottom);
        if (subviews.count == 1) {
            make.bottom.offset(firstViewTag==101 ? -insets.bottom : -insets.top);
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

@end
