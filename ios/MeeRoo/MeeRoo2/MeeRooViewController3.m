//
//  MeeRooViewController.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 08.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "MeeRooViewController3.h"
#import "MeeRoo2DataController.h"
#import "Configuration2ViewController.h"
#import "TotalViewController2.h"
#import "Meeting2.h"
#import "MeetingRoom2.h"
#import "DateUtil2.h"
#import "CustomScrollView2.h"
#import "SlidingView2.h"


@interface MeeRooViewController3 ()

@end

@implementation MeeRooViewController3

@synthesize roomLabel = _roomLabel;
@synthesize clockLabel = _clockLabel;
@synthesize colorLabel = _colorLabel;
@synthesize meetingStartLabel, meetingEndLabel, meetingOwnerLabel, meetingSubjectLabel, nextMeetingLabel;

@synthesize toolbar, dataController;

@synthesize scrollView;

@synthesize klokkeLabel, moteromLabel;

@synthesize timerForMeeRooVC;


-(void)loadView{
    
    
    //Vi oppretter et midlertidig vindu for at self.view har ett synlig vindu å bygge oppå
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)] ;
    customView.autoresizesSubviews = YES;
    customView.clipsToBounds = NO;
    customView.opaque = YES;
    customView.clearsContextBeforeDrawing = YES;
    customView.userInteractionEnabled = YES;
    self.view = customView;
    [customView release];
    
    self.klokkeLabel = [[[UILabel alloc]initWithFrame:CGRectMake(385,-11,181,93)] autorelease];
    self.klokkeLabel.text = @"klokke";
    [self.klokkeLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:42.0]];
    self.klokkeLabel.textColor = [UIColor whiteColor];
    self.klokkeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.klokkeLabel];
    
    
    //Vi bruker nøkkelord "self" for å få tilgang til en global variabel som er deklarert i .h-filen, men
    //må initialiseres et sted i .m-filen
    //Instance member variable, fordi vi kommer til å endre tekst til "moteromLabel" ofte.
    self.moteromLabel = [[[UILabel alloc]initWithFrame:CGRectMake(555,-11,400,93)] autorelease];
    self.moteromLabel.text = @"møterom";
    //[self.moteromLabel setFont:[UIFont fontWithName:@"Verdana" size:20.0]];
    [self.moteromLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:42.0]];
    self.moteromLabel.textColor = [UIColor whiteColor];
    self.moteromLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.moteromLabel];
    
    
    self.scrollView = [[[CustomScrollView2 alloc]initWithFrame:CGRectMake(0,90,1032,581)] autorelease];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    //17 des 12: Unkommenterer for å vise ikonene med tabbar, se under
    /*
    toolbar = [UIToolbar new];
    //toolbar.barStyle = UIBarStyleDefault;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    //31 aug 12: Denne frame brukes når navController.navigationBarHidden er nei
    //toolbar.frame = CGRectMake(0, 748 - (44 *2), 1024, 44);
    toolbar.frame = CGRectMake(0, 748 - 44, 1024, 44);
    
    //Add buttons
    UIBarButtonItem *systemItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Oslo" style:UIBarButtonItemStyleBordered
                                                                   target:self
                                    
                                                                   action:@selector(pressButton1:)];
    
    UIBarButtonItem *systemItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Trondheim" style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(pressButton2:)];
    
    UIBarButtonItem *systemItem3 = [[UIBarButtonItem alloc]
                                    initWithTitle: @"Innstillinger" style: UIBarButtonItemStyleBordered
                                    target:self action:@selector(pressButton3:)];
    
    //Use this to put space in between your toolbox buttons
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    //opprinnelig koder
    //Add buttons to the array
    // NSArray *itemsArray = [NSArray arrayWithObjects: systemItem1, flexItem, systemItem2, flexItem, systemItem3, nil];
    
    NSArray *itemsArray = [NSArray arrayWithObjects: systemItem1, systemItem2, systemItem3, nil];
    
    //release buttons
    [systemItem1 release];
    [systemItem2 release];
    [systemItem3 release];
    [flexItem release];
    
    //add array of buttons to toolbar
    [toolbar setItems:itemsArray animated:NO];
    [self.view addSubview:toolbar];
    */
    
    
    //17 des 12: Det er tabbar som kan vise ikoner
    tabbar = [[UITabBar alloc]initWithFrame:CGRectMake(0,748 - 60, 1024,60)];
    tabbar.delegate = self;
    tabbar.tintColor = [UIColor blackColor];

    
    /*
     //Add buttons with names
     UIBarButtonItem *systemItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Oslo" style:UIBarButtonItemStyleBordered
     target:self
     
     action:@selector(pressButton1:)];
     
     UIBarButtonItem *systemItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Trondheim" style:UIBarButtonItemStyleBordered
     target:self
     action:@selector(pressButton2:)];
     
     UIBarButtonItem *systemItem3 = [[UIBarButtonItem alloc]
     initWithTitle: @"Innstillinger" style: UIBarButtonItemStyleBordered
     target:self action:@selector(pressButton3:)];
     */
    
    
    //Add buttons with image

    UIImage *icon1 = [UIImage imageNamed: @"oslo.png"];
    UIImage *icon2 = [UIImage imageNamed: @"trondheim.png"];
    UIImage *icon3 = [UIImage imageNamed: @"instillinger.png"];
    
    UITabBarItem *systemItem1 = [[UITabBarItem alloc] initWithTitle:@"Oslo" image:icon1 tag:1];
    UITabBarItem *systemItem2 = [[UITabBarItem alloc] initWithTitle:@"Trondheim" image:icon2 tag:2];
    UITabBarItem *systemItem3 = [[UITabBarItem alloc] initWithTitle: @"Innstillinger" image:icon3 tag:3];
    
    
    //Use this to put space in between your toolbox buttons
    //UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //opprinnelig koder
    //Add buttons to the array
    // NSArray *itemsArray = [NSArray arrayWithObjects: systemItem1, flexItem, systemItem2, flexItem, systemItem3, nil];
    
    NSArray *itemsArray = [NSArray arrayWithObjects: systemItem1, systemItem2, systemItem3, nil];
    
    //release buttons
    [systemItem1 release];
    [systemItem2 release];
    [systemItem3 release];
    // [flexItem release];
    
    //add array of buttons to toolbar
    //[toolbar setItems:itemsArray animated:NO];
    [tabbar setItems:itemsArray animated:NO];
    
    [self.view addSubview:tabbar];
    
}


