//
//  HumanViewController.h
//  InEvent
//
//  Created by Pedro Góes on 24/03/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginHandlerViewController.h"

@interface HumanViewController : LoginHandlerViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *view;
@property (nonatomic, strong) IBOutlet UIView *wrapper;

@property (nonatomic, strong) IBOutlet UIImageView *photo;

@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *role;
@property (nonatomic, strong) IBOutlet UITextField *company;

@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *telephone;
@property (nonatomic, strong) IBOutlet UITextField *location;

@property (nonatomic, strong) IBOutlet UIButton *inButton;
@property (nonatomic, strong) IBOutlet UIButton *fbButton;

@end
