//
//  BookingVC.m
//  MeeRoo2
//
//  Created by Maria Maria on 12/18/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import "BookingVC.h"

@interface BookingVC ()

@end

@implementation BookingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    
    UIView *temporaryView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    temporaryView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:temporaryView];
    [temporaryView release];
                    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
