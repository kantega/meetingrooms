//
//  TimeplanlappView.h
//  Kantoko
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface TimeplanlappView : UIView {}

- (id)initWithFrame:(CGRect)frame andMeeting:(Meeting *)meeting;
- (void)updateShadow;

@end
