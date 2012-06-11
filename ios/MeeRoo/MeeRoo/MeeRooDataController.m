//
//  MeeRooDataController.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 09.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "MeeRooDataController.h"
#import "Meeting.h"
#import "MeetingRoom.h"
#import "Configuration.h"
#import "DateUtil.h"

@implementation MeeRooDataController

@synthesize configuration;

- (id) init {
    printf("DataController init\n");
    self = [super init];
    if (self) {
        self.configuration =  [[Configuration alloc] init];
        self.configuration.room = [[MeetingRoom alloc] init:@"r102" displayname:@"Room 102" location:@"HQ"];
        return self;
    }
    return nil;       
}


- (NSArray *) getMeetingRoomsWithMeetings:(NSString *)location {
    NSMutableArray *meetingrooms = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url = [NSString stringWithFormat:@"%@/%@", @"http://prototype.kantega.lan/meeroo/appointments", location];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data == nil) {
        printf("data is nil\n");
        return nil;
    }
    NSDictionary *rooms = [NSJSONSerialization JSONObjectWithData:data 
                                                                    options:NSJSONReadingMutableLeaves 
                                                                      error:&error];
    for (NSString *roomName in rooms.allKeys) {
        //NSLog(@"%@", roomName);
        MeetingRoom *meetingRoom = [[MeetingRoom alloc] init:@"" displayname:roomName location:location];
        NSDictionary *meetings = [rooms objectForKey:roomName];
        NSArray *meetingArray = [self readAppointments:meetings];
        meetingRoom.meetings = meetingArray;
        //NSLog(@"Added %i meetings ", meetingRoom.meetings.count);
        [meetingrooms addObject:meetingRoom];
    }
    return meetingrooms;
}

- (NSArray *) getTodaysMeetingInRoom:(NSString *)room {    
    NSError *error = nil;
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", @"http://prototype.kantega.lan/meeroo/appointments", room, @"today"];
    NSLog(@"Getting from URL: %@", url);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data == nil) {
        printf("data is nil\n");
        return nil;
    }
    NSDictionary *appointmentlist = [NSJSONSerialization JSONObjectWithData:data 
                                                                    options:NSJSONReadingMutableLeaves 
                                                                      error:&error];
    NSArray *meetingArray = [self readAppointments:appointmentlist];
    
    return meetingArray;
}


- (Meeting *) getMeeting:(NSString *)room filterfunction:(NSString *)filterfunction {
    //printf("inside data controller getMeeting\n");
    if (self.configuration.isUsingMockData) {
        Meeting *meeting = [[Meeting alloc] init];
        NSDate *now = [NSDate date];
        meeting.start = [DateUtil roundHourDown:now];
        meeting.end = [DateUtil roundHourUp:now];
        meeting.owner = @"Øyvind K";
        meeting.subject = @"App demo";
        return meeting;
    } else {
        
        NSError *error = nil;
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@", @"http://prototype.kantega.lan/meeroo/appointments", room, filterfunction];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            printf("data is nil\n");
            return nil;
        }
        NSDictionary *appointmentlist = [NSJSONSerialization JSONObjectWithData:data 
                                                                 options:NSJSONReadingMutableLeaves 
                                                                   error:&error];
        NSArray *meetingArray = [self readAppointments:appointmentlist];

        if (meetingArray.count > 0) {
            //printf("FOUND meeting\n");
            return [meetingArray objectAtIndex:0];
        } else {
            //printf("no meetings\n");
            return nil;
        }
    }
}


- (NSArray *) readAppointments:(NSDictionary *)appointmentlist {
    
    NSMutableArray *meetingArray = [[NSMutableArray alloc] init];
    for (NSDictionary *entry in appointmentlist) {
        
        NSString *startDate = [entry objectForKey:@"startDate"];
        NSString *endDate = [entry objectForKey:@"endDate"];
        NSString *subject = [entry objectForKey:@"subject"];
        NSString *organizer = [entry objectForKey:@"organizer"];
        
        NSDate *start = [NSDate dateWithTimeIntervalSince1970:([startDate doubleValue] / 1000)]; 
        NSDate *end = [NSDate dateWithTimeIntervalSince1970:([endDate doubleValue] / 1000)];
        
        Meeting *meeting = [[Meeting alloc] init:start end:end owner:organizer subject:subject];
        [meetingArray addObject:meeting];
    }  
    return meetingArray;
}


- (NSArray *) getMeetingRoomsMock {
    return [[NSArray alloc] initWithObjects:
     @"Room 101", @"Room 102", @"Room 356", @"Assembly Hall", @"Room 556", nil];
}

- (NSArray *) getMeetingRooms {
    NSError *error = nil;
    printf("getMeetingRooms\n");
    NSMutableArray *roomArray = [[NSMutableArray alloc] init];
    [roomArray addObject:[[MeetingRoom alloc] init:@"" displayname:@"" location:@""]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://prototype.kantega.lan/meeroo/meetingrooms"]];
    
    NSDictionary *roomlist = [NSJSONSerialization JSONObjectWithData:data 
                                                             options:NSJSONReadingMutableLeaves 
                                                               error:&error];
    
    
    for (NSDictionary *entry in roomlist) {
        NSString *location = [entry objectForKey:@"location"];
        NSString *mailbox = [entry objectForKey:@"mailbox"];
        NSString *displayname = [entry objectForKey:@"displayName"];
        
        MeetingRoom *room = [[MeetingRoom alloc] init:mailbox displayname:displayname location:location];
        [roomArray addObject:room];
    }
    return roomArray;
}


@end
