//
//  MeetingRoom.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 18.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "MeetingRoom.h"

@implementation MeetingRoom

@synthesize location = _location;
@synthesize mailbox = _mailbox;
@synthesize displayname = _displayname;
@synthesize meetings = _meetings;

-(id)init:(NSString *)mailbox displayname:(NSString *)displayname location:(NSString *)location {
    self = [super init];
    if (self) {
        _mailbox = mailbox;
        _displayname = displayname;
        _location = location;
        return self;
    }
    return nil;       
}

- (BOOL)isEqual: (id)other
{
    return ([other isKindOfClass: [MeetingRoom class]] &&
            [[other mailbox] isEqual:_mailbox] &&
            [[other displayname] isEqual:_displayname] &&
            [[other location] isEqual:_location] );
}

@end
