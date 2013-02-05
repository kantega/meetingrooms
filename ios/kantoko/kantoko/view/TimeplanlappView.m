//
//  TimeplanlappView.m
//  Kantoko
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "TimeplanlappView.h"
#import "TimeplanlappTimerView.h"

@implementation TimeplanlappView

@synthesize headline = _headline, startTimestamp = _startTimestamp, stopTimestamp = _stopTimestamp, owner = _owner, exitlabel = _exitlabel;


- (id)initWithFrame:(CGRect)frame headline:(NSString *)headline start:(NSString *)start stop:(NSString *)stop owner:(NSString *)owner exitlabel:(NSString *)exitlabel
{
    self = [super initWithFrame:frame];
    if (self) {
        //31 aug 12
        
        _headline = headline;
        _startTimestamp = start;
        _stopTimestamp = stop;
        _owner = owner;
        _exitlabel = exitlabel;
        
        
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"MeetingView3" owner:self options:nil];

        
        for (id currentObject in nibViews) {
            
            
            if([currentObject isKindOfClass:[TimeplanlappView class]]) {
                [currentObject setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
                
                CGRect containigFrame = [self frame];
                CGRect currentFrame = [currentObject frame];
                currentFrame.size.width = containigFrame.size.width;
                currentFrame.size.height = containigFrame.size.height;
                //31.aug 12
                
                [currentObject setFrame:currentFrame];
                [currentObject updateHeadline:_headline];
                [currentObject updateStart:_startTimestamp];
                [currentObject updateStop:_stopTimestamp];
                [currentObject updateEier:_owner];
                [currentObject updateExitButton:_exitlabel];
  
                
                //31 aug 12
                if ([_headline isEqualToString:@"Ledig"]) {
                    
                    [[currentObject meetingOccupiedIndicator] setBackgroundColor:[UIColor colorWithRed:0.541 green:0.768 blue:0.831 alpha:1]];
                }
                
                [self addSubview:currentObject];
            }
        }
    }
    
    return self;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
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
