//
//  Meeting2.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import "Meeting2.h"

@implementation Meeting2

@synthesize start, end, owner, subject;

-(id)init:(NSDate *)newStart end:(NSDate *)newEnd owner:(NSString *)newOwner subject:(NSString *)newSubject {
    self = [super init];
    if (self) {

        self.start = newStart;
        self.end = newEnd;
        self.owner = newOwner;
        self.subject = newSubject;
         
    }
    return self;
}

-(BOOL) isNow {
    NSDate *now = [NSDate date];
    //7 sep 12
    //return [now compare:_start] == NSOrderedDescending && [now compare:_end] == NSOrderedAscending;
    
    /*
    //15.januar 13
    if ([now compare:self.start] == NSOrderedDescending && [now compare:self.end] == NSOrderedAscending){
        return FALSE;
    }else if ([now compare:self.start] == NSOrderedAscending && [now compare:self.end] == NSOrderedAscending){
        return TRUE;
    }else if ([now compare:self.start] == NSOrderedDescending && [now compare:self.end] == NSOrderedDescending){
        return FALSE;
    }
    */
    
    //16 jan 13
    /*
    if ([now compare:self.start] == NSOrderedDescending && [now compare:self.end ] == NSOrderedAscending){
        //mellom self.start og self.end
        return TRUE;
    }else if ([now compare:self.start] == NSOrderedAscending && [now compare:self.end ] == NSOrderedAscending){
            //now er før self.start
            return TRUE;
    }else if ([now compare:self.end] == NSOrderedDescending && [now compare:self.start] == NSOrderedAscending){
        //now er etter self.end
        return TRUE;
    }else{
        return FALSE;
    }
    
    
    
    BOOL flag = [now compare:self.start] == NSOrderedDescending && [now compare:self.end] == NSOrderedAscending;
    
    NSLog(flag ? @"Yes" : @"No");
     */

    
    return [now compare:self.start] == NSOrderedDescending && [now compare:self.end] == NSOrderedAscending;
    

}


-(void)dealloc{
    self.end = nil;
    self.start = nil;
    self.owner = nil;
    self.subject = nil;
    
    [super dealloc];

}
 

@end
