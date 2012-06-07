//
//  MeeRooDataController.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 09.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"
#import "Configuration.h"

@class Meeting;
@interface MeeRooDataController : NSObject

- (Meeting *) getMeeting:(NSString *)room filterfunction:(NSString *)filterfunction;

- (NSArray *) getMeetingRooms;

- (NSArray *) getMeetingRoomsWithMeetings:(NSString *)location;

@property (retain, nonatomic) Configuration *configuration;


@end

