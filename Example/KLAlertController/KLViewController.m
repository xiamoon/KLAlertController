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
    KLAlertController *alert1 = [KLAlertController alertControllerWithTitle:@"你好1" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert1 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//    alert1.contentBackgroundColor = UIColorHex(0x2b2b2b);
    [alert1 kl_show];
    
    KLAlertController *alert2 = [KLAlertController alertControllerWithTitle:@"你好2" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    alert2.showPriority = 700;
    [alert2 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert2 kl_show];
    
    KLAlertController *alert3 = [KLAlertController alertControllerWithTitle:@"你好3" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    alert3.showPriority = 700;
    [alert3 addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert3 kl_show];
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
