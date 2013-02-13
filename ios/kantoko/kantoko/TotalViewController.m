//
//  TotalViewController.m
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "TotalViewController.h"

#import "AppointmentsRowView.h"
#import "KantokoDataController.h"
#import "SlidingView.h"
#import "DateUtil.h"

#import "TimeplanlappView.h"
#import "TimeplanlappTimerView.h"

@interface TotalViewController ()

@end

@implementation TotalViewController


@synthesize toolbar;
@synthesize dataController, locationLabel, location;


int rowHeight = 0;

TimeplanlappView *detailsView = nil;
NSTimer *timerToClose = nil;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog (@"TVC init");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
 


-(void)loadView{
    
    NSLog(@"loadView");
    
    UIView *customView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    customView.backgroundColor = [UIColor clearColor];
    
    double x = (1024.0 - 200.0)/2.0;

    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake( x, 45, 250, 40)];
    self.locationLabel.text = @"location";
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    [self.locationLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:35.0]];
    self.locationLabel.textColor = [UIColor whiteColor];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    [customView addSubview:self.locationLabel];
    
    //create toolbar using new
    self.toolbar = [UIToolbar new];
    self.toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.toolbar sizeToFit];
    //31 aug 12: Denne frame brukes når navController.navigationBarHidden er nei
    //toolbar.frame = CGRectMake(0, 748 - (44 *2), 1024, 44);
    self.toolbar.frame = CGRectMake(0, 748 - 44, 1024, 44);
    
    
    //Add buttons
    UIBarButtonItem *systemItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Tilbake" style:UIBarButtonItemStyleBordered
                                                                   target:self
                                    
                                                                   action:@selector(tilbakeMetode:)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects: systemItem1, nil];
    
    //add array of buttons to toolbar
    [self.toolbar setItems:itemsArray animated:NO];
    
    [customView addSubview:self.toolbar];
    
    self.view = customView;
}

-(void)tilbakeMetode:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    
    self.toolbar = nil;
    self.location = nil;
    self.locationLabel = nil;    
}


- (void)viewDidLoad
{
    
    NSLog(@"viewdidload");
    [super viewDidLoad];

	
    //Set Kantega background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"1024x768_gronn.jpg"]];
    self.view.backgroundColor = background;
    
    self.locationLabel.text = self.location;
    
    // Add an observer that will respond to user tapping on a meeting orange bar or the close button on details
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meetingBarTouched:) name:@"meetingBarTouched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeButtonTouchedOnDetails:) name:@"closeButtonTouchedOnDetails" object:nil];
    
    NSArray *meetingRooms = [self.dataController getMeetingRoomsWithMeetings:self.location];
    NSLog (@"meetingRooms %@", meetingRooms);
    NSUInteger mrCount = [meetingRooms count];
    

    //18 sep 12: Få tilpasset rowHeight til begge kontorene:
    if ([self.location isEqualToString:@"Trondheim"]){
        
        rowHeight = 64;
        
    }
    else if ([self.location isEqualToString:@"Oslo"]){

        
        rowHeight = 320 / mrCount;
        NSLog(@"Oslo rowHeight er %u", rowHeight);
        
    }

    //original per 18 sep 12
    //AppointmentsRow2 *timeline = [[AppointmentsRow2 alloc] initWithFrame:CGRectMake(60,120,900.0, ((rowHeight/2) * meetingRooms.count))];
    
    //18 sep 12, høyde for timeline, forskjellig for Oslo og Trondheim
    int timelineHoyde = 0;

    if ([self.location isEqualToString:@"Trondheim"]){
        timelineHoyde = ((rowHeight/2) * meetingRooms.count) - 5;

    }
    else if ([self.location isEqualToString:@"Oslo"]){
        timelineHoyde = ((rowHeight/2) * meetingRooms.count) + 5;

    }
    

    
    AppointmentsRowView *timeline = [[AppointmentsRowView alloc] initWithFrame:CGRectMake(60,120,900.0, timelineHoyde)];
    [timeline clipsToBounds];
    [timeline drawTimeline];
    
    [self.view addSubview:timeline];
    
    NSLog(@" kontoret til trondheims height er %u", ((rowHeight/2)* meetingRooms.count));

    
    NSMutableDictionary *buttonMap = [[NSMutableDictionary alloc] init];
    
    //original
    //int offsetY = 140;
    
    //18 sep 12
    int offsetY = 150; //vertikalt offset for horisontale linjer, altså linjene inkl romnavn og oransjelinjen fra klokkeslettene
    
    //18 sep 12 samme høyde for linjene i begge timeplanene
    int oransjeHeight = 30;

    for (MeetingRoom *room in meetingRooms) {
        
        NSLog(@"MeetingRoom");
        
        AppointmentsRowView *row = [[AppointmentsRowView alloc] initWithFrame:CGRectMake(30,offsetY,930.0, oransjeHeight)];
        row.room = room;
        [self.view addSubview:row];
        [row refresh];
        offsetY += rowHeight;
    }
}


- (void)meetingBarTouched:(NSNotification *)notification {
     
    Meeting *meeting = [notification object];
    if (!meeting) { NSLog(@"Ingen møte sendt i notification"); return; }

    [self closeDetailViewIfVisible];
    detailsView = [[TimeplanlappView alloc] initWithFrame:CGRectMake(215, 500, 480,180) andMeeting:meeting]; 
    timerToClose = [NSTimer scheduledTimerWithTimeInterval:5.0
                            target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    
    [self.view addSubview:detailsView];
}

- (void)closeButtonTouchedOnDetails:(NSNotification *)notification {
    [self closeDetailViewIfVisible];
}

-(void)timerMethod:(NSTimer*)timer{
    [self closeDetailViewIfVisible];
}

-(void)closeDetailViewIfVisible {
    if (timerToClose) { [timerToClose invalidate]; }
    if (detailsView) { [detailsView removeFromSuperview]; };    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
    
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)didReceiveMemoryWarning{
    NSLog(@"Memory Warning in TotalViewController2");
}


@end
