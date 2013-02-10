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
#import "SlidingView.h"
#import "Configuration.h"


@interface KantokoViewController ()

@end

@implementation KantokoViewController

@synthesize roomLabel = _roomLabel;
@synthesize clockLabel = _clockLabel;
@synthesize colorLabel = _colorLabel;
@synthesize meetingStartLabel, meetingEndLabel, meetingOwnerLabel, meetingSubjectLabel, nextMeetingLabel;

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
    self.scrollView.delegate = self;
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
        //_statusLabel.center = CGPointMake(mainViewSize.width / 2, mainViewSize.height / 2 - 50);
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.backgroundColor = [UIColor blackColor];
        _statusLabel.font = [UIFont systemFontOfSize:24.0f];
        _statusLabel.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:_statusLabel];
    }
    
    _statusLabel.text = message;
    _statusLabel.alpha = 1.0f;
    [UIView animateWithDuration:3.0f animations:^ { [_statusLabel setAlpha:0.00f]; }];
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
    
    //16 jan 13: Dette for å unngå currentMeetingIndex forblir -1 hvis den variablen er ikke blitt oppdatert til andre verdi enn -1
    // TODO i tillegg til dette kan vi vise første møtet hvis det er kl før 08:00
    if (index == ([todaysMeetings count] - 1)  && currentMeetingIndex == -1){
        currentMeetingIndex = [todaysMeetings count] - 1;
    }
    

    NSLog(@"currentMeetingIndex %i", currentMeetingIndex);
    
    // TODO har vi ikke konstanter for dette noe sted?
    self.scrollView.smallBoxWidth = 250;
    self.scrollView.smallBoxHeight = 280;
    self.scrollView.largeBoxWidth = 500;
    self.scrollView.largeBoxHeight = 560;
    self.scrollView.boxSpacing = 10;
    
    
    int currentBoxOffset = 0;
    int previousBoxWidth = 0;
    
    index = 0;
    
    
    NSLog(@"======================");
    NSLog(@"  REFRESH MEETINGS");
    NSLog(@"======================");
    
    for (Meeting *meeting in todaysMeetings) {

        CGFloat boxWidth = index == currentMeetingIndex ? self.scrollView.largeBoxWidth : self.scrollView.smallBoxWidth;
        CGFloat boxHeight = index == currentMeetingIndex ? self.scrollView.largeBoxHeight : self.scrollView.smallBoxHeight;
        
        currentBoxOffset += (previousBoxWidth + self.scrollView.boxSpacing);
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
        scrollWidth = self.scrollView.largeBoxWidth + (self.scrollView.smallBoxWidth * (index + 1)) + 80 ;
    }

    
    [self.scrollView setContentSize:CGSizeMake(scrollWidth, 581)];

    
    if (index > 0) {
        NSLog(@"scroll to %i", currentMeetingIndex);
        [self.scrollView scrollToBoxAt:currentMeetingIndex + 1];
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
        //9.nov: Dette blir jo feil, fordi jeg har sett et ledig møtelapp som har kl8 som start- og sluttidspunkt og neste møte er kl8 til 12. Dette må fikses!!
        Meeting *firstMeeting = [meetings objectAtIndex:0];
        
        NSDate *startOfToday = [DateUtil startOfToday];
        NSTimeInterval interval = [[firstMeeting start] timeIntervalSinceDate:startOfToday];
        
        //11 jan 13: Endret fra (15 * 60) til (2 * 60) == Mer enn ett minutts mellomrom mellom møtelappene, da vises ledige møtelapper, selv om det er ikke mulig å booke en tidsperiode på under 15 minutter da.
        if (interval > (15 * 60)) {
            Meeting *vacantMeeting = [[Meeting alloc] init:startOfToday end:[firstMeeting start] owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
            
            [meetingsWithVacantSpots addObject:vacantMeeting];
        }
    }
    

    int index = 0;
    for (Meeting *meeting in meetings) {
        [meetingsWithVacantSpots addObject:meeting];
        if ([meetings count] > (index + 1)) {
            //Det finnes flere møter i dag
            Meeting *nextMeeting = [meetings objectAtIndex:(index + 1)];
            NSDate *thisMeetingEnd = [meeting end];
            NSDate *nextMeetingStart = [nextMeeting start];
            
            
            NSTimeInterval interval = [nextMeetingStart timeIntervalSinceDate:thisMeetingEnd];
            
            //11 jan 13: Kan endres fra (15 * 60) til (2 * 60) == Mer enn ett minutts mellomrom mellom møtelappene, da vises ledige møtelapper, selv om det er ikke mulig å booke en tidsperiode på under 15 minutter da.
            if (interval > (15 * 60)) {
                //Mørerommet må være ledig i minst 15 minutter/600 sekunder
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
    self.colorLabel.backgroundColor = UIColor.redColor;
    self.meetingStartLabel.text = [DateUtil hourAndMinutes:meeting.start];
    self.meetingEndLabel.text = [DateUtil hourAndMinutes:meeting.end];
    self.meetingOwnerLabel.text = meeting.owner;
    self.meetingSubjectLabel.text = meeting.subject;
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

#pragma mark scrollview delegate


//Metoden er ansvarlig for å animere størrelsen på møteromsboksene. Vurdere å evt. flytte denne
//til CustomScrollView istedet...
- (void)scrollViewDidScroll:(UIScrollView *)scrollView2 {
    
    if ([[scrollView2 subviews] count] > 2) {
        float contentOffset = scrollView2.contentOffset.x;
        int leavingElementIndex = [self.scrollView indexOfElementLeavingScene:scrollView2.contentOffset.x];
        
        if (leavingElementIndex > ([[self.scrollView subviews] count] -2)) {
            leavingElementIndex = [[self.scrollView subviews] count] -2;
        }
        
        int entereingElementIndex = leavingElementIndex + 1;
        
        if (leavingElementIndex >= 0 && contentOffset > 0) {
            CGRect leavingFrame = [[[scrollView2 subviews] objectAtIndex:leavingElementIndex] frame];
            CGRect enteringFrame = [[[scrollView2 subviews] objectAtIndex:entereingElementIndex] frame];
            
            float scalePerentage = (contentOffset - (self.scrollView.smallBoxWidth * leavingElementIndex))/(self.scrollView.smallBoxWidth);
            
            if (scalePerentage > 1) {
                scalePerentage = 1;
            }
            
            enteringFrame.size.width = self.scrollView.smallBoxWidth + (self.scrollView.smallBoxWidth * scalePerentage);
            enteringFrame.size.height = self.scrollView.smallBoxHeight + (self.scrollView.smallBoxHeight * scalePerentage);
            enteringFrame.origin.x = [self.scrollView leftMostPointAt:entereingElementIndex forContentOffset:contentOffset] - (self.scrollView.smallBoxWidth * scalePerentage);
            
            [[[scrollView2 subviews] objectAtIndex:entereingElementIndex] setFrame:enteringFrame];
            
            
            leavingFrame.size.width = self.scrollView.largeBoxWidth - (self.scrollView.smallBoxWidth * scalePerentage); 
            leavingFrame.size.height = self.scrollView.largeBoxHeight - (self.scrollView.smallBoxHeight * scalePerentage);
            leavingFrame.origin.x = [self.scrollView leftMostPointAt:leavingElementIndex forContentOffset:contentOffset];
            
            [[[scrollView2 subviews] objectAtIndex:leavingElementIndex] setFrame:leavingFrame];
            
            //Reset the other visible frames sizes
            int index = 0;
            for (UIView *view in [scrollView2 subviews]) {
                if([view isKindOfClass:[SlidingView class]] && (index > entereingElementIndex || index < leavingElementIndex)) {
                    CGRect frame = view.frame;
                    frame.size.width = self.scrollView.smallBoxWidth;
                    frame.size.height = self.scrollView.smallBoxHeight;
                    frame.origin.x = [self.scrollView leftMostPointAt:index forContentOffset:contentOffset];
                    [view setFrame:frame];
                }
                
                index++;
            } 
        }
    }
}



//9.nov : Denne metode er ansvarlig for å fatsette den lille møtelappen til høyre for hovedlappen (stor)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView2{
    
    if ([[scrollView2 subviews] count] > 2) {
        
        int leavingElementIndex = [self.scrollView indexOfElementLeavingScene:scrollView2.contentOffset.x];
        
        if (leavingElementIndex > ([[self.scrollView subviews] count] -2)) {
            leavingElementIndex = [[self.scrollView subviews] count] -2;
        }
        
        int entereingElementIndex = leavingElementIndex + 1;
        
        CGRect enteringFrame = [[[scrollView2 subviews] objectAtIndex:entereingElementIndex] frame];
        CGRect leavingFrame = [[[scrollView2 subviews] objectAtIndex:leavingElementIndex] frame];
        
        if(250 != enteringFrame.size.height && 280 != enteringFrame.size.height){
  
            if (leavingFrame.size.width > enteringFrame.size.width) {
                NSLog(@"scroll to %i in didDecelerating", leavingElementIndex + 1);
                [self.scrollView scrollToBoxAt:leavingElementIndex + 1];
            } else if (leavingFrame.size.width < enteringFrame.size.width){
                NSLog(@"scroll to %i in didDecelerating", entereingElementIndex + 1);
                [self.scrollView scrollToBoxAt:entereingElementIndex + 1];
                
                //10 jan 13: La til denne else-setning
            }else{
                NSLog(@"scroll to %i in didDecelerating", entereingElementIndex);
                [self.scrollView scrollToBoxAt:entereingElementIndex + 1];
                
            }
            
        }
        
        
        //Reset the other visible frames sizes
        int index = 0;
        for (UIView *view in [scrollView2 subviews]) {
            if([view isKindOfClass:[SlidingView class]] && (index > entereingElementIndex || index < leavingElementIndex)) {
                
                CGRect frame = view.frame;
                frame.size.width = self.scrollView.smallBoxWidth;
                frame.size.height = self.scrollView.smallBoxHeight;
                frame.origin.x = [self.scrollView leftMostPointAt:index forContentOffset:scrollView2.contentOffset.x];
                [view setFrame:frame];
            }
            index++;
        }
        
    }

    
}




@end
