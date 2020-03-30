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

#import "KLAlertTester.h"

@interface KLViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIWindow *keywindow1 = [UIApplication sharedApplication].keyWindow;
//        NSLog(@">>> keywindow1: %@", keywindow1);
//
//        UIWindow *keywindow2 = self.view.window;
//        NSLog(@">>> keywindow2: %@", keywindow2);
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            UIWindow *keywindow3 = [UIApplication sharedApplication].keyWindow;
//            NSLog(@">>> keywindow3: %@", keywindow3);
//
//            UIWindow *keywindow4 = self.textField.window;
//            NSLog(@">>> keywindow4: %@", keywindow4);
//        });
//    });
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNtf:) name:UIWindowDidBecomeKeyNotification object:nil];
}

- (void)testNtf:(NSNotification *)ntf {
    NSLog(@"ntf.object: %@", ntf.object);
}

- (IBAction)testAlert:(id)sender {
    [[KLAlertTester new] testDarkModeSwitch];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    
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
