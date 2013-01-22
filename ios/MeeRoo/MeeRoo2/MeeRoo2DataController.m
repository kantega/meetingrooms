//
//  MeeRoo2DataController.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//


#import "MeeRoo2DataController.h"
#import "Meeting2.h"
#import "MeetingRoom2.h"
#import "Configuration2.h"
#import "DateUtil2.h"

@implementation MeeRoo2DataController

@synthesize configuration;

- (id) init {
    printf("DataController init\n");
    self = [super init];
    if (self) {
        self.configuration =  [[[Configuration2 alloc] init] autorelease];
        [self readUserDefaults];
    }
    return self;
}

-(void)dealloc{
    
    self.configuration = nil;
    
    [super dealloc];
}


- (NSArray *) getMeetingRoomsWithMeetings:(NSString *)location {
    
    NSMutableArray *meetingrooms = [[[NSMutableArray alloc] init] autorelease];
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
        MeetingRoom2 *meetingRoom = [[MeetingRoom2 alloc] init:@"" displayname:roomName location:location];
        NSDictionary *meetings = [rooms objectForKey:roomName];
        NSArray *meetingArray = [self readAppointments:meetings];
        
        NSLog(@"roomName: %@, location: %@", roomName, location);
        
        meetingRoom.meetings = meetingArray;
        [meetingrooms addObject:meetingRoom];
        [meetingRoom release];
        
    }
    
    return meetingrooms;
}



- (NSArray *) getTodaysMeetingInRoom:(NSString *)room {
    NSError *error = nil;
    
    NSArray *meetingArray = [[[NSArray alloc] init] autorelease];
    
    if (room) {
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@", @"http://prototype.kantega.lan/meeroo/appointments", room, @"today"];
        NSLog(@"Getting from URL: %@", url);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            printf("getTodaysMeetingInRoom data is nil\n");
        } else {
            NSDictionary *appointmentlist = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableLeaves
                                                                              error:&error];
            meetingArray = [self readAppointments:appointmentlist];
        }
    }
    
    return meetingArray;
}


- (Meeting2 *) getMeeting:(NSString *)room filterfunction:(NSString *)filterfunction {
    //printf("inside data controller getMeeting\n");
    if (self.configuration.isUsingMockData) {
        Meeting2 *meeting = [[Meeting2 alloc] init];
        NSDate *now = [NSDate date];
        meeting.start = [DateUtil2 roundHourDown:now];
        meeting.end = [DateUtil2 roundHourUp:now];
        meeting.owner = @"Øyvind K";
        meeting.subject = @"App demo";
        return [meeting autorelease];
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
        
        NSLog(@"DC subject: %@, DC organizer: %@", subject, organizer);
        
        NSDate *start = [NSDate dateWithTimeIntervalSince1970:([startDate doubleValue] / 1000)];
        NSDate *end = [NSDate dateWithTimeIntervalSince1970:([endDate doubleValue] / 1000)];
        
        Meeting2 *meeting = [[Meeting2 alloc] init:start end:end owner:organizer subject:subject];
        [meetingArray addObject:meeting];
        [meeting release];
    }
    return [meetingArray autorelease];
}


- (NSArray *) getMeetingRoomsMock {
    return [NSArray arrayWithObjects:
            @"Room 101", @"Room 102", @"Room 356", @"Assembly Hall", @"Room 556", nil];
}

- (NSArray *) getMeetingRooms {
    NSError *error = nil;
    printf("getMeetingRooms\n");
    NSMutableArray *roomArray = [[[NSMutableArray alloc] init] autorelease];
    MeetingRoom2 *meeting = [[MeetingRoom2 alloc] init:@"" displayname:@"" location:@""];
    [roomArray addObject:meeting];
    [meeting release];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://prototype.kantega.lan/meeroo/meetingrooms"]];
    if (data == nil) {
        printf("data is nil\n");
        return nil;
    }
    
    NSDictionary *roomlist = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableLeaves
                                                               error:&error];
    
    NSLog(@"roomlist count %i", [roomlist count]);
    if ([roomlist count] > 0){
    
        for (NSDictionary *entry in roomlist) {
            NSString *location = [entry objectForKey:@"location"];
            NSString *mailbox = [entry objectForKey:@"mailbox"];
            NSString *displayname = [entry objectForKey:@"displayName"];
        
            MeetingRoom2 *room = [[MeetingRoom2 alloc] init:mailbox displayname:displayname location:location];
            [roomArray addObject:room];
            [room release];
        }
    }else{
        MeetingRoom2 *room = [[MeetingRoom2 alloc] init:@"" displayname:@"" location:@""];
        [roomArray addObject:room];
        [room release];
    }
    
    NSLog(@"gotMeetingRooms");
    return roomArray;
}

- (void) updateUserDefaults {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.configuration.room.mailbox forKey:@"room.mailbox"];
    [prefs setObject:self.configuration.room.displayname forKey:@"room.displayname"];
    [prefs setObject:self.configuration.room.location forKey:@"room.location"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void) readUserDefaults {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.configuration.room = [[[MeetingRoom2 alloc] init:[prefs valueForKey:@"room.mailbox"]
                                            displayname:[prefs valueForKey:@"room.displayname"]
                                               location:[prefs valueForKey:@"room.location"]] autorelease];
}

@end

