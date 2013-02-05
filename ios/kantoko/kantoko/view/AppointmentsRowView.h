//
//  AppointmentsRowView.h
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoom.h"
#import "Meeting.h"


@interface AppointmentsRowView : UIView {
    
    //NSMutableDictionary *buttonMap;
    
}

@property (strong, nonatomic) MeetingRoom *room;

@property (assign, nonatomic) NSMutableDictionary *buttonMap;

@property (strong,nonatomic) Meeting *focusedMeeting;


- (void)refresh;

- (void) drawTimeline;

- (void) drawMeeting:(Meeting *)meeting;

@end

