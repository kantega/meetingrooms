//
//  Meeting2.h
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting2 : NSObject {
    
    //7 sep 12
    NSDate *start;
    NSDate *end;
    NSString *owner;
    NSString *subject;
}

@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *subject;

-(id)init:(NSDate *)newStart end:(NSDate *)newEnd owner:(NSString *)newOwner subject:(NSString *)newSubject;

-(BOOL)isNow;

@end
