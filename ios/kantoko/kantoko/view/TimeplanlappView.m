//
//  TimeplanlappView.m
//  Kantoko
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "TimeplanlappView.h"
#import "TimeplanlappTimerView.h"
#import "DateUtil.h"
#import <QuartzCore/QuartzCore.h> 

@implementation TimeplanlappView


- (id)initWithFrame:(CGRect)frame andMeeting:(Meeting *)meeting
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"MeetingView3" owner:self options:nil];

        for (id currentObject in nibViews) {
 
            if([currentObject isKindOfClass:[TimeplanlappTimerView class]]) {
                [currentObject setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
                
                CGRect containigFrame = [self frame];
                CGRect currentFrame = [currentObject frame];
                currentFrame.size.width = containigFrame.size.width;
                currentFrame.size.height = containigFrame.size.height;
                
                [currentObject showMeetingDetails:meeting];
                [self addSubview:currentObject];
                
                [self updateShadow];
            }
        }
    }
    
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

/*
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}*/

@end
