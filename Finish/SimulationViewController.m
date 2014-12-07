//
//  SimulationViewController.m
//  Finish
//
//  Created by Pedro Góes on 07/12/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "SimulationViewController.h"
#import "MachineViewController.h"

@interface SimulationViewController ()

@end

@implementation SimulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Right Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Próxima", nil) style:UIBarButtonItemStyleDone target:self action:@selector(showNext)];

    self.duration.leftViewMode = UITextFieldViewModeAlways;
    self.duration.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0f, 10.0f)];
    self.times.leftViewMode = UITextFieldViewModeAlways;
    self.times.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0f, 10.0f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)triggerCalculation:(id)sender {
    self.consumption.text = [NSString stringWithFormat:@"%.2fm³", ([self.duration.text floatValue] * [self.times.text floatValue] * 0.0138 * 30.0)];
}

- (void)showNext {
    MachineViewController *viewController = [[MachineViewController alloc] initWithNibName:@"MachineViewController" bundle:nil];
    viewController.consumption = ([self.duration.text floatValue] * [self.times.text floatValue] * 0.0138 * 30.0);
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(triggerCalculation:) withObject:nil afterDelay:0.5f];
    
    return YES;
}



@end
