//
//  DemoViewController.m
//  InEvent
//
//  Created by Pedro Góes on 11/01/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "DemoViewController.h"
#import "SimulationViewController.h"

@interface DemoViewController ()

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *descriptions;

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Right Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Próxima", nil) style:UIBarButtonItemStyleDone target:self action:@selector(showSimulator)];
    
    // We need to setup up our content here
    _images = @[@"finish", @"meio ambiente.jpg", @"MoneyTimeEffort.jpg"];
    _titles = @[NSLocalizedString(@"Preservação", nil), NSLocalizedString(@"Poupa tempo", nil), NSLocalizedString(@"Economiza água", nil)];
    _descriptions = @[NSLocalizedString(@"Usa menos água, energia e economiza dinheiro e contribui para o uso racional de recursos naturais.", nil), NSLocalizedString(@"É possível economizar cerca de 310 horas - ou quase 13 dias inteiros de folga.", nil), NSLocalizedString(@"Aproximadamente 733L de água por ano.", nil),];
    
    _pageControl.numberOfPages = [_titles count];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setUp];
}

- (void)setUp {

    // Clean up first
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGRect frame = CGRectZero;
    
    // And then set some content
    for (int i = 0; i < [_titles count]; i++) {
        // Image
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame = CGRectMake(self.view.frame.size.width * (i + 0.5) - 72.0, 66.0, 144.0, 144.0);
        } else {
            frame = CGRectMake(self.view.frame.size.width * (i + 0.225) - 72.0, 44.0, 144.0, 144.0);
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
        [imageView setImage:[UIImage imageNamed:[_images objectAtIndex:i]]];

        // Title
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame = CGRectMake(self.view.frame.size.width * (i + 0.0625), 304.0, self.view.frame.size.width * 0.875, 31.0);
        } else {
            frame = CGRectMake(self.view.frame.size.width * (i + 0.48), 20.0, self.view.frame.size.width * 0.48, 63.0);
        }
        
        UILabel *title = [[UILabel alloc] initWithFrame:frame];
        [title setText:[_titles objectAtIndex:i]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setNumberOfLines:2];
        [title setBackgroundColor:[UIColor whiteColor]];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
        [title setFont:[UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline] size:24.0f]];
        [title setTextColor:[ColorThemeController tableViewCellTextColor]];
        [title setHighlightedTextColor:[ColorThemeController tableViewCellTextHighlightedColor]];
        
        // Description
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame = CGRectMake(self.view.frame.size.width * (i + 0.0625), 333.0, self.view.frame.size.width * 0.875, 85.0);
        } else {
            frame = CGRectMake(self.view.frame.size.width * (i + 0.48), 91.0, self.view.frame.size.width * 0.48, 145.0);
        }
        
        UILabel *description = [[UILabel alloc] initWithFrame:frame];
        [description setText:[_descriptions objectAtIndex:i]];
        [description setTextAlignment:NSTextAlignmentCenter];
        [description setNumberOfLines:0];
        [description setBackgroundColor:[UIColor whiteColor]];
        [description setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
        [description setFont:[UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody] size:16.0f]];
        [description setHighlightedTextColor:[ColorThemeController tableViewCellTextColor]];
        [description setTextColor:[ColorThemeController tableViewCellTextHighlightedColor]];
        
        [self.scrollView addSubview:imageView];
        [self.scrollView addSubview:title];
        [self.scrollView addSubview:description];
    }
    
    // Update the scroll size
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * [_titles count], self.view.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Reload the content on the right position
    [self setUp];
    
    // Scroll to the beginning
    [self.scrollView scrollRectToVisible:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) animated:NO];
}

#pragma mark - User Methods

- (void)showSimulator {
    [self.navigationController pushViewController:[[SimulationViewController alloc] initWithNibName:@"SimulationViewController" bundle:nil] animated:YES];
}

#pragma mark - Scroll Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = floor(self.scrollView.contentOffset.x / self.view.frame.size.width);
    _pageControl.currentPage = page;
}


@end
