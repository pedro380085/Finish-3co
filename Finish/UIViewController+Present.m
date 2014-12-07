//
//  UIViewController+Present.m
//  InEvent
//
//  Created by Pedro Góes on 23/01/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "UIViewController+Present.h"
#import "AppDelegate.h"
#import "DemoViewController.h"
#import "SocialLoginViewController.h"

@implementation UIViewController (Present)

#pragma mark - Verification

- (BOOL)verifyDemo {
        
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // This is the first launch ever
        UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:[[DemoViewController alloc] initWithNibName:nil bundle:nil]];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        } else {
            viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            viewController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:viewController animated:YES completion:nil];
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)verifyPerson {
    
    // See if demo has been presented
    [self verifyDemo];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"providedLoginOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"providedLoginOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        SocialLoginViewController *slvc = [[SocialLoginViewController alloc] initWithNibName:@"SocialLoginViewController" bundle:nil];
        UINavigationController *nslvc = [[UINavigationController alloc] initWithRootViewController:slvc];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            nslvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            nslvc.modalPresentationStyle = UIModalPresentationCurrentContext;
        } else {
            nslvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            nslvc.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:nslvc animated:YES completion:^{
            // Notify human controller and reload UI
            [[NSNotificationCenter defaultCenter] postNotificationName:@"personNotification" object:nil];
        }];
    
        return YES;
    } else {
        return NO;
    }
}

@end
