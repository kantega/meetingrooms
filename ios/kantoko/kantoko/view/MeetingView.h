//
//  MeetingView.h
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingView.h"
#import "DateUtil.h"
#import "Meeting.h"
#import <QuartzCore/QuartzCore.h>

@interface MeetingView : UIView {
    
    
}

@property (strong, nonatomic) Meeting *meeting;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *headlineLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *startTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *sluttTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *eierLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *meetingOccupiedIndicator;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *editButton;

@property (strong,nonatomic) BookingView *bookingView;
@property (strong,nonatomic) UIView *darkBackgroundView;


@end
