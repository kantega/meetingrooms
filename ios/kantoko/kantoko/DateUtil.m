//
//  DateUtil.m
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
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

+ (NSDate *)roundToClosestQuarter:(NSDate *)date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    
    NSUInteger remainder = ([comps minute] % 15);
    NSUInteger currentQuarterStartingMinute = [comps minute] - remainder;
    [comps setMinute:currentQuarterStartingMinute];
    [comps setSecond:0];
    [comps setSecond:0];
    
    NSDate *roundedDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    if (remainder > 7) {
        NSUInteger fifteenMinutes = 15 * 60;
        roundedDate = [roundedDate dateByAddingTimeInterval:fifteenMinutes];
    }
    return roundedDate;
}

+ (NSInteger) minutesBetweenStart:(NSDate *)startTime andEnd:(NSDate *)endTime {
    NSInteger secondsBetweenDates = [endTime timeIntervalSinceDate:startTime];
    NSInteger secondsBetweenN = [endTime timeIntervalSinceDate:startTime];
    return (secondsBetweenDates / 60);
}


+ (NSString *) hourAndMinutes: (NSDate *) date {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
    }
    return [formatter stringFromDate:(NSDate *) date];
}

+ (NSDate *) startOfToday {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:today];
    [dateComponents setHour:8];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *startOfToday = [gregorian dateFromComponents:dateComponents];
    
    return startOfToday;
}

+ (NSDate *) endOfToday {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:today];
    [dateComponents setHour:17];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *endOfToday = [gregorian dateFromComponents:dateComponents];
    
    return endOfToday;
}


@end
