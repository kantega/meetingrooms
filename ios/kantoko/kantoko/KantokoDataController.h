//
//  KantokoDataController.h (was: MeeRoo2DataController.h)
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"
#import "Configuration.h"

@class Meeting;

@interface KantokoDataController : NSObject

- (Meeting *) getMeeting:(NSString *)room filterfunction:(NSString *)filterfunction;

- (NSArray *) getMeetingRooms;

- (NSArray *) getTodaysMeetingInRoom:(NSString *)room;

- (NSArray *) getMeetingRoomsWithMeetings:(NSString *)location;

- (void) updateUserDefaults;

- (void) readUserDefaults;




@property (strong, nonatomic) Configuration *configuration;


@end
