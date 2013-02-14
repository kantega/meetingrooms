//
//  Meeting.h
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject {
    
    NSDate *start;
    NSDate *end;
    NSString *owner;
    NSString *subject;
}

@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic) BOOL available;

-(id)init:(NSDate *)newStart end:(NSDate *)newEnd owner:(NSString *)newOwner subject:(NSString *)newSubject;

-(BOOL)isNow;
-(BOOL)isPast;
-(NSInteger)durationInMinutes;

@end
