//
//  MeeRooDataController.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 09.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "MeeRooDataController.h"
#import "Meeting.h"
#import "Configuration.h"
#import "DateUtil.h"

@implementation MeeRooDataController

@synthesize configuration;

- (id) init {
    printf("DataController init\n");
    self = [super init];
    if (self) {
        self.configuration =  [[Configuration alloc] init];
        self.configuration.room = @"Room 102";
        return self;
    }
    return nil;       
}


- (Meeting *) getMeeting:(NSString *)room time:(NSDate *)time {
    printf("inside data controller getMeeting\n");
    if (self.configuration.isUsingMockData) {
        Meeting *meeting = [[Meeting alloc] init];
        NSDate *now = [NSDate date];
        meeting.start = [DateUtil roundHourDown:now];
        meeting.end = [DateUtil roundHourUp:now];
        meeting.owner = @"Øyvind K";
        meeting.subject = @"App demo";
        return meeting;
    } else {
        return nil;
    }
}


- (NSArray *) getMeetingRooms {
    return [[NSArray alloc] initWithObjects:
     @"Room 101", @"Room 102", @"Room 356", @"Assembly Hall", @"Room 556", nil];
}

@end
