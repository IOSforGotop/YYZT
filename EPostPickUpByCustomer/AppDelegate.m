//
//  AppDelegate.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-9-28.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "AppDelegate.h"

//判断是否是iphone x
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define TabbarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) // 适配iPhone x 底栏高度
#define StatusHight      [[UIApplication sharedApplication] statusBarFrame].size.height            //获取状态栏高度


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    UITabBarController *tb=[[UITabBarController alloc]init];
//    //设置控制器为Window的根控制器
//    self.window.rootViewController=tb;
//
//    //b.创建子控制器
//    UIViewController *c1=[[UIViewController alloc]init];
//    c1.view.backgroundColor=[UIColor grayColor];
//    c1.view.backgroundColor=[UIColor greenColor];
//    c1.tabBarItem.title=@"消息";
//    c1.tabBarItem.image=[UIImage imageNamed:@"tab_recent_nor"];
//    c1.tabBarItem.badgeValue=@"123";
//
//    UIViewController *c2=[[UIViewController alloc]init];
//    c2.view.backgroundColor=[UIColor brownColor];
//    c2.tabBarItem.title=@"联系人";
//    c2.tabBarItem.image=[UIImage imageNamed:@"tab_buddy_nor"];
//
//    UIViewController *c3=[[UIViewController alloc]init];
//    c3.tabBarItem.title=@"动态";
//    c3.tabBarItem.image=[UIImage imageNamed:@"tab_qworld_nor"];
//
//    UIViewController *c4=[[UIViewController alloc]init];
//    c4.tabBarItem.title=@"设置";
//    c4.tabBarItem.image=[UIImage imageNamed:@"tab_me_nor"];
//
//
//    //c.添加子控制器到ITabBarController中
//    //c.1第一种方式
//    //    [tb addChildViewController:c1];
//    //    [tb addChildViewController:c2];
//
//    //c.2第二种方式
//    tb.viewControllers=@[c1,c2,c3,c4];
//
//
//    //2.设置Window为主窗口并显示出来
//    [self.window makeKeyAndVisible];
   
    //适配ios11
    if(@available(iOS 11.0,*)){
        
        UITableView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
    }
    
    //适配iphone x
    if(kDevice_Is_iPhoneX){
        
        NSLog(@"是 iphone x");
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    else{
        
        NSLog(@"不是 iphone x");
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    // [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
