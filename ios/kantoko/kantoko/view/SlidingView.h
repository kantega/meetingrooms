//
//  SlidingView.h
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface SlidingView : UIView
{

    
}

@property (strong, retain) NSString * headline;
@property (strong, retain) NSString * startTimestamp;
@property (strong, retain) NSString * stopTimestamp;
@property (strong, retain) NSString * owner;

- (id)initWithFrame:(CGRect)frame andMeeting:(Meeting *)meeting;

@end
