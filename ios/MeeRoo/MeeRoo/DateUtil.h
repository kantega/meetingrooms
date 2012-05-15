//
//  DateUtil.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 11.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSDate *) roundHourDown:(NSDate *) date;
+ (NSDate *) roundHourUp:(NSDate *) date;
+ (NSString *) hourAndMinutes:(NSDate *) date;

@end
