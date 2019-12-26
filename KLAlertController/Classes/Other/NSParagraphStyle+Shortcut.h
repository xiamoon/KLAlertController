//
//  NSParagraphStyle+Shortcut.h
//  TestModalViewController
//
//  Created by liqian on 2018/12/18.
//  Copyright © 2018 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSParagraphStyle (Shortcut)
+ (instancetype)paragraphStyleWithLineBreakMode:(NSLineBreakMode)lineBreakMode
                                  textAlignment:(NSTextAlignment)textAlignment;
@end

NS_ASSUME_NONNULL_END
