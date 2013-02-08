//
//  BookingView.h
//  Kantoko
//
//  Created by Maria Maria on 12/12/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Meeting.h"

@interface BookingView : UIView <UITextFieldDelegate, UITextViewDelegate>{
    
    UIPickerView *scroller;

}

@property (strong,nonatomic) Meeting *meeting;

@property (strong,nonatomic) UIBarButtonItem *barButtonOk;
@property (strong,nonatomic) UIBarButtonItem *barButtonAvbryt;

@property (strong,nonatomic) UINavigationItem *item;
@property (strong,nonatomic) UILabel *starttidspunktet;


-(id)initWithFrame:(CGRect)frame;
-(id)init;
-(void)sendBookingRequestForMinutes:(NSInteger)meetingDuration;


@end
