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
#import "TotalViewController.h"
#import "Meeting.h"
#import "MeetingRoom.h"
#import "DateUtil.h"
#import "CustomScrollView.h"
#import "SlidingView.h"


@interface MeeRooViewController ()

@end

@implementation MeeRooViewController
@synthesize scrollView = _scrollView;
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

    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.clipsToBounds = NO;
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
    [self setScrollView:nil];
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
    
    for(UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    
    NSArray *todaysMeetings = [self fillInMeetingsWithVacantSpots:[self.dataController getTodaysMeetingInRoom:[room mailbox]]];
    
    int index = 0;
    int currentMeetingIndex = 0;
    for (Meeting *meeting in todaysMeetings) {
        NSLog(@"Adding room to scrollview at index: %i", index);
        CGFloat boxWidth = _scrollView.smallBoxWidth;
        CGFloat boxHeight = _scrollView.smallBoxHeight;
        if (index == 0) {
            boxWidth = _scrollView.largeBoxWidth;
            boxHeight = _scrollView.largeBoxHeight;
        }
        CGRect frame = CGRectMake([_scrollView leftMostPointAt:index], 0, boxWidth, boxHeight);
        
        SlidingView *meetingView = [[SlidingView alloc] initWithFrame:frame headline:[meeting subject] start:[DateUtil hourAndMinutes:[meeting start]] stop:[DateUtil hourAndMinutes:[meeting end]] owner:[meeting owner]];
        [_scrollView addSubview:meetingView];
        if (meeting.isNow) {
            NSLog(@"Current meeting(%i): %@", index, meeting.subject);
            currentMeetingIndex = index;
        }
        index++;
    }
    
    [_scrollView setShowsHorizontalScrollIndicator:YES];
    float scrollWidth = [_scrollView smallBoxWidth] * (index + 4) + [_scrollView boxSpacing] * index;
    [_scrollView setContentSize:CGSizeMake(scrollWidth, 581)];
    
    if (index > 0) {
        NSLog(@"scroll to %i", currentMeetingIndex);
        [_scrollView scrollToBoxAt:currentMeetingIndex + 1];
    }
    
}

- (NSArray *) fillInMeetingsWithVacantSpots:(NSArray *) meetings {
    NSMutableArray *meetingsWithVacantSpots = [[NSMutableArray alloc] init];
    
    if ([meetings count] == 0) {
        //Hvis ingen møter, legg til ledig møtetidspunkt fra 8 til 17
        NSDate *meetingStart = [DateUtil startOfToday];
        NSDate *meetingEnd = [DateUtil endOfToday];

        Meeting *vacantMeeting = [[Meeting alloc] init:meetingStart end:meetingEnd owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
        [meetingsWithVacantSpots addObject:vacantMeeting];
    } else if ([meetings count] > 0) {
        //Hvis første møte starter etter 08:15, legg til et ledig møte tidlig på dagen
        Meeting *firstMeeting = [meetings objectAtIndex:0];
        
        NSDate *startOfToday = [DateUtil startOfToday];
        NSTimeInterval interval = [[firstMeeting start] timeIntervalSinceDate:startOfToday];
        
        if (interval > (15 * 60)) {
            Meeting *vacantMeeting = [[Meeting alloc] init:startOfToday end:[firstMeeting start] owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
            
            [meetingsWithVacantSpots addObject:vacantMeeting];
        }
    }
    
    int index = 0;
    for (Meeting *meeting in meetings) {
        [meetingsWithVacantSpots addObject:meeting];
        if ([meetings count] > (index+1)) {
            //Det finnes flere møter i dag
            Meeting *nextMeeting = [meetings objectAtIndex:(index +1)];
            NSDate *thisMeetingEnd = [meeting end];
            NSDate *nextMeetingStart = [nextMeeting start];
            
            
            NSTimeInterval interval = [nextMeetingStart timeIntervalSinceDate:thisMeetingEnd];
            
            if (interval > (15 * 60)) {
                //Mørerommet må være ledig i mist 15 minutter/600 sekunder
                Meeting *vacantMeeting = [[Meeting alloc] init:thisMeetingEnd end:nextMeetingStart owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
                [meetingsWithVacantSpots addObject:vacantMeeting];
            }
            
        } else {
            //Dagens siste møterom
            NSDate *thisMeetingEnd = [meeting end];            
            NSDate *nextMeetingEnd = [DateUtil endOfToday];
            
            Meeting *vacantMeeting = [[Meeting alloc] init:thisMeetingEnd end:nextMeetingEnd owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
            [meetingsWithVacantSpots addObject:vacantMeeting];
        }
        
        index++;
    }
            
    return meetingsWithVacantSpots; 
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
    if ([[segue identifier] isEqualToString:@"showOslo"]) {
        TotalViewController *totalController = [segue destinationViewController];
        totalController.dataController = self.dataController;
        totalController.location = @"Oslo";
    }
    if ([[segue identifier] isEqualToString:@"showTrondheim"]) {
        TotalViewController *totalController = [segue destinationViewController];
        totalController.dataController = self.dataController;
        totalController.location = @"Trondheim";
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

#pragma mark scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    if ([[scrollView subviews] count] > 2) {
        float contentOffset = scrollView.contentOffset.x;
        int leavingElementIndex = [_scrollView indexOfElementLeavingScene:scrollView.contentOffset.x];
        
        if (leavingElementIndex > ([[_scrollView subviews] count] -2)) {
            leavingElementIndex = [[_scrollView subviews] count] -2;
        }
        
        int entereingElementIndex = leavingElementIndex + 1;
    
        if (leavingElementIndex >= 0 && contentOffset > 0) {
            CGRect leavingFrame = [[[scrollView subviews] objectAtIndex:leavingElementIndex] frame];
            CGRect enteringFrame = [[[scrollView subviews] objectAtIndex:entereingElementIndex] frame];
        
            float scalePerentage = (contentOffset - (_scrollView.smallBoxWidth * leavingElementIndex))/(_scrollView.smallBoxWidth);
        
            if (scalePerentage > 1) {
                scalePerentage = 1;
            }

            enteringFrame.size.width = _scrollView.smallBoxWidth + (_scrollView.smallBoxWidth * scalePerentage);
            enteringFrame.size.height = _scrollView.smallBoxHeight + (_scrollView.smallBoxHeight * scalePerentage);
            enteringFrame.origin.x = [_scrollView leftMostPointAt:entereingElementIndex] - (_scrollView.smallBoxWidth * scalePerentage);
        
            [[[scrollView subviews] objectAtIndex:entereingElementIndex] setFrame:enteringFrame];
        
            leavingFrame.size.width = _scrollView.largeBoxWidth - (_scrollView.smallBoxWidth * scalePerentage);
            leavingFrame.size.height = _scrollView.largeBoxHeight - (_scrollView.smallBoxHeight * scalePerentage);
        
            [[[scrollView subviews] objectAtIndex:leavingElementIndex] setFrame:leavingFrame];
        
            //Reset the other visible frames sizes
            int index = 0;
            for (UIView *view in [scrollView subviews]) {
                if([view isKindOfClass:[SlidingView class]] && index > entereingElementIndex) {
                    CGRect frame = view.frame;
                    frame.size.width = _scrollView.smallBoxWidth;
                    frame.size.height = _scrollView.smallBoxHeight;
                    frame.origin.x = [_scrollView leftMostPointAt:index];
                    [view setFrame:frame];
                }
            
                index++;
            } 
        }
    }
}


@end
