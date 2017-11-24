//
//  SuperViewController.m
//  EPostPickUpByCustomer
//
//  Created by BenjaminRichard on 16/4/14.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "SuperViewController.h"
#import "Utility.h"
@implementation SuperViewController
- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.tabBar.hidden = YES;
//    [self.view setBackgroundColor:[Utility colorWithHexString:BGCOLOR]];
}
- (void)viewWillDisappear:(BOOL)animated {
    self.parentViewController.tabBarController.tabBar.hidden = NO;
}

@end
