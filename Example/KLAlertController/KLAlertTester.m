//
//  KLAlertTester.m
//  KLAlertController_Example
//
//  Created by liqian on 2020/3/30.
//  Copyright © 2020 xiamoon. All rights reserved.
//

#import "KLAlertTester.h"
#import "KLAlertController.h"
#import "Masonry.h"

@implementation KLAlertTester

- (void)test0 {
    KLAlertController *alert0 = [KLAlertController alertControllerWithTitle:@"你好0" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert0 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert0 kl_show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KLAlertController *alert1 = [KLAlertController alertControllerWithTitle:@"你好1" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
        alert1.showPriority = 800;
        [alert1 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [alert1 kl_show];
        
//        [self removeAllKLAlertConrollerAnimated:YES completion:^{
//            NSLog(@"remove all");
//        }];
    });
    
    KLAlertController *alert2 = [KLAlertController alertControllerWithTitle:@"你好2" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    alert2.showPriority = 600;
    [alert2 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert2 kl_show];
}

- (void)test1 {
    KLAlertController *alert0 = [KLAlertController alertControllerWithTitle:@"你好0" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert0 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert0 kl_show];
    
    KLAlertController *alert1 = [KLAlertController alertControllerWithTitle:@"你好1" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert1 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert1 kl_show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alert1 kl_dismiss];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert1 kl_dismiss];
//        });
    });
}

- (void)test2 {
    KLAlertController *alert0 = [KLAlertController alertControllerWithTitle:@"你好0" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert0 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert0 kl_show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        KLAlertController *alert1 = [KLAlertController alertControllerWithTitle:@"你好1" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
        alert1.showPriority = 1000;
        [alert1 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [alert1 kl_show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            [alert1 kl_dismiss];
//            [self removeAllKLAlertConrollerAnimated:YES completion:nil];
        });
    });
}

- (void)test3 {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, 200, 500);
    
    UITextField *tf = [[UITextField alloc] init];
    [view addSubview:tf];
    tf.frame = CGRectMake(20, 20, 100, 40);
    
//    KLAlertController *alert = [KLAlertController alertControllerWithContentView:view preferredStyle:UIAlertControllerStyleAlert];
//    alert.shouldRespondsMaskViewTouch = YES;
//    [alert addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//    [alert kl_show];
    
    KLPopUpViewController *popUp = [KLPopUpViewController alertControllerWithContentView:view preferredStyle:UIAlertControllerStyleAlert];
    popUp.shouldRespondsMaskViewTouch = YES;
    [popUp kl_show];
}

- (void)test4 {
    
    UIView *subView = [[UIView alloc] init];
    subView.backgroundColor = [UIColor purpleColor];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:subView];
    
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
        make.size.mas_equalTo(CGSizeMake(200, 500));
    }];
    
    KLAlertController *alert = [KLAlertController alertControllerWithContentView:view preferredStyle:UIAlertControllerStyleActionSheet];
    alert.shouldRespondsMaskViewTouch = YES;
//    alert.contentMaximumHeightForLandscape = 300;
    alert.contentMaximumHeightForPortrait = 300;
    alert.cornerRadius = 0;

    alert.shouldRespondsMaskViewTouch = YES;

    [alert addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert kl_show];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [alert contentMaximumHeightForLandscape];
//        [alert contentMaximumHeightForPortrait];
//    });


    KLPopUpViewController *popUp = [KLPopUpViewController alertControllerWithContentView:view preferredStyle:UIAlertControllerStyleActionSheet];
//    popUp.contentMaximumHeightForLandscape = 300;
//    popUp.contentMaximumHeightForPortrait = 300;
    popUp.shouldRespondsMaskViewTouch = YES;
    [popUp kl_show];
}

- (void)test5 {
    KLAlertController *alert0 = [KLAlertController alertControllerWithTitle:@"你好0" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert0 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert0 kl_show];
}

- (void)testDarkModeSwitch {
    KLAlertController *alert0 = [KLAlertController alertControllerWithTitle:@"你好0" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleActionSheet];
    
    KLAlertAction *action0 = [KLAlertAction actionWithTitle:@"跟随系统" style:UIAlertActionStyleDefault handler:^(KLAlertAction * _Nonnull action) {
        [self handleDarkModeSwitch:0];
    }];
    action0.shouldAutoDismissAlertController = NO;
    [alert0 addAction:action0];
    
    KLAlertAction *action1 = [KLAlertAction actionWithTitle:@"Light" style:UIAlertActionStyleDefault handler:^(KLAlertAction * _Nonnull action) {
        [self handleDarkModeSwitch:1];
    }];
    action1.shouldAutoDismissAlertController = NO;
    [alert0 addAction:action1];
    
    KLAlertAction *action2 = [KLAlertAction actionWithTitle:@"Dark" style:UIAlertActionStyleDefault handler:^(KLAlertAction * _Nonnull action) {
        [self handleDarkModeSwitch:2];
    }];
    action2.shouldAutoDismissAlertController = NO;
    [alert0 addAction:action2];

    [alert0 kl_show];
}

- (void)handleDarkModeSwitch:(NSInteger)index {
    
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle style = index;

        [[UIApplication sharedApplication].keyWindow setOverrideUserInterfaceStyle:style];
        
        [KLPopUpViewController setUserInterfaceStyle:style animated:YES duration:NO];
        
    } else {
        // Fallback on earlier versions
    }
}

@end
