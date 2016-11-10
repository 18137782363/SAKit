//
//  AppDelegate.m
//  SAKitDemo
//
//  Created by ISCS01 on 16/6/1.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SANavigationController.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSLog(@"\nscreenBounds: %@,scale: %f",NSStringFromCGRect([UIScreen mainScreen].bounds),[UIScreen mainScreen].scale);
    
    NSLog(@"zone : %@",[NSTimeZone localTimeZone]);
    
    [[NSUserDefaults standardUserDefaults] setObject:@"applicationWilqqweqweqwe1123lTerminate" forKey:@"xudeadsasd"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSTimeZone localTimeZone] forKey:@"currentTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    

    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    //设置网络请求

    //设置根控制器
    
    RootViewController *loginController = [[RootViewController alloc] init];
    SANavigationController *navController = [[SANavigationController alloc] initWithRootViewController:loginController];
    [navController addMenuViewWithLeftItemNormalImage:[UIImage imageNamed:@"nav_more"] leftItemSelectedImage:[UIImage imageNamed:@"nav_moreCur"] rightItemNormalImage:[UIImage imageNamed:@"nav_scanning"] rightItemSelectedImage:[UIImage imageNamed:@"nav_scanningCur"] expandItemNormalImageArray:@[[UIImage imageNamed:@"nav_task"],[UIImage imageNamed:@"nav_message"],[UIImage imageNamed:@"nav_team"],[UIImage imageNamed:@"nav_me"]] expandSelectImageArray:@[[UIImage imageNamed:@"nav_taskCur"],[UIImage imageNamed:@"nav_messageCur"],[UIImage imageNamed:@"nav_teamCur"],[UIImage imageNamed:@"nav_meCur"]]];
    [navController addBackButtonWithNormalImage:[UIImage imageNamed:@"icon_back"] selectedImage:nil];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    return UIInterfaceOrientationMaskLandscape;
//}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    __block UIBackgroundTaskIdentifier identifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (identifier != UIBackgroundTaskInvalid) {
            NSLog(@"UIBackgroundTaskInvalid!!!");
            [[NSUserDefaults standardUserDefaults] setObject:@"beginBackgroundTaskWithExpirationHandler" forKey:@"xbBackgroundTaskInvalid"];
            [[UIApplication sharedApplication] endBackgroundTask:identifier];
            identifier = UIBackgroundTaskInvalid;
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i < 20; i++) {
            NSLog(@"%d", i);
            sleep(1);
        }
        if (identifier != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:identifier];
            identifier = UIBackgroundTaskInvalid;
        }
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"xudeadsasd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"applicationWillTerminate" forKey:@"Terminate"];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}
@end
