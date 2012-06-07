//
//  Configuration.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 11.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingRoom.h"

@interface Configuration : NSObject

@property (retain, nonatomic) MeetingRoom *room;
@property BOOL isUsingMockData;

@end
