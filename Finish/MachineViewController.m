//
//  MachineViewController.m
//  Finish
//
//  Created by Pedro Góes on 07/12/14.
//  Copyright (c) 2014 Estúdio Trilha. All rights reserved.
//

#import "MachineViewController.h"
#import "SocialLoginViewController.h"

@interface MachineViewController () {
    NSArray *machines;
}

@end

@implementation MachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.contentSize = CGSizeMake(self.view.frame.size.width, 600.0f);
    
    // Right Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Próxima", nil) style:UIBarButtonItemStyleDone target:self action:@selector(showNext)];
    
    machines = @[_machine6, _machine8, _machine12, _machine14];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    unsigned long innerTag = ([machines count] - 1);
    
    if (_consumption < 1.3194) {
        innerTag = 0;
    } else if (_consumption < 1.7592) {
        innerTag = 1;
    } else if (_consumption < 2.7222) {
        innerTag = 2;
    } else if (_consumption < 3.162) {
        innerTag = 3;
    }
    
    for (int i = 0; i < [machines count]; i++) {
        if (i == innerTag) {
            [[machines objectAtIndex:i] setHidden:NO];
        } else {
            [[machines objectAtIndex:i] setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNext {
    [self.navigationController pushViewController:[[SocialLoginViewController alloc] initWithNibName:@"SocialLoginViewController" bundle:nil] animated:YES];
}

- (IBAction)openBrowser:(UIButton *)sender {
    
    NSURL *url;
    
    if (sender.tag == 0) {
        url = [NSURL URLWithString:@"http://lavaloucas.com.br/brastemp-clean-6-servicos"];
    } else if (sender.tag == 1) {
        url = [NSURL URLWithString:@"http://lavaloucas.com.br/brastemp-ative-8-servicos"];
    } else if (sender.tag == 2) {
        url = [NSURL URLWithString:@"http://lavaloucas.com.br/brastemp-ative-12-servicos"];
    } else if (sender.tag == 3) {
        url = [NSURL URLWithString:@"http://lavaloucas.com.br/brastemp-gourmand-14-servicos"];
    }
    
    UIViewController *viewController = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [viewController.view addSubview:webView];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
