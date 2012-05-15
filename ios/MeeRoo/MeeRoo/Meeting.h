//
//  CalendarEvent.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 08.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *subject;

-(id)init:(NSDate *)start end:(NSDate *)end owner:(NSString *)owner subject:(NSString *)subject;

@end
