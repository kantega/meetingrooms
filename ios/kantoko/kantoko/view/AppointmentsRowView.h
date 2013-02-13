//
//  AppointmentsRowView.h
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoom.h"


@interface AppointmentsRowView : UIView {}

@property (strong, nonatomic) MeetingRoom *room;

- (void)refresh;
- (void) drawTimeline;

@end

