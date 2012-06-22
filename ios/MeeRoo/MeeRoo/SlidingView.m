//
//  SlidingView.m
//  MeeRoo
//
//  Created by Joachim Skeie on 6/8/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "SlidingView.h"
#import "MeetingView.h"

@implementation SlidingView
@synthesize headline = _headline, startTimestamp = _startTimestamp, stopTimestamp = _stopTimestamp, owner = _owner;

- (id)initWithFrame:(CGRect)frame headline:(NSString *)headline start:(NSString *)start stop:(NSString *)stop owner:(NSString *)owner
{
    self = [super initWithFrame:frame];
    if (self) {
        _headline = headline;
        _startTimestamp = start;
        _stopTimestamp = stop;
        _owner = owner;
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"MeetingView" owner:self options:nil];
        
        for (id currentObject in nibViews) {
            if([currentObject isKindOfClass:[MeetingView class]]) {
                [currentObject setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
                
                CGRect containigFrame = [self frame];
                CGRect currentFrame = [currentObject frame];
                currentFrame.size.width = containigFrame.size.width;
                currentFrame.size.height = containigFrame.size.height;
                
                [currentObject setFrame:currentFrame];
                [currentObject updateHeadline:_headline];
                [currentObject updateStart:_startTimestamp];
                [currentObject updateStop:_stopTimestamp];
                [currentObject updateEier:_owner];
                
                if ([_headline isEqualToString:@"Ledig"]) {
                    [[currentObject meetingOccupiedIndicator] setBackgroundColor:[UIColor colorWithRed:0.541 green:0.768 blue:0.831 alpha:1]];
                }
                
                [self addSubview:currentObject];
            }
        }
    }
    
    return self;
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
