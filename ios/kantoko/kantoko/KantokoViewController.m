//
//  KantokoViewKontroller.m (was: MeeRooViewController.m)
//  Kantoko
//
//  Created by Øyvind Kringlebotn on 08.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "KantokoViewController.h"
#import "KantokoDataController.h"
#import "ConfigurationViewController.h"
#import "TotalViewController.h"
#import "Meeting.h"
#import "MeetingRoom.h"
#import "DateUtil.h"
#import "CustomScrollView.h"
#import "Configuration.h"


@interface KantokoViewController ()

@end

@implementation KantokoViewController

@synthesize roomLabel = _roomLabel;
@synthesize clockLabel = _clockLabel;
@synthesize colorLabel = _colorLabel;
@synthesize meetingStartLabel, meetingEndLabel, meetingOwnerLabel, meetingSubjectLabel, nextMeetingLabel, tabbar;

@synthesize toolbar, dataController;

@synthesize scrollView;

@synthesize klokkeLabel, moteromLabel;

@synthesize timerForMeeRooVC;

static KantokoViewController *_viewControllerInstance = nil;

UILabel* _statusLabel = nil;

+(KantokoViewController*) getInstance{
    if (_viewControllerInstance == nil) {
        _viewControllerInstance = [[KantokoViewController alloc] init];
        _viewControllerInstance.dataController = [[KantokoDataController alloc] init];
    }
    return _viewControllerInstance;
}

+(Configuration*) getCurrentConfiguration{
    if (_viewControllerInstance == nil) { return nil; }
    return _viewControllerInstance.dataController.configuration;
}


-(void)loadView{

    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)] ;
    customView.autoresizesSubviews = YES;
    customView.clipsToBounds = NO;
    customView.opaque = YES;
    customView.clearsContextBeforeDrawing = YES;
    customView.userInteractionEnabled = YES;
    self.view = customView;
    
    self.klokkeLabel = [[UILabel alloc]initWithFrame:CGRectMake(385,-11,181,93)];
    self.klokkeLabel.text = @"klokke";
    [self.klokkeLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:42.0]];
    self.klokkeLabel.textColor = [UIColor whiteColor];
    self.klokkeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.klokkeLabel];
    
    
    self.moteromLabel = [[UILabel alloc]initWithFrame:CGRectMake(555,-11,400,93)];
    self.moteromLabel.text = @"møterom";
    [self.moteromLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:42.0]];
    self.moteromLabel.textColor = [UIColor whiteColor];
    self.moteromLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.moteromLabel];
    
    self.scrollView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0,90,1032,581)];
    self.scrollView.delegate = self.scrollView;
    [self.view addSubview:self.scrollView];
      
    // tabBar med knapper
    tabbar = [[UITabBar alloc]initWithFrame:CGRectMake(0,748 - 60, 1024,60)];
    tabbar.delegate = self;
    tabbar.tintColor = [UIColor blackColor];
    
    UIImage *icon1 = [UIImage imageNamed: @"oslo.png"];
    UIImage *icon2 = [UIImage imageNamed: @"trondheim.png"];
    UIImage *icon3 = [UIImage imageNamed: @"instillinger.png"];
    
    UITabBarItem *systemItem1 = [[UITabBarItem alloc] initWithTitle:@"Oslo" image:icon1 tag:1];
    UITabBarItem *systemItem2 = [[UITabBarItem alloc] initWithTitle:@"Trondheim" image:icon2 tag:2];
    UITabBarItem *systemItem3 = [[UITabBarItem alloc] initWithTitle: @"Innstillinger" image:icon3 tag:3];
    
    NSArray *itemsArray = [NSArray arrayWithObjects: systemItem1, systemItem2, systemItem3, nil];

    [tabbar setItems:itemsArray animated:NO];
    
    [self.view addSubview:tabbar];    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if (item.tag == 1){

        [self pressButton1:self];
        
    }else if (item.tag == 2){

        [self pressButton2:self];
        
    }else if (item.tag == 3){

        [self pressButton3:self];
        
    }else{
        NSLog(@"Bad value of item.tag!");
    }
    
}


-(void)pressButton1:(id)sender
{
    TotalViewController *totalVC = [[TotalViewController alloc] init];
    totalVC.dataController = self.dataController;
    totalVC.location = @"Oslo";
    [self.navigationController pushViewController:totalVC animated:YES];
}

