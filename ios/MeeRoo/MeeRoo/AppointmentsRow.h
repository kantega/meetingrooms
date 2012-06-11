//
//  AppointmentsRow.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 07.06.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoom.h"
#import "Meeting.h"

@interface AppointmentsRow : UIView

@property (retain, nonatomic) MeetingRoom *room;

@property NSMutableDictionary *buttonMap;

- (void)refresh;

- (void) drawTimeline;

- (void) drawMeeting:(Meeting *)meeting;

@end
