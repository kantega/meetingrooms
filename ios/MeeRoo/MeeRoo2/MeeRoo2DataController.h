//
//  MeeRoo2DataController.h
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting2.h"
#import "Configuration2.h"

@class Meeting2;

@interface MeeRoo2DataController : NSObject

- (Meeting2 *) getMeeting:(NSString *)room filterfunction:(NSString *)filterfunction;

- (NSArray *) getMeetingRooms;

- (NSArray *) getTodaysMeetingInRoom:(NSString *)room;

- (NSArray *) getMeetingRoomsWithMeetings:(NSString *)location;

- (void) updateUserDefaults;

- (void) readUserDefaults;




@property (retain, nonatomic) Configuration2 *configuration;


@end
