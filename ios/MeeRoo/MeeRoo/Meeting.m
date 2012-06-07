//
//  CalendarEvent.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 08.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

@synthesize start = _start;
@synthesize end = _end;
@synthesize owner = _owner;
@synthesize subject = _subject;

-(id)init:(NSDate *)start end:(NSDate *)end owner:(NSString *)owner subject:(NSString *)subject {
    self = [super init];
    if (self) {
        _start = start;
        _end = end;
        _owner = owner;
        _subject = subject;
        return self;
    }
    return nil;        
}


@end
