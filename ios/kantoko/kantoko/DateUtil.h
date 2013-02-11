//
//  DateUtil.h
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (BOOL) date:(NSDate *) date1 isAfterDate:(NSDate *) date2;
+ (NSDate *) roundHourDown:(NSDate *) date;
+ (NSDate *) roundHourUp:(NSDate *) date;
+ (NSDate *) roundToClosestQuarter:(NSDate *) date;
+ (NSInteger) minutesBetweenStart:(NSDate *)startTime andEnd:(NSDate *)endTime;
+ (NSString *) hourAndMinutes:(NSDate *) date;
+ (NSDate *)startOfToday;
+ (NSDate *)endOfToday;

@end
