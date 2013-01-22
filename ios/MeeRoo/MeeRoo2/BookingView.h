//
//  BookingView.h
//  MeeRoo2
//
//  Created by Maria Maria on 12/12/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BookingView : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>{
    
    //9 jan 13
    //PICKERVIEW
    UIPickerView *scroller;
    
    
}


@property (retain,nonatomic) UILabel *romnavn;

@property NSInteger pickedTimeIndex;
@property NSInteger pickedMinuttIndex;

//20 des 12
@property (retain,nonatomic) UIButton *b1;
@property (retain,nonatomic) UIButton *b2;
@property (retain,nonatomic) UIButton *b3;

//9 jan 13
@property (retain,nonatomic) UIBarButtonItem *bbi1;
@property (retain,nonatomic) UIBarButtonItem *bbi2;

//PICKERVIEW
@property (retain,nonatomic) UIPickerView *scroller;

//10 jan 13
@property (retain,nonatomic) UINavigationItem *item;
@property (retain,nonatomic) UILabel *starttidspunktet;

-(id)initWithFrame:(CGRect)frame;
-(id)init;


@end
