//
//  MeetingRoom.h
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingRoom : NSObject {

    NSString *location;
    NSString *mailbox;
    NSString *displayname;
    
    NSArray *meetings;
    
}

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *mailbox;
@property (nonatomic, copy) NSString *displayname;

@property (nonatomic, copy) NSArray *meetings;

-(id)init:(NSString *)newMailbox displayname:(NSString *)newDisplayname location:(NSString *)newLocation;

-(NSString*)getLocation;
-(NSString*)getDisplayname;


@end
