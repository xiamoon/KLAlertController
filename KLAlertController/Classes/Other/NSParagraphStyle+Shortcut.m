//
//  NSParagraphStyle+Shortcut.m
//  TestModalViewController
//
//  Created by liqian on 2018/12/18.
//  Copyright © 2018 liqian. All rights reserved.
//

#import "NSParagraphStyle+Shortcut.h"

@implementation NSParagraphStyle (Shortcut)

+ (instancetype)paragraphStyleWithLineBreakMode:(NSLineBreakMode)lineBreakMode
                               textAlignment:(NSTextAlignment)textAlignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = textAlignment;
    return paragraphStyle;
}

@end
