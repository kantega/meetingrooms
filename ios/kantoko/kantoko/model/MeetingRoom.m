//
//  MeetingRoom.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "MeetingRoom.h"

@implementation MeetingRoom

@synthesize location, mailbox, displayname, meetings;

-(id)init:(NSString *)newMailbox displayname:(NSString *)newDisplayname location:(NSString *)newLocation {
    //sjekk side 197 i boka
    self = [super init];
    if (self) 
        
        self.mailbox = newMailbox;
        self.displayname = newDisplayname;
        self.location = newLocation;
 
        return self;

}

-(NSString*)getLocation {
    
    return self.location;
    
}

-(NSString*)getDisplayname {
    
    return self.displayname;
    
}

- (BOOL)isEqual: (id)other
{
    if ([other isKindOfClass:[MeetingRoom class]]) {
        MeetingRoom *theOther = (MeetingRoom *)other;
        return ([theOther.location isEqualToString:self.location] &&
                [theOther.displayname isEqualToString:self.displayname] &&
                [theOther.mailbox isEqualToString:self.mailbox]);
    } else {
        return false;
    }    
}


-(void)dealloc{
    self.location = nil;
    self.mailbox = nil;
    self.displayname = nil;
    self.meetings = nil;
    
    //[super dealloc];

}
 


@end
