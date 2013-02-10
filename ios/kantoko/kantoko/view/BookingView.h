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

typedef void (^OnBookingRequestCompleted) (NSString *responseMessage, NSString *errorMessage);

@interface BookingView : UIView <UITextFieldDelegate, UITextViewDelegate>{
    
    UIPickerView *scroller;

}

@property (strong,nonatomic) Meeting *meeting;

@property (strong,nonatomic) UIBarButtonItem *barButtonAvbryt;
@property (strong,nonatomic) UINavigationItem *item;
@property (strong,nonatomic) UILabel *starttidspunktet;
@property (copy) OnBookingRequestCompleted onBookingRequestCompleted;


-(id)initWithFrame:(CGRect)frame;
-(id)init;


@end
