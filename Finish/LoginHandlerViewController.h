//
//  LoginHandlerViewController.h
//  InEvent
//
//  Created by Pedro Góes on 25/02/14.
//  Copyright (c) 2014 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WrapperViewController.h"

@class HumanViewController;

@interface LoginHandlerViewController : WrapperViewController

- (void)loginOnLinkedInWithBlock:(void (^)(NSString *accessToken))apiBlock;
- (void)loginOnFacebookWithBlock:(void (^)(NSString *accessToken))apiBlock;

@end
