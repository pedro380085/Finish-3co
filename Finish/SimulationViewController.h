//
//  SimulationViewController.h
//  Finish
//
//  Created by Pedro Góes on 07/12/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "WrapperViewController.h"

@interface SimulationViewController : WrapperViewController

@property (strong, nonatomic) IBOutlet UITextField *duration;
@property (strong, nonatomic) IBOutlet UITextField *times;
@property (strong, nonatomic) IBOutlet UILabel *consumption;

@end
