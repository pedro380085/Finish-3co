//
//  WrapperViewController.m
//  InEvent
//
//  Created by Pedro Góes on 18/12/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "WrapperViewController.h"
#import "AppDelegate.h"

#define UNIQUE_LOADER 1

@interface WrapperViewController () {
    BOOL shouldCancelKeyboardAnimation;
    CGRect keyboardFrame;
    CGRect componentFrame;
    CGFloat currentViewShift;
    UITapGestureRecognizer *behindRecognizer;
}

@property (strong, nonatomic) UIBarButtonItem *barButtonItem;

@end

@implementation WrapperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        keyboardFrame = CGRectZero;
        componentFrame = CGRectZero;
        currentViewShift = 0.0f;
    }
    return self;
}

#pragma mark - View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Wrapper
    [self.view.layer setCornerRadius:2.0f];
    [self.view.layer setMasksToBounds:YES];
    
    // Navigation
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        // Navigation Bar
        self.navigationController.navigationBar.translucent = NO;
        // View Controller
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveKeyboardSize:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveKeyboardSize:) name:UIKeyboardWillHideNotification object:nil];
    
    // We check if the back button is already set, so we have to preserve it
    // The navigationBar items is an array that counts how many controllers we already have on the stack
//    if ([self.navigationController.viewControllers count] == 1 && self.presentingViewController == nil && ![[[self.splitViewController viewControllers] objectAtIndex:1] isEqual:self.navigationController]) {
//        
//        // Left Button
//        _leftBarButton = [[ETFlatBarButtonItem alloc] initCustomButtonWithImage:[UIImage imageNamed:@"20-Hamburguer-L"] frame:CGRectMake(0, 0, 42.0, 30.0) insets:UIEdgeInsetsMake(7.0, 10.0, 7.0, 10.0) target:self action:@selector(showSlidingMenu)];
//        _leftBarButton.accessibilityLabel = NSLocalizedString(@"Menu Options", nil);
//        _leftBarButton.accessibilityTraits = UIAccessibilityTraitButton;
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer.width = 5;
//        
//        if ([self.navigationItem.leftBarButtonItems count] == 1) {
//            NSMutableArray *barButtons = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
//            [barButtons insertObject:negativeSpacer atIndex:0];
//            [barButtons insertObject:_leftBarButton atIndex:1];
//            self.navigationItem.leftBarButtonItems = barButtons;
//        } else if ([self.navigationItem.leftBarButtonItems count] != 3) {
//            self.navigationItem.leftBarButtonItems = @[negativeSpacer, _leftBarButton];
//        }
//    }
    
    // The Right Button may have different options across various controllers, so we can't declare it on the superclass
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Keyboard Notifications

- (void)saveKeyboardSize:(NSNotification*)notification {
    CGRect keyboardFrameOriginal = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    keyboardFrame = [mainSubviewOfWindow convertRect:keyboardFrameOriginal fromView:window];
    
    if (!CGRectEqualToRect(componentFrame, CGRectZero)) {
        [self checkKeyboardForPreponentParentView:nil];
        componentFrame = CGRectZero;
    }
}

- (void)checkKeyboardForPreponentParentView:(UIView *)component {
    
    // Wait until the next cycle to hide the keyboard
    shouldCancelKeyboardAnimation = NO;
    
    // Process the keyboard state
    if (component) {
        // Convert frame
        CGRect correctFrame = [component convertRect:component.bounds toView:nil];
        
        // Move by our current view shift
        correctFrame.origin.y -= currentViewShift;
        
        // Move keyboard if tab bar is present
        if (self.tabBarController) correctFrame.origin.y -= self.tabBarController.tabBar.frame.size.height;
        
        if (keyboardFrame.size.height == 0.0) {
            componentFrame = correctFrame;
        } else {
            [self calculateViewShift:correctFrame];
        }
    } else {
        [self calculateViewShift:componentFrame];
    }
}

