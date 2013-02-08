//
//  MeetingView.m
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "MeetingView.h"
#import <QuartzCore/CoreAnimation.h>
#import "BookingView.h"
#import "KantokoViewController.h"

@implementation MeetingView

//31 aug 12

@synthesize meeting = _meeting;

@synthesize headlineLabel = _headlineLabel;
@synthesize startTidspunktLabel = _startTidspunktLabel;
@synthesize sluttTidspunktLabel = _sluttTidspunktLabel;
@synthesize eierLabel = _eierLabel;
@synthesize meetingOccupiedIndicator = _meetingOccupiedIndicator;
@synthesize editButton = _editButton;

@synthesize tempbutton;
@synthesize bookingView;


#define kDontDisableUserInteraction 321


- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 3.0;
        [[self layer] setCornerRadius:14];
        self.layer.masksToBounds = YES;
        self.opaque = NO;
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-table.png"]];
        self.backgroundColor = background; 
    }
    return self;
}

- (void)setMeeting:(Meeting *)meeting {
    _meeting = meeting;
    [self updateHeadline:[_meeting subject]];
    [self updateStart:[DateUtil hourAndMinutes:[_meeting start]]];
    [self updateStop:[DateUtil hourAndMinutes:[_meeting end]]];
    [self updateEier:[_meeting owner]];
    // TODO bruke flagg i stedet
    if ([[_meeting subject] isEqualToString:@"Ledig"]) {
        [self setLedig];
    } else {
        [self setOpptatt];
    }
}



- (void) updateStart:(NSString *)startTidspunkt {
    [_startTidspunktLabel setFont:[UIFont fontWithName:@"Helvetica" size:48]];
    _startTidspunktLabel.adjustsFontSizeToFitWidth = YES;
    _startTidspunktLabel.numberOfLines = 1;
    [_startTidspunktLabel setText:startTidspunkt];
}

- (void) updateStop:(NSString *)stoppTidspunkt {
    [_sluttTidspunktLabel setFont:[UIFont fontWithName:@"Helvetica" size:48]];
    _sluttTidspunktLabel.adjustsFontSizeToFitWidth = YES;
    _sluttTidspunktLabel.numberOfLines = 1;
    [_sluttTidspunktLabel setText:stoppTidspunkt];
}

- (void) updateEier:(NSString *)eier {
    [_eierLabel setFont:[UIFont fontWithName:@"Helvetica" size:25]];
    _eierLabel.adjustsFontSizeToFitWidth = YES;
    _eierLabel.numberOfLines = 1;
    _eierLabel.lineBreakMode = UILineBreakModeWordWrap;
    [_eierLabel setText:eier];
}

- (void) updateHeadline:(NSString *)headline {
    [_headlineLabel setFont:[UIFont fontWithName:@"Helvetica" size:38]];
    _headlineLabel.adjustsFontSizeToFitWidth = YES;
    _headlineLabel.numberOfLines = 3;
    _headlineLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [_headlineLabel setText:headline];
}

- (void) setLedig {
    if (_meeting && [_meeting isPast]) {
        [_editButton setHidden:YES];   // ledig, men for sent for å reservere
    } else {
        [_editButton setHidden:NO];
        [_editButton addTarget:self action:@selector(bookingButtonClicked:) forControlEvents:UIControlEventTouchDown];
    }   
    [_meetingOccupiedIndicator setBackgroundColor:[UIColor colorWithRed:0.541 green:0.768 blue:0.831 alpha:1]];
}

- (void) setOpptatt {
    [_editButton setHidden:YES];
}


-(void)callBookingLapp{
    
    self.bookingView = [[BookingView alloc] init];
    self.bookingView.meeting = _meeting;
    
    [self.bookingView.barButtonAvbryt setAction:@selector(standardknappavbryt:)];
    [self.bookingView.barButtonAvbryt setTarget:self];
    
    
    [self addSubview:self.bookingView];
}



// TODO skulle egentlig bli notification fra bookingview, men skal bli her foreløpig
-(void)standardknappavbryt:(id)sender{
    
    [self.tempbutton removeFromSuperview];
    [self.bookingView removeFromSuperview];
    KantokoViewController *kantokoViewController = [KantokoViewController getInstance];
    kantokoViewController.scrollView.userInteractionEnabled = YES;
    [kantokoViewController restartTimer];
    
}


-(void)bookingButtonClicked:(id)sender{
    
    NSLog(@"Her er booking");
    
    //if (self ...)?
    //17 des 12, det er nok med å fylle ut møteromslappen slik at ny lapp kan ikke skapes før den første lappen lukkes.
    //[self performSelector:@selector(callBookingLapp)];
    [self callBookingLapp];
    
    KantokoViewController * kantokoViewController = [KantokoViewController getInstance];
    [kantokoViewController stopTimer];
    

    //10 jan 13: For å ha valgfri bakgrunnsfarge, må man gå for UIButtonTypeCustom, ikke UIButtonTypeRoundedRect
    //tempbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tempbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    // Foreløpig ingen action hvis brukeren tar på skjermen utenfor MeetingView, vi kunne lukke viewet i så fall
    // [tempbutton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
    [tempbutton setTitle:@"" forState:UIControlStateNormal];
    tempbutton.frame = kantokoViewController.view.frame;
    tempbutton.backgroundColor = [UIColor darkGrayColor];
    tempbutton.alpha = 0.5;
    [kantokoViewController.view addSubview:tempbutton];

    
    kantokoViewController.scrollView.userInteractionEnabled = NO;
    [kantokoViewController.view addSubview:self.bookingView];

    self.userInteractionEnabled = YES;
    self.bookingView.userInteractionEnabled = YES;
    
 
}


-(void)fjerneObjekter{
    
    NSLog(@"fjerneObjekter triggered");
    
    [self.bookingView removeFromSuperview];
    [self.tempbutton removeFromSuperview];
    KantokoViewController *kantokoViewController = [KantokoViewController getInstance];
    kantokoViewController.scrollView.userInteractionEnabled = YES;
    [kantokoViewController restartTimer];
}


-(void)dealloc{
    
    self.bookingView= nil;
    self.startTidspunktLabel = nil;
    self.sluttTidspunktLabel = nil;
    
    self.meeting = nil;
}


@end