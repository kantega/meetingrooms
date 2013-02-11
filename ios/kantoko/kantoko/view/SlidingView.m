//
//  SlidingView.m
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "SlidingView.h"
#import "MeetingView.h"
#import "Meeting.h"

@implementation SlidingView

@synthesize headline = _headline, startTimestamp = _startTimestamp, stopTimestamp = _stopTimestamp, owner = _owner;


- (id)initWithFrame:(CGRect)frame andMeeting:(Meeting *)meeting
{
    self = [super initWithFrame:frame];
    if (self) {

        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"MeetingView" owner:self options:nil];
        
        for (id currentObject in nibViews) {
            if([currentObject isKindOfClass:[MeetingView class]]) {
                [currentObject setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
                
                CGRect containigFrame = [self frame];
                CGRect currentFrame = [currentObject frame];
                currentFrame.size.width = containigFrame.size.width;
                currentFrame.size.height = containigFrame.size.height;
                
                [currentObject setFrame:currentFrame];
                [currentObject setMeeting:meeting];
                
                [self addSubview:currentObject];
            }
        }
    }
    [self updateShadow];
    return self;
}

- (void)updateShadow {
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8] CGPath];
    self.layer.shadowOffset = CGSizeMake(13, 17);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;   
}

@end