//17 des 12: Metoden er nødvendig for at tabbaren sine funksjoner skal fungere
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    //Eksempel på hvordan å velge en item manuelt
    //tabBar.selectedItem = [tabBar.items objectAtIndex:0];
    
    //NSLog(@"tabbar method triggered %@", tabBar.selectedItem);
    //NSLog(@"didSelectItem: %d", item.tag);
    
    if (item.tag == 1){
        
        [self performSelector:@selector(pressButton1:)];
        
    }else if (item.tag == 2){
        
        [self performSelector:@selector(pressButton2:)];
        
    }else if (item.tag == 3){
        
        [self performSelector:@selector(pressButton3:)];
        
    }else{
        NSLog(@"Bad value of item.tag!");
    }
    
    //Et alternativ til å ikke vise highlight-modus
    //tabBar.selectedItem = 0;
    
}


-(void)pressButton1:(id)sender
{
    //6 sep 12
    TotalViewController2 *totalVC = [[[TotalViewController2 alloc] init] autorelease];
    totalVC.dataController = self.dataController;
    totalVC.location = @"Oslo";
    [self.navigationController pushViewController:totalVC animated:YES];
}

-(void)pressButton2:(id)sender
{
    //6 sep 12
    TotalViewController2 *trondheimVC = [[[TotalViewController2 alloc] init] autorelease];
    trondheimVC.dataController = self.dataController;
    trondheimVC.location = @"Trondheim";
    [self.navigationController pushViewController:trondheimVC animated:YES];
}

