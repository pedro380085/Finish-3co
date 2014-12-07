//
//  SocialLoginViewController.h
//  InEvent
//
//  Created by Pedro Góes on 25/10/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginHandlerViewController.h"

@class HumanViewController;

@interface SocialLoginViewController : LoginHandlerViewController

@property (nonatomic, strong) IBOutlet UILabel *socialLabel;
@property (nonatomic, strong) IBOutlet UIButton *inButton;
@property (nonatomic, strong) IBOutlet UIButton *fbButton;
@property (nonatomic, strong) IBOutlet UIView *separator1;
@property (nonatomic, strong) IBOutlet UIButton *accountLabel;

@end
