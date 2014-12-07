//
//  HumanViewController.m
//  InEvent
//
//  Created by Pedro Góes on 24/03/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "HumanViewController.h"
#import "UIViewController+Present.h"
#import "UIImageView+WebCache.h"
#import "ODRefreshControl.h"

@interface HumanViewController () {
    ODRefreshControl *refreshControl;
    NSDictionary *personData;
    BOOL editingMode;
}

@end

@implementation HumanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Register for some updates
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"personNotification" object:nil];
    }
    return self;
}

#pragma mark - View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Wrapper
    _wrapper.backgroundColor = [ColorThemeController backgroundColor];
    _wrapper.layer.cornerRadius = 4.0f;
    
    // Refresh Control
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.view];
    refreshControl.tintColor = [ColorThemeController navigationBarBackgroundColor];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    // Scroll View
    self.view.contentSize = CGSizeMake(self.view.frame.size.width, 462.0f);
	[self.view flashScrollIndicators];
    
    // Photo
    [_photo.layer setMasksToBounds:YES];
    
    // Text fields
    _name.textColor = [ColorThemeController tableViewCellTextColor];
    _name.placeholder = NSLocalizedString(@"Name", nil);
    _role.textColor = [ColorThemeController tableViewCellTextHighlightedColor];
    _role.placeholder = NSLocalizedString(@"Role", nil);
    _company.textColor = [ColorThemeController tableViewCellTextHighlightedColor];
    _company.placeholder = NSLocalizedString(@"Company", nil);
    _telephone.textColor = [ColorThemeController tableViewCellTextColor];
    _telephone.placeholder = NSLocalizedString(@"Telephone", nil);
    _email.textColor = [ColorThemeController tableViewCellTextColor];
    _email.placeholder = NSLocalizedString(@"Email", nil);
    _location.textColor = [ColorThemeController tableViewCellTextColor];
    _location.placeholder = NSLocalizedString(@"Location", nil);
    
    // Buttons
    [_inButton setTitleColor:[ColorThemeController tableViewCellTextColor] forState:UIControlStateDisabled];
    [_fbButton setTitleColor:[ColorThemeController tableViewCellTextColor] forState:UIControlStateDisabled];
    
    // Load data
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loader Methods

- (void)loadData {
    [self forceDataReload:NO];
}

- (void)reloadData {
    [self forceDataReload:YES];
}

- (void)forceDataReload:(BOOL)forcing {

}

#pragma mark - Painter Methods