- (void)calculateViewShift:(CGRect)frame {
    // Find the beyboard height
    CGFloat keyboardHeight = (keyboardFrame.size.height / [[UIScreen mainScreen] scale]);
    // Get the middle of the frame
    CGFloat viewAbsolutePosition = (self.view.frame.size.height - frame.size.height - keyboardHeight) / 2.0f;
    
    // Recalculate height for status bar and navigation bar
    if (self.navigationController && viewAbsolutePosition <= self.navigationController.navigationBar.frame.size.height) {
        viewAbsolutePosition = self.navigationController.navigationBar.frame.size.height + 20.0f;
    } else if (viewAbsolutePosition <= 20.0f)  {
        viewAbsolutePosition = 20.0f;
    }
    
    // Move the view to its calculated position
    [self shiftParentView:viewAbsolutePosition - (currentViewShift + frame.origin.y)];
}

- (void)shiftParentView:(CGFloat)shift {
    
    CGRect rect = self.view.frame;

    currentViewShift += shift;
    rect.origin.y += shift;
    
    [UIView animateWithDuration:0.23 animations:^{
        self.view.frame = rect;
    }];
}

#pragma mark - Tap Behind methods

- (void)allocTapBehind {
    // Add the gesture recognizer
    behindRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [behindRecognizer setNumberOfTapsRequired:1];
    [behindRecognizer setCancelsTouchesInView:NO]; // So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:behindRecognizer];
}

- (void)deallocTapBehind {
    // Remove the gesture recognizer
    [self.view.window removeGestureRecognizer:behindRecognizer];
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil]; // Passing nil gives us coordinates in the window
        
        // Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside.
        // If outside, dismiss the view.
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil]) {
            // Remove the recognizer first so it's view.window is valid.
            [self.view.window removeGestureRecognizer:sender];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Facebook Methods

- (void)connectWithFacebook {
    if (!FBSession.activeSession.isOpen) {
        
        // Create our session
        FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:@[@"basic_info", @"email"] urlSchemeSuffix:nil tokenCacheStrategy:nil];
        
        // Set the active session
        [FBSession setActiveSession:session];
        
        // Open the session
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {}];
    }
}

#pragma mark - View Controller Delegate

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Resign all view's first responders
    [self.view endEditing:YES];
    
    // Clean the keyboard size
    keyboardFrame = CGRectZero;
}

#pragma mark - Split View Controller Delegate

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    self.barButtonItem = barButtonItem;
    [self showRootPopoverButtonItem];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self invalidateRootPopoverButtonItem];
    self.barButtonItem = nil;
}

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

#pragma mark - Split View Controller Rotation Methods

- (void)showRootPopoverButtonItem {
    // Append the button into the ones that we already have
    NSMutableArray *barButtons = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    if (_barButtonItem && ![barButtons containsObject:_barButtonItem]) [barButtons addObject:_barButtonItem];
    [self.navigationItem setLeftBarButtonItems:barButtons animated:YES];
}

- (void)invalidateRootPopoverButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    NSMutableArray *barButtons = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [barButtons removeObject:_barButtonItem];
    [self.navigationItem setLeftBarButtonItems:barButtons animated:YES];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    // Move view if necessary
    if (currentViewShift != 0.0f) {
        [self performSelector:@selector(checkKeyboardForPreponentParentView:) withObject:textField afterDelay:0.4f];
        shouldCancelKeyboardAnimation = YES;
    } else {
        [self checkKeyboardForPreponentParentView:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    // Move view down if necessary
    if (shouldCancelKeyboardAnimation == NO) {
        [self shiftParentView:-(currentViewShift)];
    }
    
    return YES;
}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    // Move view if necessary
    if (currentViewShift != 0.0f) {
        [self performSelector:@selector(checkKeyboardForPreponentParentView:) withObject:textView afterDelay:0.4f];
        shouldCancelKeyboardAnimation = YES;
    } else {
        [self checkKeyboardForPreponentParentView:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    // Move view down if necessary
    if (shouldCancelKeyboardAnimation == NO) {
        [self shiftParentView:-(currentViewShift)];
    }
    
    return YES;
}

@end
