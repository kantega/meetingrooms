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
#import "SlidingView.h"
#import "DateUtil.h"

@interface TotalViewController ()

@end

@implementation TotalViewController

@synthesize locationLabel = _locationLabel;
@synthesize dataController = _dataController;
@synthesize location = _location;

int rowHeight = 32;
Meeting *focusedMeeting =  nil;
SlidingView *focusedMeetingView = nil;

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
    
    focusedMeeting = [[Meeting alloc] init:nil end:nil owner:@"" subject:@"" ];
    
    // Add an observer that will respond to user tapping on a meeting
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meetingFocused:) 
                                                 name:@"meetingFocused" object:nil];   
    
    NSArray *meetingRooms = [self.dataController getMeetingRoomsWithMeetings:self.location];
    
    AppointmentsRow *timeline = [[AppointmentsRow alloc] initWithFrame:CGRectMake(60,120,900.0, (rowHeight * meetingRooms.count))];
    [timeline clipsToBounds];
    [timeline drawTimeline];
 
    [self.view addSubview:timeline];
    NSMutableDictionary *buttonMap = [[NSMutableDictionary alloc] init];
    
    int offsetY = 140;
    for (MeetingRoom *room in meetingRooms) {
    
        AppointmentsRow *row = [[AppointmentsRow alloc] initWithFrame:CGRectMake(60,offsetY,900.0,rowHeight)];
        row.room = room;
        row.buttonMap = buttonMap;
        row.focusedMeeting = focusedMeeting;
        [self.view addSubview:row];
        [row refresh];
        offsetY += rowHeight;
    }
    
    
}

// Event listener called when meeting is tapped on by user
- (void)meetingFocused:(NSNotification *)note {
    CGRect frame = CGRectMake(600, 400, 250,280);
    focusedMeetingView = [[SlidingView alloc] initWithFrame:frame 
                                                   headline:focusedMeeting.subject 
                                                      start:[DateUtil hourAndMinutes:focusedMeeting.start] 
                                                       stop:[DateUtil hourAndMinutes:focusedMeeting.end] 
                                                      owner:focusedMeeting.owner];
    [self.view addSubview:focusedMeetingView];
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
