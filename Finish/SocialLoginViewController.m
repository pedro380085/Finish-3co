//
//  SocialLoginViewController.m
//  InEvent
//
//  Created by Pedro Góes on 24/03/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "SocialLoginViewController.h"
#import "HumanLoginViewController.h"
#import "HumanViewController.h"
#import "ColorThemeController.h"
#import "AppDelegate.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

@interface SocialLoginViewController ()

@end

@implementation SocialLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonWasPressed)];
    
    // View
    [self.view setBackgroundColor:[ColorThemeController tableViewCellBackgroundColor]];

    // Labels
    [_socialLabel setText:[NSString stringWithFormat:@"%@ %@, %@", NSLocalizedString(@"To login", nil), @"Finish", NSLocalizedString(@"choose your preferred social network.", nil), nil]];
    [_accountLabel setTitle:NSLocalizedString(@"Or you want to enter manually?", nil) forState:UIControlStateNormal];
    
    [_separator1 setBackgroundColor:[ColorThemeController tableViewCellBorderColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)cancelButtonWasPressed {
    [self dismissViewControllerAnimated:YES completion:^{
        // Select an event
        [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil userInfo:@{@"type": @"enterprise"}];
    }];
}

- (IBAction)loadAccountLogin:(id)sender {
    HumanLoginViewController *hlvc = [[HumanLoginViewController alloc] initWithNibName:@"HumanLoginViewController" bundle:nil];
    [self.navigationController pushViewController:hlvc animated:YES];
}

#pragma - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - LinkedIn Methods

- (IBAction)linkedInLogin:(id)sender {
    
    [self loginOnLinkedInWithBlock:^(NSString *accessToken) {
        // Notify our servers about the access token
//        [[[INLinkedInAPIController alloc] initWithDelegate:self forcing:YES] signInWithLinkedInToken:accessToken];
    }];
}

#pragma mark - Facebook Methods

- (IBAction)facebookLogin:(id)sender {
    
    [self loginOnFacebookWithBlock:^(NSString *accessToken) {
        // Notify our servers about the access token
//        [[[INFacebookAPIController alloc] initWithDelegate:self forcing:YES] signInWithFacebookToken:accessToken];
    }];
}

@end
