//
//  LoginHandlerViewController.m
//  InEvent
//
//  Created by Pedro Góes on 25/02/14.
//  Copyright (c) 2014 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "LoginHandlerViewController.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

@implementation LoginHandlerViewController

#pragma mark - LinkedIn Methods

- (void)loginOnLinkedInWithBlock:(void (^)(NSString *accessToken))apiBlock {
    
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://inevent.us/" clientId:@"7obxzmefk9eu" clientSecret:@"rPsCyb8npka6jJHk" state:@"5453sdfggeDCEEFWF4f424" grantedAccess:@[@"r_basicprofile", @"r_fullprofile", @"r_network", @"r_emailaddress"]];
    LIALinkedInHttpClient *client = [LIALinkedInHttpClient clientForApplication:application presentingViewController:self];
    
    [client getAuthorizationCode:^(NSString *code) {
        [client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            apiBlock([accessTokenData objectForKey:@"access_token"]);
            
        } failure:^(NSError *error) {
            // Session is closed
            ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"LinkedIn couldn't log you in! Try again?", nil) delegate:self cancelButtonTitle:nil otherButtonTitle:@"Ok"];
            [alertView show];
        }];
    } cancel:^{
        // Session is closed
        ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"LinkedIn couldn't log you in! Try again?", nil) delegate:self cancelButtonTitle:nil otherButtonTitle:@"Ok"];
        [alertView show];
    } failure:^(NSError *error) {
        // Session is closed
        ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"LinkedIn couldn't log you in! Try again?", nil) delegate:self cancelButtonTitle:nil otherButtonTitle:@"Ok"];
        [alertView show];
    }];
}

#pragma mark - Facebook Methods

- (void)loginOnFacebookWithBlock:(void (^)(NSString *accessToken))apiBlock {
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
        
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         if (error == nil && FBSession.activeSession.state == FBSessionStateOpen) {
             apiBlock(FBSession.activeSession.accessTokenData.accessToken);
             
         } else if (session.state == FBSessionStateClosed || session.state == FBSessionStateClosedLoginFailed) {
             // Session is closed
             ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Are you logged in on Facebook?", nil) delegate:self cancelButtonTitle:nil otherButtonTitle:@"Ok"];
             [alertView show];
         }
     }];
}

@end
