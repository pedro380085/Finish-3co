//
//  HumanLoginViewController.m
//  InEvent
//
//  Created by Pedro Góes on 24/03/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "HumanLoginViewController.h"
#import "HumanViewController.h"
#import "ColorThemeController.h"
#import "AppDelegate.h"

@interface HumanLoginViewController ()

@end

@implementation HumanLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Bar Button
    [self loadMenuButton];
    
    // View
    [self.view setBackgroundColor:[ColorThemeController tableViewCellBackgroundColor]];
    [self.view addTarget:self action:@selector(hideFieldBox) forControlEvents:UIControlEventTouchUpInside];
    
    // Labels
    [_accountLabel setText:NSLocalizedString(@"Already enrolled?", nil)];
    
    // Box
    [_bottomBox setBackgroundColor:[ColorThemeController backgroundColor]];
    [_bottomBox addTarget:self action:@selector(hideFieldBox) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBox.layer setMasksToBounds:YES];
    
    [_bottomInternalBox addTarget:self action:@selector(hideFieldBox) forControlEvents:UIControlEventTouchUpInside];
    
    [_separator2 setBackgroundColor:[ColorThemeController tableViewCellBorderColor]];
    
    // Login toggle button
    [_loginButton setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(toggleFieldBox:) forControlEvents:UIControlEventTouchUpInside];
    
    // Register toggle button
    [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(toggleFieldBox:) forControlEvents:UIControlEventTouchUpInside];
    
    // Field Wrapper
	_personFieldWrapper.backgroundColor = [ColorThemeController tableViewCellBackgroundColor];
    [_personFieldWrapper.layer setBorderWidth:1.0];
    [_personFieldWrapper.layer setBorderColor:[[ColorThemeController tableViewCellBorderColor] CGColor]];
    
    // Text Fields
    [self configureTextField:_personEmail withPlaceHolder:NSLocalizedString(@"Email", nil)];
    [self configureTextField:_personName withPlaceHolder:NSLocalizedString(@"Name", nil)];
    [self configureTextField:_personEmail withPlaceHolder:NSLocalizedString(@"Password", nil)];
    
	// Field action button
	[_personAction setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
    [_personAction addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    [_personAction.layer setCornerRadius:8.0];
    
    
    // ---------------------
    // Reset the field box
    // ---------------------
    [self toggleFieldBoxWithDuration:0.0 andHideIt:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configureTextField:(UITextField *)textField withPlaceHolder:(NSString *)placeholder {
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.delegate = self;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = NSLocalizedString(@"Email", nil);
    textField.textColor = [ColorThemeController textColor];
}

- (void)cancelButtonWasPressed {
    [self dismissViewControllerAnimated:YES completion:^{
        // Select an event
        [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil userInfo:@{@"type": @"enterprise"}];
    }];
}

#pragma mark - Bar Methods

- (void)loadMenuButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonWasPressed)];
    self.navigationItem.rightBarButtonItem.accessibilityLabel = NSLocalizedString(@"Cancel", nil);
    self.navigationItem.rightBarButtonItem.accessibilityTraits = UIAccessibilityTraitSummaryElement;
}

#pragma mark - Email Methods

- (void)hideNameField {
    [_personName setHidden:YES];
    [_personPassword setFrame:CGRectMake(_personPassword.frame.origin.x, 50.0, _personPassword.frame.size.width, 50.0)];
    [_personFieldWrapper setFrame:CGRectMake(_personFieldWrapper.frame.origin.x, 100.0, _personFieldWrapper.frame.size.width, 100.0)];
    [_personAction setFrame:CGRectMake(_personAction.frame.origin.x, 220.0, _personAction.frame.size.width, _personAction.frame.size.height)];
}

- (void)showNameField {
    [_personName setHidden:NO];
    [_personPassword setFrame:CGRectMake(_personPassword.frame.origin.x, 100.0, _personPassword.frame.size.width, 50.0)];
    [_personFieldWrapper setFrame:CGRectMake(_personFieldWrapper.frame.origin.x, 100.0, _personFieldWrapper.frame.size.width, 150.0)];
    [_personAction setFrame:CGRectMake(_personAction.frame.origin.x, 270.0, _personAction.frame.size.width, _personAction.frame.size.height)];
}

#pragma mark - Box Methods

- (void)hideFieldBox {
    [self toggleFieldBoxWithDuration:0.5 andHideIt:YES];
}

- (void)toggleFieldBox:(id)sender {
    
    if ((UIButton *)sender == _registerButton) {
        [self showNameField];
    } else if ((UIButton *)sender == _loginButton) {
        [self hideNameField];
    }
    
    [self toggleFieldBoxWithDuration:0.5 andHideIt:NO];
}

- (void)toggleFieldBoxWithDuration:(CGFloat)duration andHideIt:(BOOL)hide {
    
    // Resign the keyboard on all the fields
    [_personEmail resignFirstResponder];
    [_personName resignFirstResponder];
    [_personPassword resignFirstResponder];
    
    // Create the frames
    CGRect frameBox, frameInternal;
    
    if (_bottomInternalBox.frame.origin.y == 0.0 && hide == NO) {
        // Show
        frameBox = _bottomBox.frame;
        frameBox.origin.y = self.view.frame.size.height - frameBox.size.height;
        
        frameInternal = _bottomInternalBox.frame;
        frameInternal.origin.y = frameInternal.origin.y - frameInternal.size.height / 4.0;
        
    } else {
        // Hide
        frameBox = _bottomBox.frame;
        frameBox.origin.y = self.view.frame.size.height - frameBox.size.height / 4.0;
        
        frameInternal = _bottomInternalBox.frame;
        frameInternal.origin.y = 0.0;
    }
    
    // Animate
    [UIView animateWithDuration:duration animations:^{
        [_bottomBox setFrame:frameBox];
        [_bottomInternalBox setFrame:frameInternal];
    }];
}

#pragma - Action Methods

- (void)chooseAction {
    
    if ([_personName isHidden]) {
        [self signIn];
    } else {
        [self enroll];
    }
}

- (void)signIn {
    
    if ([_personEmail.text length] > 0 && [_personPassword.text length] > 0) {
        // Set loading message on button
        [_personAction setTitle:NSLocalizedString(@"Logging ...", nil) forState:UIControlStateNormal];
        
        // Notify our servers about the login attempt
//        [[[INPersonAPIController alloc] initWithDelegate:self forcing:YES] signInWithEmail:_personEmail.text withPassword:_personPassword.text];
        
    } else {
        // Give some data man!
        ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please give me some details about you.", nil) delegate:self cancelButtonTitle:nil otherButtonTitle:@"Ok"];
        [alertView show];
    }
}

- (void)enroll {
    
    if ([_personEmail.text length] > 0 && [_personName.text length] > 0 && [_personPassword.text length] > 0) {
        // Set loading message on button
        [_personAction setTitle:NSLocalizedString(@"Registering ...", nil) forState:UIControlStateNormal];
        
        // Notify our servers about the login attempt
//        [[[INPersonAPIController alloc] initWithDelegate:self forcing:YES] createWithName:_personName.text withEmail:_personEmail.text withPassword:_personPassword.text];
        
    } else {
        // Give some data man!
        ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"If you wanna be part of this event, please give some basic details.", nil) delegate:self cancelButtonTitle:nil otherButtonTitle:@"Ok"];
        [alertView show];
    }
}

#pragma - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
