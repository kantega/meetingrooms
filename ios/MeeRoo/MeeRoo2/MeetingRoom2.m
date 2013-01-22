//
//  MeetingRoom2.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import "MeetingRoom2.h"

@implementation MeetingRoom2

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
    return ([other isKindOfClass: [MeetingRoom2 class]] &&
            
            [[other mailbox] isEqual:self.mailbox] &&
            [[other displayname] isEqual:self.displayname] &&
            [[other location] isEqual:self.location]);
    
}


-(void)dealloc{
    self.location = nil;
    self.mailbox = nil;
    self.displayname = nil;
    self.meetings = nil;
    
    [super dealloc];

}
 


@end
