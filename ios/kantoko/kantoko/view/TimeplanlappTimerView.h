//
//  TimeplanlappTimerView.h
//  Kantoko
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface TimeplanlappTimerView : UIView{ }


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *headlineLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *startTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *sluttTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *eierLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *meetingOccupiedIndicator;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *exitButton;

- (void)showMeetingDetails:(Meeting *)meeting;

@end