//
//  TimeplanlappTimerView.m
//  Kantoko
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "TimeplanlappTimerView.h"
#import "DateUtil.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimeplanlappTimerView

@synthesize headlineLabel = _headlineLabel;
@synthesize startTidspunktLabel = _startTidspunktLabel;
@synthesize sluttTidspunktLabel = _sluttTidspunktLabel;
@synthesize eierLabel = _eierLabel;
@synthesize meetingOccupiedIndicator = _meetingOccupiedIndicator;
@synthesize exitButton = _exitButton;


- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (id)initWithCoder:(NSCoder *)coder {
    NSLog(@"initWithCoder");

    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 3.0;
        self.layer.cornerRadius = 14;
        self.layer.masksToBounds = YES;
        self.opaque = YES;
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-table.png"]];
        self.backgroundColor = background;
    }
    return self;
}

- (void)showMeetingDetails:(Meeting *)meeting {
    [self updateHeadline:meeting.subject];
    [self updateStart:[DateUtil hourAndMinutes:meeting.start]];
    [self updateStop:[DateUtil hourAndMinutes:meeting.end]];
    [self updateEier:meeting.owner];
    [self updateExitButton:@"X"];
}

- (void) updateHeadline:(NSString *)headline {
    [_headlineLabel setFont:[UIFont fontWithName:@"Helvetica" size:28]];
    _headlineLabel.adjustsFontSizeToFitWidth = YES;
    _headlineLabel.numberOfLines = 1;
    [_headlineLabel setText:headline];
    
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
    [_eierLabel setFont:[UIFont fontWithName:@"Helvetica" size:38]];
    _eierLabel.adjustsFontSizeToFitWidth = YES;
    _eierLabel.numberOfLines = 1;
    [_eierLabel setText:eier];
}

-(void) updateExitButton:(NSString *)exittext{
    [_exitButton addTarget:self action:@selector(AvsluttMetode:) forControlEvents:UIControlEventTouchDown];
}


-(void)AvsluttMetode:(id)sender{  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeButtonTouchedOnDetails" object:nil];
}

@end
