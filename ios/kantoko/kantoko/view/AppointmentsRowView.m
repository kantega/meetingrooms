//
//  AppointmentsRowView.m
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppointmentsRowView.h"
#import "Meeting.h"
#import "DateUtil.h"

@implementation AppointmentsRowView

@synthesize room;

UIColor *kantegaOrange;

double height, now;

const int scale = 39;
const int startX = 156;
const int startY = 106;
const int hours = 8;
const int max = (3600 * hours);
const double padding = 1.5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        height = frame.size.height;
        now =  [[NSDate date] timeIntervalSince1970];
        kantegaOrange = [UIColor colorWithRed:200/255.0 green:115/255.0 blue:40/255.0 alpha:1.0];
    }
    return self;
}


- (void)refresh {
    
    // TODO remove subviews? How often do we refresh?
    UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(2.0,2.0,160.0, height )];
    roomName.text = self.room.displayname;
    roomName.backgroundColor = [UIColor clearColor];
    roomName.textColor = [UIColor lightTextColor];
    roomName.font = [UIFont fontWithName:@"Verdana" size:20];
    roomName.lineBreakMode = NSLineBreakByWordWrapping;
    roomName.numberOfLines = 0;
    [roomName sizeToFit];
    [self addSubview:roomName];
    
    for (Meeting *meeting in self.room.meetings) {
        [self drawOrangeBarForMeeting:meeting];
    }
     
}

//Denne metode tegner vertikale timelinjer under klokkeslettene
- (void) drawTimeline {
    NSDate *hour = [DateUtil roundHourDown:[NSDate date]];
    for (int i = 0; i < hours; i++) {
        int x = startX + ((([hour timeIntervalSince1970] - now) + 3600) / scale);
        [self drawVerticalLineAt:x];
        [self drawHourLabelAt:x hourText:[DateUtil hourAndMinutes:hour]];
        hour = [DateUtil roundHourUp:(hour)];
    }
}


//Denne metode skriver klokkesletter over timeplanen
- (void) drawHourLabelAt:(int)xValue hourText:(NSString *)hourText  {
    
    UILabel *hour = [[UILabel alloc] initWithFrame:CGRectMake(xValue - 20 ,0,60, 20)];
    hour.text = hourText;
    hour.backgroundColor = [UIColor clearColor];
    hour.textColor = [UIColor lightTextColor];
    [self addSubview:hour];     
}
 

- (void) drawVerticalLineAt:(int)xValue {
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(xValue,20,1,height * 2)];
    line.backgroundColor = [UIColor lightTextColor];
    [self addSubview:line];
}


- (void) drawOrangeBarForMeeting:(Meeting *)meeting{
    
    // NB! tid i sekunder fra 1970
    int startTime = ([meeting.start timeIntervalSince1970] - now);
    int endTime = ([meeting.end timeIntervalSince1970] - now);
    int oneHourAgo = -3600;
    
    if (endTime < oneHourAgo || startTime > max) { return; }

    startTime = MAX(startTime, oneHourAgo);
    endTime = MIN(endTime, max);

    int x = startX + (3600 / scale) + (startTime / scale) + padding;
    int width = ((endTime - startTime) / scale) - (2 * padding) ;
    
    UIButton *appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [appointmentButton addTarget:self action:@selector(appointmentButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

    // Gir luft mellom horisontale oransje linjene
    appointmentButton.frame = CGRectMake(x + 33, padding , width - 5, height - (2 * padding));
    appointmentButton.backgroundColor = kantegaOrange;  
    appointmentButton.layer.cornerRadius = 3;
    
    appointmentButton.layer.masksToBounds = NO;
    appointmentButton.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:appointmentButton.bounds cornerRadius:3] CGPath];
    appointmentButton.layer.shadowOffset = CGSizeMake(5, 5);
    appointmentButton.layer.shadowOpacity = 0.8;
   
    [appointmentButton setTag:[self.room.meetings indexOfObject:meeting]];
    [self addSubview:appointmentButton];
}


- (void) appointmentButtonTouched:(id)sender {

    UIButton *senderButton = (UIButton*)sender;
    NSInteger indexOfMeeting = [senderButton tag];
    Meeting *meeting = [self.room.meetings objectAtIndex:indexOfMeeting];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"meetingBarTouched" object:meeting];
}


@end
