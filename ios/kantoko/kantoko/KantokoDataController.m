//
//  KantokoDataController.m (was: MeeRoo2DataController.m)
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//


#import "KantokoDataController.h"
#import "Meeting.h"
#import "MeetingRoom.h"
#import "Configuration.h"
#import "DateUtil.h"

@implementation KantokoDataController

@synthesize configuration;

- (id) init {
    printf("DataController init\n");
    self = [super init];
    if (self) {
        self.configuration =  [[Configuration alloc] init];
        [self readUserDefaults];
    }
    return self;
}

-(void)dealloc{
    
    self.configuration = nil;

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
        MeetingRoom *meetingRoom = [[MeetingRoom alloc] init:@"" displayname:roomName location:location];
        NSDictionary *meetings = [rooms objectForKey:roomName];
        NSArray *meetingArray = [self readAppointments:meetings];
        
        NSLog(@"roomName: %@, location: %@", roomName, location);
        
        meetingRoom.meetings = meetingArray;
        [meetingrooms addObject:meetingRoom];        
    }
    
    return meetingrooms;
}



- (NSArray *) getTodaysMeetingInRoom:(NSString *)room {
    NSError *error = nil;
    
    NSArray *meetingArray = [[NSArray alloc] init];
    
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
        
        NSLog(@"DC subject: %@, DC organizer: %@", subject, organizer);
        
        NSDate *start = [NSDate dateWithTimeIntervalSince1970:([startDate doubleValue] / 1000)];
        NSDate *end = [NSDate dateWithTimeIntervalSince1970:([endDate doubleValue] / 1000)];
        
        Meeting *meeting = [[Meeting alloc] init:start end:end owner:organizer subject:subject];
        [meetingArray addObject:meeting];
    }
    return meetingArray;
}


- (NSArray *) getMeetingRoomsMock {
    return [NSArray arrayWithObjects:
            @"Room 101", @"Room 102", @"Room 356", @"Assembly Hall", @"Room 556", nil];
}

- (NSArray *) getMeetingRooms {
    NSError *error = nil;
    printf("getMeetingRooms\n");
    NSMutableArray *roomArray = [[NSMutableArray alloc] init] ;
    MeetingRoom *meeting = [[MeetingRoom alloc] init:@"" displayname:@"" location:@""];
    [roomArray addObject:meeting];
    
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
        
            MeetingRoom *room = [[MeetingRoom alloc] init:mailbox displayname:displayname location:location];
            [roomArray addObject:room];
        }
    }else{
        MeetingRoom *room = [[MeetingRoom alloc] init:@"" displayname:@"" location:@""];
        [roomArray addObject:room];
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
    
    self.configuration.room = [[MeetingRoom alloc] init:[prefs valueForKey:@"room.mailbox"]
                                            displayname:[prefs valueForKey:@"room.displayname"]
                                               location:[prefs valueForKey:@"room.location"]];
}

@end