- (void)paint {
    
    if (personData) {
        
        // Right Button
        [self loadMenuButton];
        
        // Photo
        if ([[personData objectForKey:@"facebookID"] length] > 1) {
            [self.photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=%d&height=%d", [personData objectForKey:@"facebookID"], (int)(self.photo.frame.size.width * [[UIScreen mainScreen] scale]), (int)(self.photo.frame.size.height * [[UIScreen mainScreen] scale])]] placeholderImage:[UIImage imageNamed:@"user_male3-256"]];
            [_photo.layer setCornerRadius:_photo.frame.size.width / 2.0f];
        } else if ([[personData objectForKey:@"image"] length] > 1) {
            [self.photo sd_setImageWithURL:[NSURL URLWithString:[personData objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"user_male3-256"]];
            [_photo.layer setCornerRadius:_photo.frame.size.width / 2.0f];
        } else {
            [self.photo setImage:[UIImage imageNamed:@"user_male3-256"]];
            [_photo.layer setCornerRadius:0.0f];
        }
        
        // Text fields
        self.name.text = [personData objectForKey:@"name"];
        self.role.text = [personData objectForKey:@"role"];
        self.company.text = [personData objectForKey:@"company"];
        self.telephone.text = [personData objectForKey:@"telephone"];
        self.email.text = [personData objectForKey:@"email"];
        self.location.text = [personData objectForKey:@"city"];
        
        // Professional
        if ([[personData objectForKey:@"linkedInID"] length] > 1) {
            [_inButton setTitle:NSLocalizedString(@"Connected profile", nil) forState:UIControlStateNormal];
            [_inButton setEnabled:NO];
            
        } else {
            [_inButton setTitle:NSLocalizedString(@"Link account", nil) forState:UIControlStateNormal];
            [_inButton setEnabled:YES];
        }
        
        // Social
        if ([[personData objectForKey:@"facebookID"] length] > 1) {
            [_fbButton setTitle:NSLocalizedString(@"Connected profile", nil) forState:UIControlStateNormal];
            [_fbButton setEnabled:NO];
            
        } else {
            [_fbButton setTitle:NSLocalizedString(@"Link account", nil) forState:UIControlStateNormal];
            [_fbButton setEnabled:YES];
        }
        
    } else {
        // Clean our UI
        [self cleanData];
    }
}

- (void)cleanData {
    if (editingMode) [self endEditing];
    self.navigationItem.rightBarButtonItem = nil;
    [_name setText:NSLocalizedString(@"Your name", nil)];
    [_role setText:@""];
    [_company setText:@""];
    [_telephone setText:@""];
    [_email setText:@""];
    [_location setText:@""];
    [_inButton setTitle:@"" forState:UIControlStateNormal];
    [_fbButton setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - Bar Methods

- (void)loadDoneButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing)];
}

#pragma mark - Social

- (IBAction)linkAccountToFacebook {
    
    [self loginOnFacebookWithBlock:^(NSString *accessToken) {
//        [[[INFacebookAPIController alloc] initWithDelegate:self forcing:YES] updateAuthenticatedWithFacebookToken:accessToken withSelection:@"personal"];
    }];
}

- (IBAction)linkAccountToLinkedIn {
    
    [self loginOnLinkedInWithBlock:^(NSString *accessToken) {
//        [[[INLinkedInAPIController alloc] initWithDelegate:self forcing:YES] updateAuthenticatedWithLinkedInToken:accessToken withSelection:@"personal"];
    }];
}

#pragma mark - Editing

- (void)startEditing {
    
    // Set the placeholders
    [self.name setPlaceholder:self.name.text];
    [self.role setPlaceholder:self.role.text];
    [self.company setPlaceholder:self.company.text];
    [self.telephone setPlaceholder:self.telephone.text];
    [self.email setPlaceholder:self.email.text];
    [self.location setPlaceholder:self.location.text];
    
    // Start editing
    editingMode = YES;
    
    [self loadDoneButton];
}

- (void)saveEditing:(UIView *)field forName:(NSString *)name {
    // Field will always have a placeholder, so we can cast it as a UITextField
    if (![((UITextField *)field).placeholder isEqualToString:((UITextField *)field).text]) {
//        [[[INPersonAPIController alloc] initWithDelegate:self forcing:YES] editAuthenticatedWithKey:name withValue:((UITextField *)field).text];
    }
}

- (void)endEditing {
    
    // Save the fields
    [self saveEditing:self.name forName:@"name"];
    [self saveEditing:self.role forName:@"role"];
    [self saveEditing:self.company forName:@"company"];
    [self saveEditing:self.telephone forName:@"telephone"];
    [self saveEditing:self.email forName:@"email"];
    [self saveEditing:self.location forName:@"city"];
    
    // End editing
    [self.view endEditing:YES];
    editingMode = NO;
    
    [self loadMenuButton];
}

#pragma mark - ActionSheet Methods

- (void)alertActionSheet {
    
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Actions", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Search events", nil), nil];

    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:NSLocalizedString(@"Edit fields", nil)]) {
        [self startEditing];
    } else if ([title isEqualToString:NSLocalizedString(@"Logout", nil)]) {
        [self logoutButtonWasPressed];
    }
}

#pragma mark - Logout Methods

- (void)logoutButtonWasPressed {
    
    // Remove person token and data
    [self removePerson];
    
    // Go back to root controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (editingMode) {
        return [super textFieldShouldBeginEditing:textField];
    } else {
        return NO;
    }
}

@end
