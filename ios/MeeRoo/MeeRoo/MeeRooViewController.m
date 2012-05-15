//
//  MeeRooViewController.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 08.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "MeeRooViewController.h"
#import "MeeRooDataController.h"
#import "ConfigurationViewController.h"
#import "Meeting.h"
#import "DateUtil.h"


@interface MeeRooViewController ()

@end

@implementation MeeRooViewController

@synthesize roomLabel = _roomLabel;
@synthesize clockLabel = _clockLabel;
@synthesize colorLabel = _colorLabel;
@synthesize dataController = _dataController;

@synthesize meetingStartLabel, meetingEndLabel, meetingOwnerLabel, meetingSubjectLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
    
    // Add an observer that will respond to configuration changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configChanged:) 
                                                 name:@"configChanged" object:nil];
    
    //Set up timer to refresh display every 10 seconds
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];

}
    
// Event listener called when configuration changes
- (void)configChanged:(NSNotification *)note {
    [self configureView];           
}    

// Timer function to update clock and check availibility
-(void) onTimer:(NSTimer *)timer {
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)configureView
{
    printf("configureView\n");
    
    NSString *room = self.dataController.configuration.room;
    self.roomLabel.text = room;
    
    NSDate *now = [NSDate date];
    self.clockLabel.text = [DateUtil hourAndMinutes:now];
    
    Meeting *meeting = [self.dataController getMeeting:room time:(NSDate *) now];
    if (meeting == nil) {
        [self displayRoomAvailable];
    } else {
        [self displayRoomOccupied:meeting];
    }
    
}

- (void) displayRoomAvailable {
    printf("Available\n");
    self.colorLabel.backgroundColor = UIColor.greenColor;
    self.meetingStartLabel.text = @"";
    self.meetingEndLabel.text = @"";
    self.meetingOwnerLabel.text = @"";
    self.meetingSubjectLabel.text = @"";    
}

- (void)displayRoomOccupied: (Meeting *) meeting {
    printf("BUSY\n");
    self.colorLabel.backgroundColor = UIColor.redColor;
    self.meetingStartLabel.text = [DateUtil hourAndMinutes:meeting.start];
    self.meetingEndLabel.text = [DateUtil hourAndMinutes:meeting.end];
    self.meetingOwnerLabel.text = meeting.owner;
    self.meetingSubjectLabel.text = meeting.subject;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowConfiguration"]) {
        ConfigurationViewController *configController = [segue destinationViewController];
        configController.dataController = self.dataController;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
