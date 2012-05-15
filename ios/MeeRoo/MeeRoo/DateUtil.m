//
//  DateUtil.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 11.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "DateUtil.h"


@implementation DateUtil

// Set up flags.
unsigned unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit;

+ (NSDate *)roundHourDown:(NSDate *) date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    [comps setHour:[comps hour]];
    [comps setMinute:0];
    [comps setSecond:0];
    // Construct a new date.
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


+ (NSDate *)roundHourUp:(NSDate *) date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    [comps setHour:([comps hour] + 1)];
    [comps setMinute:0];
    [comps setSecond:0];
    // Construct a new date.
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSString *) hourAndMinutes: (NSDate *) date {
    static NSDateFormatter *formatter = nil;    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
    }    
    return [formatter stringFromDate:(NSDate *) date];    
}

@end
