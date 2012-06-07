//
//  AppointmentsRow.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 07.06.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "AppointmentsRow.h"

@implementation AppointmentsRow

@synthesize roomName = _roomName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)refresh {
    
    UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0,2.0,160.0,20.0)];
    theLabel.text = self.roomName;
    [self addSubview:theLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
