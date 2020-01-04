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
    KLAlertController *alert = [KLAlertController alertControllerWithTitle:@"你好" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[KLAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(KLAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(KLAlertAction * _Nonnull action) {
        
    }]];
    
    [alert kl_show];
}

- (IBAction)testSheet:(id)sender {
    KLAlertController *alert = [KLAlertController alertControllerWithTitle:@"你好" message:@"这是一条测试信息" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[KLAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(KLAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[KLAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(KLAlertAction * _Nonnull action) {
        
    }]];
    
    [alert kl_show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
