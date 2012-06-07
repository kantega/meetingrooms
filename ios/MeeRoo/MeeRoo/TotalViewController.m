//
//  TotalViewController.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 07.06.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "TotalViewController.h"
#import "AppointmentsRow.h"
#import "MeeRooDataController.h"

@interface TotalViewController ()

@end

@implementation TotalViewController

@synthesize locationLabel = _locationLabel;
@synthesize dataController = _dataController;
@synthesize location = _location;

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
	// Do any additional setup after loading the view.
    self.locationLabel.text = self.location;
    
    NSArray *meetingRooms = [self.dataController getMeetingRoomsWithMeetings:self.location];
    int offsetY = 120;
    for (MeetingRoom *room in meetingRooms) {
    
        AppointmentsRow *row = [[AppointmentsRow alloc] initWithFrame:CGRectMake(60,offsetY,900.0,24.0)];
        row.roomName = room.mailbox;
        row.backgroundColor = [UIColor grayColor];
        [self.view addSubview:row];
        [row refresh];
        offsetY += 30;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
