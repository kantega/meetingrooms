//
//  AppointmentsRow.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 07.06.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "AppointmentsRow.h"
#import "Meeting.h"
#import "DateUtil.h"


@implementation AppointmentsRow

@synthesize room = _room;
@synthesize buttonMap = _buttonMap;

UIColor *kantegaOrange;
int scale, max, now, hours, startX, height, padding;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scale = 36;
        startX = 206;
        height = frame.size.height;
        hours = 5;
        padding = 1;
        max = (3600 * hours);
        now =  [[NSDate date] timeIntervalSince1970];
        kantegaOrange = [UIColor colorWithRed:200/255.0 green:115/255.0 blue:40/255.0 alpha:1.0];
        //appointmentlist = [[NSMutableDictionary alloc] init];

    }
    return self;
}


- (void)refresh {
    
    UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(2.0,2.0,160.0,height)];
    roomName.text = self.room.displayname;
    roomName.backgroundColor = [UIColor clearColor];
    roomName.textColor = [UIColor lightTextColor];
    roomName.font = [UIFont fontWithName:@"Verdana" size:22];
    [self addSubview:roomName];
    
    for (Meeting *meeting in self.room.meetings) {
        [self drawMeeting:meeting];
    }
}

- (void) drawTimeline {
    NSDate *hour = [DateUtil roundHourDown:[NSDate date]];
    for (int i = 0; i < hours; i++) {
        int x = startX + ((([hour timeIntervalSince1970] - now) + 3600) / scale);
        [self drawVerticalLineAt:x];
        [self drawHourLabelAt:x hourText:[DateUtil hourAndMinutes:hour]];
        hour = [DateUtil roundHourUp:(hour)];
    }
}

- (void) drawHourLabelAt:(int)xValue hourText:(NSString *)hourText  {
    UILabel *hour = [[UILabel alloc] initWithFrame:CGRectMake(xValue - 20 ,0,60, 20)];
    hour.text = hourText;
    hour.backgroundColor = [UIColor clearColor];
    hour.textColor = [UIColor lightTextColor];
    [self addSubview:hour];
}

- (void) drawVerticalLineAt:(int)xValue {
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(xValue,20,1,height)];
    line.backgroundColor = [UIColor lightTextColor];
    [self addSubview:line];
}



- (void) drawMeeting:(Meeting *)meeting {
    int startTime = ([meeting.start timeIntervalSince1970] - now);
    int endTime = ([meeting.end timeIntervalSince1970] - now);
    
    if (endTime < -3600) {
        return;
    }
    
    if (startTime > max) {
        return;
    }
    
    if (startTime < -3600) {
        startTime = -3600;
    }
    if (endTime > max) {
        endTime = max;
    }
    //NSLog(@"start %i end %i", startTime, endTime);
    
    int x = startX + (3600 / scale) + (startTime / scale) + padding;
    int width = ((endTime - startTime) / scale) - (2 * padding) ;
    
//    UILabel *appointmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, padding , width, height - (2 * padding))];
//    appointmentLabel.text = meeting.subject;
//    appointmentLabel.backgroundColor = kantegaOrange;
//    appointmentLabel.textColor = [UIColor whiteColor];
//    [self addSubview:appointmentLabel];
    
    //UIButton *appointmentButton = [[UIButton alloc] initWithFrame:CGRectMake(x, padding , width, height - (2 * padding))];

    
  ////  appointmentButton.backgroundColor = kantegaOrange;
  ////  appointmentButton.textColor = [UIColor whiteColor];
        
    
    
    ////UIButton *appointmentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [appointmentButton addTarget:self 
                          action:@selector(meetingTouched:)
                forControlEvents:UIControlEventTouchUpInside];
    [appointmentButton setTitle:meeting.subject forState:UIControlStateNormal];
    [appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    appointmentButton.frame = CGRectMake(x, padding , width, height - (2 * padding));
    appointmentButton.backgroundColor = kantegaOrange;

    [self.buttonMap setObject:meeting forKey:[self button2string:appointmentButton]];
    
    [self addSubview:appointmentButton];
}


- (void) meetingTouched:(id)sender {
    NSString *key = [self button2string:sender];
    Meeting *meeting = [self.buttonMap objectForKey:key];
    [self displayMeeting:meeting];
}

- (NSString *) button2string:(UIButton *)button {
   NSString *buttonString = [NSString stringWithFormat:@"%f:%f:%@", 
                         button.frame.origin.x,  
                         button.frame.origin.y, 
                         [button titleForState:UIControlStateNormal]]; 
    return buttonString;
}

- (void) displayMeeting:(Meeting *) meeting {
    //
    NSLog(@"Møte subject=%@ owner=%@", meeting.subject, meeting.owner);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
