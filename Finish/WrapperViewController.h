//
//  WrapperViewController.h
//  InEvent
//
//  Created by Pedro Góes on 18/12/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETAlertView.h"
#import "ColorThemeController.h"

@interface WrapperViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate,UISplitViewControllerDelegate, ETAlertViewDelegate>

// Allocation
- (void)allocTapBehind;
- (void)deallocTapBehind;
- (void)handleTapBehind:(UITapGestureRecognizer *)sender;

// Facebook
- (void)connectWithFacebook;

// Manipulation
- (void)removePerson;
- (void)removeEvent;

// Bar
- (void)loadSearchEventsButton;
- (void)loadMenuButton;

@end