-(void)pressButton3:(id)sender
{
    //6 sep 12
    //Fungerbare koder, bortsett fra det krasjer når dataController brukes
    //14 jan 13: Fikset det
    Configuration2ViewController *configVC = [[[Configuration2ViewController alloc] init]autorelease];
    configVC.dataController = self.dataController;
    [self.navigationController pushViewController:configVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set Kantega background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"1024x768_gronn.jpg"]];
    self.view.backgroundColor = background;
    [background release];
    
    //10 des 12
    [self configureView];
    //Alternativ programsetning
    //[self performSelector:@selector(configureView)];
    
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
    //10 des 12
    [self configureView];
    //Alternativ programsetning
    //[self performSelector:@selector(configureView)];
}

// Timer function to update clock and check availibility
-(void) onTimer:(NSTimer *)timer {
    //10 des 12
    [self configureView];
    //Alternativ programsetning
    //[self performSelector:@selector(configureView)];
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
    // Release any retained subviews of the main view.
    
}

//10 jan 13
-(void)dealloc{
    
    self.klokkeLabel = nil;
    self.moteromLabel = nil;
    self.timerForMeeRooVC = nil;
    self.scrollView = nil;
    
    [super dealloc];
}

-(void)didReceiveMemoryWarning{
    
    NSLog(@"Memory Warning in MVC3");
    //16 jan 13: Lag koder her som håndterer memory warning!
    
}

