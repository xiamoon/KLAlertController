//
//  KLSheetContentView.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertContentView.h"

NS_ASSUME_NONNULL_BEGIN

@class KLAlertAction;
@interface KLSheetContentView : KLAlertContentView

@property (nonatomic, assign) CGFloat sheetCancelButtonMarginTop;

//MARK: 取消按钮相关属性
// 取消按钮高度默认57.0，跟系统保持一致
@property (nonatomic, assign) CGFloat cancelActionButtonHeight;
@property(nonatomic, strong) NSDictionary<NSString *, id> *cancelButtonAttributes;

- (void)addCancelAction:(KLAlertAction *)action;
@property (nonatomic, copy) void (^klCancelAlertActionButtonHandler)(KLAlertAction *action);

@end

NS_ASSUME_NONNULL_END
