//
//  KLSheetActionGroupView.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLSheetActionGroupView.h"
#import "UIColor+KLDarkMode.h"

@implementation KLSheetActionGroupView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.actionButtonHeight = 57.0;
        self.defaultButtonAttributes = @{NSForegroundColorAttributeName: UIColor.kl_LightAndDark([UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0], [UIColor colorWithRed:54/255.0 green:105/255.0 blue:200/255.0 alpha:1.0]),
                                     NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:20]                             };
        self.cancelButtonAttributes = @{NSForegroundColorAttributeName: UIColor.kl_LightAndDark([UIColor colorWithRed:45/255.0 green:139/255.0 blue:245/255.0 alpha:1.0], [UIColor colorWithRed:54/255.0 green:105/255.0 blue:200/255.0 alpha:1.0]),
                                    NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:20]                             };
        self.destructiveButtonAttributes = @{NSForegroundColorAttributeName: UIColor.kl_LightAndDark([UIColor redColor], [UIColor colorWithRed:230/255.0 green:41/255.0 blue:41/255.0 alpha:1.0]),
                                         NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:20]                             };
    }
    return self;
}

@end
