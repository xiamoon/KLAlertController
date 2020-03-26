//
//  KLViewController.m
//  KLAlertController
//
//  Created by xiamoon on 12/26/2019.
//  Copyright (c) 2019 xiamoon. All rights reserved.
//

#import "KLViewController.h"
#import "KLAlertController.h"

@interface KLViewController ()

@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)testAlert:(id)sender {
    [self test0];
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert1 kl_dismiss];
        });
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
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert1 kl_dismiss];
//        [alert0 kl_dismiss];
//        });
    });
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
