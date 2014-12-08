//
//  AppDelegate.m
//  finish
//
//  Created by Pedro Góes on 07/12/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "AppDelegate.h"
#import "ColorThemeController.h"
#import "UIImage+Color.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Create components
    [self createCustomAppearance];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil userInfo:@{@"type": @"person"}];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)createCustomAppearance {
    
    // ----------------------
    // UIPopover
    // ----------------------
    UIImage *defaultImage = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:defaultImage forBarMetrics:UIBarMetricsDefault];
    
    // ----------------------
    // UIToolbar
    // ----------------------
    [[UIToolbar appearance] setBackgroundImage:[[UIImage alloc] imageWithColor:[ColorThemeController navigationBarBackgroundColor]] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // ----------------------
    // UINavigationBar
    // ----------------------
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[UINavigationBar appearance] setBarTintColor:[ColorThemeController navigationBarBackgroundColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [ColorThemeController navigationBarTextColor]}];
    }
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] imageWithColor:[ColorThemeController navigationBarBackgroundColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    
    // ----------------------
    // UIBarButtonItem
    // ----------------------
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [ColorThemeController navigationBarTextColor]} forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [ColorThemeController navigationItemTextColor]} forState:UIControlStateDisabled];
        
    } else {
        UIImage *backButton = [[UIImage imageNamed:@"barButtonBack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
        UIImage *barButton = [[UIImage imageNamed:@"barButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    }
    
    // ----------------------
    // UITabBarItem
    // ----------------------
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorThemeController tabBarItemTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0f, -2.0f)];
}

@end
