//
//  AppDelegate.m
//  gw_TableViewSuspend
//
//  Created by 刘功武 on 2019/4/30.
//  Copyright © 2019年 刘功武. All rights reserved.
/**tableview悬浮*/

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav_vc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav_vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
