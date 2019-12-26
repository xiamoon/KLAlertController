//
//  KLAlertSingleton.m
//  KLAlertController
//
//  Created by liqian on 2019/12/7.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "KLAlertSingleton.h"
#import "KLAlertPresentingViewController.h"

@interface KLAlertSingleton ()
@property (nonatomic, strong) KLAlertPresentingViewController *presentingVc;
@end

@implementation KLAlertSingleton

static KLAlertSingleton *instance;
static dispatch_once_t onceToken;
+ (KLAlertSingleton *)sharedInstance {
    dispatch_once(&onceToken, ^{
        instance = [[KLAlertSingleton alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.presentingVc = [[KLAlertPresentingViewController alloc] init];
    }
    return self;
}

- (KLAlertPresentingViewController *)KLAlertPresentViewController {
    return self.presentingVc;
}

- (void)destoryKLAlertSingleton {
    self.presentingVc = nil;
    instance = nil;
    onceToken = 0l;
}

- (void)dealloc {
    NSLog(@"KLAlertSingleton dealloc");
}

@end
