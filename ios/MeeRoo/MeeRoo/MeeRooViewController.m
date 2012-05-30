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
#import "MeetingRoom.h"
#import "DateUtil.h"


@interface MeeRooViewController ()

@end

@implementation MeeRooViewController

@synthesize roomLabel = _roomLabel;
@synthesize clockLabel = _clockLabel;
@synthesize colorLabel = _colorLabel;
@synthesize dataController = _dataController;

@synthesize meetingStartLabel, meetingEndLabel, meetingOwnerLabel, meetingSubjectLabel, nextMeetingLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Set Kantega background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"1024x768_gronn.jpg"]];
    self.view.backgroundColor = background;
    
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
    
    MeetingRoom *room = self.dataController.configuration.room;
    self.roomLabel.text = room.displayname;
    
    NSDate *now = [NSDate date];
    self.clockLabel.text = [DateUtil hourAndMinutes:now];
    
    Meeting *meeting = [self.dataController getMeeting:room.mailbox filterfunction:@"now"];
    Meeting *nextMeeting = [self.dataController getMeeting:room.mailbox filterfunction:@"next"];
    if (meeting == nil) {
        [self displayRoomAvailable:nextMeeting];
    } else {
        [self displayRoomOccupied:meeting];
    }
    
    CGRect screen = [[UIScreen mainScreen] applicationFrame];
    self.colorLabel.frame = CGRectMake((screen.size.width / 2) - 25 , 0, 50, screen.size.height);
    
}

- (void) displayRoomAvailable: (Meeting *) nextMeeting {
    //printf("Available\n");
    self.colorLabel.backgroundColor = UIColor.greenColor;
    self.meetingStartLabel.text = @"";
    self.meetingEndLabel.text = @"";
    self.meetingOwnerLabel.text = @"";
    if (nextMeeting == nil) {
        self.meetingSubjectLabel.text = @"Møterommet et ledig resten av dagen";
        self.nextMeetingLabel.text = @"";
    } else {
        self.meetingSubjectLabel.text = [NSString stringWithFormat:@"%@%@", 
                                         @"Møterommet et ledig frem til kl. ", 
                                         [DateUtil hourAndMinutes:nextMeeting.start]];
        self.nextMeetingLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@", 
                                         @"Neste møte: ", 
                                         [DateUtil hourAndMinutes:nextMeeting.start],
                                      [DateUtil hourAndMinutes:nextMeeting.end],
                                      nextMeeting.subject];
 
    }
}

- (void)displayRoomOccupied: (Meeting *) meeting {
    //printf("BUSY\n");
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