-(void)pressButton2:(id)sender
{
    TotalViewController *trondheimVC = [[TotalViewController alloc] init];
    trondheimVC.dataController = self.dataController;
    trondheimVC.location = @"Trondheim";
    [self.navigationController pushViewController:trondheimVC animated:YES];
}

-(void)pressButton3:(id)sender
{
    ConfigurationViewController *configVC = [[ConfigurationViewController alloc] init];
    configVC.dataController = self.dataController;
    [self.navigationController pushViewController:configVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set Kantega background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"1024x768_gronn.jpg"]];
    self.view.backgroundColor = background;
    
    
    [self configureView];

    
    // Add an observer that will respond to configuration changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configChanged:)
                                                 name:@"configChanged" object:nil];
        
    //Set up timer to refresh display every 10 seconds
    self.timerForMeeRooVC = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollView.clipsToBounds = NO; 
}

// Event listener called when configuration changes
- (void)configChanged:(NSNotification *)note {
    [self configureView];
}

// Timer function to update clock and check availibility
-(void) onTimer:(NSTimer *)timer {
    [self configureView];
}

-(void) stopTimer{
    [self.timerForMeeRooVC invalidate];
}

-(void)restartTimer{
    //NSLog(@"restartTimer without parameter");
    [self.timerForMeeRooVC invalidate];
    self.timerForMeeRooVC = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self configureView];
}


-(NSTimer*)getTimer{
    //NSLog(@"got Timer");
    return self.timerForMeeRooVC;
    
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.timerForMeeRooVC = nil;
    self.klokkeLabel = nil;
    self.moteromLabel = nil;
    
    [super viewDidUnload];    
}


-(void)dealloc{
    
    self.klokkeLabel = nil;
    self.moteromLabel = nil;
    self.timerForMeeRooVC = nil;
    self.scrollView = nil;
}

-(void)didReceiveMemoryWarning{
    NSLog(@"Memory Warning in MVC3");    
}

-(void)showNotificationMessage:(NSString*)message{
    if (_statusLabel == nil) {
        CGSize mainViewSize = self.view.bounds.size;
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainViewSize.width / 4, mainViewSize.height * 2 / 3, mainViewSize.width / 2, 100)];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.backgroundColor = [UIColor blackColor];
        _statusLabel.font = [UIFont systemFontOfSize:24.0f];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_statusLabel];
    }
    
    _statusLabel.text = message;
    _statusLabel.alpha = 1.0f;
    [UIView animateWithDuration:3.0f animations:^ { [_statusLabel setAlpha:0.00f]; }];
}

-(void)updateViewAfterChanges {  
    NSTimer *delayedRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    [self restartTimer];
}

- (void)configureView
{
    MeetingRoom *room = self.dataController.configuration.room;
    self.moteromLabel.text = room.displayname;
    
    NSDate *now = [NSDate date];
    self.klokkeLabel.text = [DateUtil hourAndMinutes:now];
    
    // Fjerner gamle subviews
    for(UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }     
    
    NSArray *todaysMeetings = [self fillInMeetingsWithVacantSpots:[self.dataController getTodaysMeetingInRoom:[room mailbox]]];
 
    int index = 0;
    int currentMeetingIndex = - 1;
    
    for (Meeting *meeting in todaysMeetings) {
        if (meeting.isNow) {
            currentMeetingIndex = index;
            break;
        }
        index++;
    }
    
    if (currentMeetingIndex == -1){
        Meeting *firstMeeting = [todaysMeetings objectAtIndex:0];
        currentMeetingIndex = ([DateUtil date:firstMeeting.start isAfterDate:now]) ? 0 : [todaysMeetings count] - 1;
    }
    
    int currentBoxOffset = 0;
    int previousBoxWidth = 0;
    index = 0;
    
    NSLog(@"currentMeetingIndex %i", currentMeetingIndex);
    NSLog(@"======================");
    NSLog(@"  REFRESH MEETINGS");
    NSLog(@"======================");
    
    for (Meeting *meeting in todaysMeetings) {

        CGFloat boxWidth = index == currentMeetingIndex ? CustomScrollView.largeBoxWidth : CustomScrollView.smallBoxWidth;
        CGFloat boxHeight = index == currentMeetingIndex ? CustomScrollView.largeBoxHeight : CustomScrollView.smallBoxHeight;
        
        currentBoxOffset += (previousBoxWidth + CustomScrollView.boxSpacing);
        CGRect frame = CGRectMake(currentBoxOffset, 0, boxWidth, boxHeight);
        
        // Default text, om det er tom subject i serveren.
        if ([meeting.subject isEqualToString:@""]){
            meeting.subject = @"Opptatt";
        }
        
        NSLog(@"møte %i start: %@", index, [meeting.start descriptionWithLocale:[NSLocale currentLocale]]);
        NSLog(@"møte %i end  : %@", index, [meeting.end descriptionWithLocale:[NSLocale currentLocale]]);
        
        SlidingView *meetingView = [[SlidingView alloc] initWithFrame:frame andMeeting:meeting];
        
        [self.scrollView addSubview:meetingView];
        index++;
        previousBoxWidth = boxWidth;
    }
    
    [self.scrollView setShowsHorizontalScrollIndicator:YES];
    
    float scrollWidth = 0;
    
    // Forebygger at scrollviewen som har kun ett møtelapp sitter fastlåst
    // 15 jan 13: Gjorde om index == 1 til index == 0 og index > 1 til index > 0
    if (index == 0){
        scrollWidth = 1074;
    }else if (index > 0){
        scrollWidth = CustomScrollView.largeBoxWidth + (CustomScrollView.smallBoxWidth * (index + 1)) + 80 ;
    }

    
    [self.scrollView setContentSize:CGSizeMake(scrollWidth, 581)];

    
    if (index > 0) {
        NSLog(@"scroll to %i", currentMeetingIndex);
        [self.scrollView scrollToBoxAt:currentMeetingIndex + 1];
    }
}



