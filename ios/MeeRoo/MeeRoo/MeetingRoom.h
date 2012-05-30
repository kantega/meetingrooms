//
//  MeetingRoom.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 18.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingRoom : NSObject

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *mailbox;
@property (nonatomic, copy) NSString *displayname;

-(id)init:(NSString *)mailbox displayname:(NSString *)displayname location:(NSString *)location;

@end