- (void)configureView
{
    //printf("configureView\n");
    
    MeetingRoom2 *room = self.dataController.configuration.room;
    self.moteromLabel.text = room.displayname;
    
    NSDate *now = [NSDate date];
    self.klokkeLabel.text = [DateUtil2 hourAndMinutes:now];
    
    //11.jan 13: Dette er nødvendig for å fjerne objekter fra forrige oppdatering, for å gi plass til nye objekter i neste
    //oppdatering (refresh), ellers går appen amok etterhvert
    for(UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
     
    
    NSArray *todaysMeetings = [self fillInMeetingsWithVacantSpots:[self.dataController getTodaysMeetingInRoom:[room mailbox]]];
 
    int index = 0;
    
    BOOL ingenoppdatering = FALSE;
    //16 jan 13: Pass på at metoden isNow gir korrekt returverdi, ellers blir currentMeetingIndex -1 og gir feil størrelse til nåværende møtelapp
    int currentMeetingIndex = - 1;
    for (Meeting2 *meeting in todaysMeetings) {
        NSLog(@"index inside todayMeetings %i", index);
        if (meeting.isNow) {
            NSLog(@"is now");
            currentMeetingIndex = index;
            break;
        }
        if ( index == [todaysMeetings count] - 1) break;
        index++;

        
    }
    
    //16 jan 13: Dette for å unngå currentMeetingIndex forblir -1 hvis den variablen er ikke blitt oppdatert til andre verdi enn -1
    
    NSLog(@"index %i currentIndex %i todayMeetings %i", index, currentMeetingIndex, [todaysMeetings count]);
    
    if (index == ([todaysMeetings count] - 1)  && currentMeetingIndex == -1){
        NSLog(@"True");
        currentMeetingIndex = [todaysMeetings count] - 1;
        ingenoppdatering = TRUE;
    }
    
    
    NSLog(@"currentMeetingIndex %i", currentMeetingIndex);
     
    
    
    self.scrollView.smallBoxWidth = 250;
    self.scrollView.smallBoxHeight = 280;
    self.scrollView.largeBoxWidth = 500;
    self.scrollView.largeBoxHeight = 560;
    self.scrollView.boxSpacing = 10;
    
    
    int currentBoxOffset = 0;
    int previousBoxWidth = 0;
    
    index = 0;
    
    for (Meeting2 *meeting in todaysMeetings) {
        //NSLog(@"Adding room to scrollview at index: %i", index);
        CGFloat boxWidth = index == currentMeetingIndex ? self.scrollView.largeBoxWidth : self.scrollView.smallBoxWidth;
        CGFloat boxHeight = index == currentMeetingIndex ? self.scrollView.largeBoxHeight : self.scrollView.smallBoxHeight;
        
        currentBoxOffset += (previousBoxWidth + self.scrollView.boxSpacing);
        CGRect frame = CGRectMake(currentBoxOffset, 0, boxWidth, boxHeight);
        
        ingenoppdatering = FALSE;
        
        //23.okt 12
        //dette for å vise "Tom" om det er tom subject i serveren.
        if ([meeting.subject isEqualToString:@""]){
            meeting.subject = @"Opptatt";
        }
        SlidingView2 *meetingView = [[SlidingView2 alloc] initWithFrame:frame headline:[meeting subject]
                                                                  start:[DateUtil2 hourAndMinutes:[meeting start]] stop:[DateUtil2
                                                                                                                         hourAndMinutes:[meeting end]] owner:[meeting owner]];
        
        [self.scrollView addSubview:meetingView];
        [meetingView release];
        index++;
        previousBoxWidth = boxWidth;
    }
    
    [self.scrollView setShowsHorizontalScrollIndicator:YES];
    
    float scrollWidth = 0;
    
    //25 sep 12: for å forebygge at scrollviewen som har kun ett møtelapp sitter fastlåst!
    //9. nov 12: index + 15 blir gjort om til index - 15
    //15 jan 13: Gjorde om index == 1 til index == 0 og index > 1 til index > 0
    if (index == 0){
        //scrollWidth = 1224;
        
        //11 jan 13
        scrollWidth = 1074;
        
    }else if (index > 0){
        //11 jan 13
        scrollWidth = self.scrollView.largeBoxWidth + (self.scrollView.smallBoxWidth * (index + 1)) + 80 ;         
        
    }

    
    [self.scrollView setContentSize:CGSizeMake(scrollWidth, 581)];

    
    if (index > 0) {
        NSLog(@"scroll to %i", currentMeetingIndex);
        [self.scrollView scrollToBoxAt:currentMeetingIndex + 1];
    }
    
    CGPoint offset = self.scrollView.contentOffset;
    //15 jan 13: Endret fra + 1 til - 10
    offset.x = offset.x - 10;
    
    [self.scrollView setContentOffset:offset];
}


//9.nov: Mistenker denne metode er skyldig i overlapping av møtelappene på frontsiden?
//Nei
- (NSArray *) fillInMeetingsWithVacantSpots:(NSArray *) meetings {
    
    NSMutableArray *meetingsWithVacantSpots = [[NSMutableArray alloc] init];
    
    if ([meetings count] == 0) {
        //Hvis ingen møter, legg til ledig møtetidspunkt fra 8 til 17
        NSDate *meetingStart = [DateUtil2 startOfToday];
        NSDate *meetingEnd = [DateUtil2 endOfToday];
        
        Meeting2 *vacantMeeting = [[Meeting2 alloc] init:meetingStart end:meetingEnd owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
        [meetingsWithVacantSpots addObject:vacantMeeting];
        [vacantMeeting release];
    } else if ([meetings count] > 0) {
        //Hvis første møte starter etter 08:15, legg til et ledig møte tidlig på dagen
        //9.nov: Dette blir jo feil, fordi jeg har sett et ledig møtelapp som har kl8 som start- og sluttidspunkt og neste møte er kl8 til 12. Dette må fikses!!
        Meeting2 *firstMeeting = [meetings objectAtIndex:0];
        
        NSDate *startOfToday = [DateUtil2 startOfToday];
        NSTimeInterval interval = [[firstMeeting start] timeIntervalSinceDate:startOfToday];
        
        //11 jan 13: Endret fra (15 * 60) til (2 * 60) == Mer enn ett minutts mellomrom mellom møtelappene, da vises ledige møtelapper, selv om det er ikke mulig å booke en tidsperiode på under 15 minutter da.
        if (interval > (15 * 60)) {
            Meeting2 *vacantMeeting = [[Meeting2 alloc] init:startOfToday end:[firstMeeting start] owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
            
            [meetingsWithVacantSpots addObject:vacantMeeting];
            [vacantMeeting release];
        }
    }
    
    
    //9.nov : Dette sett av kodene må undersøkes nærmere. Kanskje det har med overlapping å gjøre?
    //Nei
    int index = 0;
    for (Meeting2 *meeting in meetings) {
        [meetingsWithVacantSpots addObject:meeting];
        if ([meetings count] > (index + 1)) {
            //Det finnes flere møter i dag
            Meeting2 *nextMeeting = [meetings objectAtIndex:(index + 1)];
            NSDate *thisMeetingEnd = [meeting end];
            NSDate *nextMeetingStart = [nextMeeting start];
            
            
            NSTimeInterval interval = [nextMeetingStart timeIntervalSinceDate:thisMeetingEnd];
            
            //11 jan 13: Kan endres fra (15 * 60) til (2 * 60) == Mer enn ett minutts mellomrom mellom møtelappene, da vises ledige møtelapper, selv om det er ikke mulig å booke en tidsperiode på under 15 minutter da.
            if (interval > (15 * 60)) {
                //Mørerommet må være ledig i minst 15 minutter/600 sekunder
                Meeting2 *vacantMeeting = [[Meeting2 alloc] init:thisMeetingEnd end:nextMeetingStart owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
                [meetingsWithVacantSpots addObject:vacantMeeting];
                [vacantMeeting release];
            }
            
        } else {
            //Dagens siste møterom
            NSDate *thisMeetingEnd = [meeting end];
            NSDate *nextMeetingEnd = [DateUtil2 endOfToday];
            
            Meeting2 *vacantMeeting = [[Meeting2 alloc] init:thisMeetingEnd end:nextMeetingEnd owner:@"Ledig møtetidspunkt" subject:@"Ledig"];
            [meetingsWithVacantSpots addObject:vacantMeeting];
            [vacantMeeting release];
        }
        
        index++;
    }
    
    return [meetingsWithVacantSpots autorelease];
}

- (void) displayRoomAvailable: (Meeting2 *) nextMeeting {
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
                                         [DateUtil2 hourAndMinutes:nextMeeting.start]];
        self.nextMeetingLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",
                                      @"Neste møte: ",
                                      [DateUtil2 hourAndMinutes:nextMeeting.start],
                                      [DateUtil2 hourAndMinutes:nextMeeting.end],
                                      nextMeeting.subject];
        
    }
}



- (void)displayRoomOccupied: (Meeting2 *) meeting {
    //printf("BUSY\n");
    self.colorLabel.backgroundColor = UIColor.redColor;
    self.meetingStartLabel.text = [DateUtil2 hourAndMinutes:meeting.start];
    self.meetingEndLabel.text = [DateUtil2 hourAndMinutes:meeting.end];
    self.meetingOwnerLabel.text = meeting.owner;
    self.meetingSubjectLabel.text = meeting.subject;
}


//9.nov hva gjør denne metode egentlig?
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
    
    //NSLog(@"view did scroll");
    
    // TODO hva skjer hvis count <= 2 ??
    
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
                if([view isKindOfClass:[SlidingView2 class]] && (index > entereingElementIndex || index < leavingElementIndex)) {
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
            //if([view isKindOfClass:[SlidingView2 class]] && (index > entereingElementIndex || index < leavingElementIndex || index == leavingElementIndex || index == entereingElementIndex)) {
            if([view isKindOfClass:[SlidingView2 class]] && (index > entereingElementIndex || index < leavingElementIndex)) {
                
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
