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

int rowHeight = 32;

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
	
    //Set Kantega background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"1024x768_gronn.jpg"]];
    self.view.backgroundColor = background;
    
    // Do any additional setup after loading the view.
    self.locationLabel.text = self.location;
    
    NSArray *meetingRooms = [self.dataController getMeetingRoomsWithMeetings:self.location];
    
    AppointmentsRow *timeline = [[AppointmentsRow alloc] initWithFrame:CGRectMake(60,120,900.0, (rowHeight * meetingRooms.count))];
    [timeline clipsToBounds];
/*    CGRect frame = [timeline frame];
    frame.origin.x = 5;
    [timeline setFrame:frame];
 */
    [timeline drawTimeline];
 
    [self.view addSubview:timeline];
    NSMutableDictionary *buttonMap = [[NSMutableDictionary alloc] init];
    
    int offsetY = 140;
    for (MeetingRoom *room in meetingRooms) {
    
        AppointmentsRow *row = [[AppointmentsRow alloc] initWithFrame:CGRectMake(60,offsetY,900.0,rowHeight)];
        row.room = room;
        row.buttonMap = buttonMap;
        [self.view addSubview:row];
        [row refresh];
        offsetY += rowHeight;
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
