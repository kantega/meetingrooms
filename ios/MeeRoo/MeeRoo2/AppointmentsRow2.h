//
//  AppointmentsRow2.h
//  MeeRoo2
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoom2.h"
#import "Meeting2.h"


@interface AppointmentsRow2 : UIView {
    
    NSMutableDictionary *buttonMap;
    
}

@property (strong, nonatomic) MeetingRoom2 *room;

@property (assign, nonatomic) NSMutableDictionary *buttonMap;

@property (strong,nonatomic) Meeting2 *focusedMeeting;


- (void)refresh;

- (void) drawTimeline;

- (void) drawMeeting:(Meeting2 *)meeting;

@end

