//
//  KLViewController.m
//  KLAlertController
//
//  Created by xiamoon on 12/26/2019.
//  Copyright (c) 2019 xiamoon. All rights reserved.
//

#import "KLViewController.h"
#import "KLAlertController.h"
#import "Masonry.h"

@interface KLViewController ()

@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)testAlert:(id)sender {
    [self test1];
}

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

- (void)test4 {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, 200, 500);
    
//    KLAlertController *alert = [KLAlertController alertControllerWithContentView:view preferredStyle:UIAlertControllerStyleAlert];
//    alert.shouldRespondsMaskViewTouch = YES;
//    [alert addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//    [alert kl_show];
    
    KLPopUpViewController *popUp = [KLPopUpViewController alertControllerWithContentView:view preferredStyle:UIAlertControllerStyleAlert];
    popUp.shouldRespondsMaskViewTouch = YES;
    [popUp kl_show];
}

- (void)test5 {
    
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





- (IBAction)testSheet:(id)sender {
    KLAlertController *alert = [KLAlertController alertControllerWithTitle:@"你好" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[KLAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(KLAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(KLAlertAction * _Nonnull action) {
        
    }]];
    
    [alert kl_show];
}

- (IBAction)systemAlert:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Test title" message:@"Test message" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Default" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)systemSheet:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Test title" message:@"Test message" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Default" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
