//
//  CommonViewController.m
//  InEvent
//
//  Created by Pedro Góes on 25/11/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "CommonViewController.h"
#import "ColorThemeController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initalizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        // Custom initialization
        [self initalizer];
    }
    return self;
}

- (void)initalizer {
    
    // Add notification observer for updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performVerification:) name:@"verify" object:nil];
}

#pragma mark - View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.viewControllers count] > 1) [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return ((1 << toInterfaceOrientation) | self.supportedInterfaceOrientations) == self.supportedInterfaceOrientations;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Methods

- (void)performVerification:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    if (userInfo != nil) {
        
        NSString *type = [userInfo objectForKey:@"type"];
        
        if ([type isEqualToString:@"ad"]) {
            // Load a single ad
            [self performSelector:@selector(verifyAd) withObject:nil afterDelay:0.2f];
            
        } else if ([type isEqualToString:@"person"]) {
            // Verify if company is already selected
            [self performSelector:@selector(verifyPerson) withObject:nil afterDelay:0.1f];
            
        }
    }
}

@end