- (NSArray *) fillInMeetingsWithVacantSpots:(NSArray *) meetings {
    
    NSMutableArray *meetingsWithVacantSpots = [[NSMutableArray alloc] init];
    NSDate *startOfDay = [DateUtil startOfToday];
    NSDate *endOfDay = [DateUtil endOfToday];
    NSString* ownerStr = @"Ledig møtetidspunkt";
    NSString* subjectStr = @"Ledig";
    
    if ([meetings count] == 0) {
        Meeting *vacantMeeting = [[Meeting alloc] init:startOfDay end:endOfDay owner:ownerStr subject:subjectStr];
        [meetingsWithVacantSpots addObject:vacantMeeting];
        return meetingsWithVacantSpots;
    }
    
    Meeting *firstMeeting = [meetings objectAtIndex:0];
    NSDate *firstMeetingStart = [DateUtil roundToClosestQuarter:firstMeeting.start];
    if ([DateUtil date:firstMeetingStart isAfterDate:startOfDay]) {
        Meeting *vacantMeeting = [[Meeting alloc] init:startOfDay end:firstMeeting.start owner:ownerStr subject:subjectStr];
        [meetingsWithVacantSpots addObject:vacantMeeting];
    }
    [meetingsWithVacantSpots addObject:firstMeeting];
    
    for(NSInteger i = 1; i < [meetings count]; i++) {
        Meeting *previousMeeting = [meetings objectAtIndex:i - 1];
        NSDate *endOfPreviousMeeting = [DateUtil roundToClosestQuarter:previousMeeting.end];
        Meeting *currentMeeting = [meetings objectAtIndex:i];
        NSDate *startOfCurrentMeeting = [DateUtil roundToClosestQuarter:currentMeeting.start];
        if ([DateUtil date:startOfCurrentMeeting isAfterDate:endOfPreviousMeeting]) {
            Meeting *vacantMeeting = [[Meeting alloc] init:previousMeeting.end end:currentMeeting.start owner:ownerStr subject:subjectStr];
            [meetingsWithVacantSpots addObject:vacantMeeting];
        }
        [meetingsWithVacantSpots addObject:currentMeeting];
    }
             
    Meeting *lastMeeting = [meetings objectAtIndex:[meetings count] - 1];
    NSDate *lastMeetingEnd = [DateUtil roundToClosestQuarter:lastMeeting.end];
    if ([DateUtil date:endOfDay isAfterDate:lastMeetingEnd]) {
         Meeting *vacantMeeting = [[Meeting alloc] init:lastMeetingEnd end:endOfDay owner:ownerStr subject:subjectStr];
         [meetingsWithVacantSpots addObject:vacantMeeting];
    }
    
    return meetingsWithVacantSpots;
}


// Brukes til logging
- (void) dumpPositions {
    int index = 0;
    printf("\n");
    for (UIView *view in [self.scrollView subviews]) {
        CGRect frame = view.frame;
        NSLog(@"frame in dumpPositions : %@", NSStringFromCGRect(frame));
        
        index++;
    }
    printf("\n");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

@end
