//
//  DateUtil2.h
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil2 : NSObject

+ (NSDate *) roundHourDown:(NSDate *) date;
+ (NSDate *) roundHourUp:(NSDate *) date;
+ (NSString *) hourAndMinutes:(NSDate *) date;
+ (NSDate *)startOfToday;
+ (NSDate *)endOfToday;

@end
