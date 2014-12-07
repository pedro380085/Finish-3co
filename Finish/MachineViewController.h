//
//  MachineViewController.h
//  Finish
//
//  Created by Pedro Góes on 07/12/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "WrapperViewController.h"

@interface MachineViewController : WrapperViewController

@property (strong, nonatomic) IBOutlet UIScrollView *view;

@property (strong, nonatomic) IBOutlet UILabel *machine6;
@property (strong, nonatomic) IBOutlet UILabel *machine8;
@property (strong, nonatomic) IBOutlet UILabel *machine12;
@property (strong, nonatomic) IBOutlet UILabel *machine14;

@property (assign, nonatomic) CGFloat consumption;

@end
