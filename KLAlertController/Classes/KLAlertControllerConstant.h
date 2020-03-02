//
//  KLAlertControllerConstant.h
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#ifndef KLAlertControllerConstant_h
#define KLAlertControllerConstant_h

// Color.
#ifndef UIColorRGBA
    #define UIColorRGBA(r, g, b, a) \
    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

    #define UIColorRGB(r, g, b)     UIColorRGBA(r, g, b, 1.f)

    #define UIRandomColor \
    UIColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#endif

#ifndef UIColorHexA
    #define UIColorHexA(_hex_, a) \
    UIColorRGBA((((_hex_) & 0xFF0000) >> 16), (((_hex_) & 0xFF00) >> 8), ((_hex_) & 0xFF), a)

    #define UIColorHex(_hex_)   UIColorHexA(_hex_, 1.0)
#endif

#ifndef dispatch_queue_async_safe
    #define dispatch_queue_async_safe(queue, block)\
        if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
            block();\
        } else {\
            dispatch_async(queue, block);\
        }
#endif

#ifndef dispatch_main_async_safe
    #define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

#endif /* KLAlertControllerConstant_h */
