//
//  Meeting.m
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "Meeting.h"
#import "DateUtil.h"

@implementation Meeting

@synthesize start, end, owner, subject;

-(id)init:(NSDate *)newStart end:(NSDate *)newEnd owner:(NSString *)newOwner subject:(NSString *)newSubject {
    self = [super init];
    if (self) {

        self.start = newStart;
        self.end = newEnd;
        self.owner = newOwner;
        self.subject = newSubject;
        self.available = NO; // default
         
    }
    return self;
}

-(BOOL) isNow {
    NSDate *now = [NSDate date];    
    return [now compare:self.start] == NSOrderedDescending && [now compare:self.end] == NSOrderedAscending;
}

-(BOOL) isPast {
    NSDate *closestQuarterToNow = [DateUtil roundToClosestQuarter:[NSDate date]];
    NSInteger secondsSinceEndOfMeeting = [closestQuarterToNow timeIntervalSinceDate:self.end];
    return secondsSinceEndOfMeeting >= 0;
}

-(NSInteger) durationInMinutes {
    NSInteger secondsBetweenDates = [self.end timeIntervalSinceDate:self.start];
    return (secondsBetweenDates / 60);
}


-(void)dealloc{
    self.end = nil;
    self.start = nil;
    self.owner = nil;
    self.subject = nil;
}
 

@end
