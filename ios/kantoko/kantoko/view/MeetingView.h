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
#import <QuartzCore/QuartzCore.h>

@interface MeetingView : UIView  <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    BookingView *bv;
        
    NSMutableArray *timer;
    NSMutableArray *minutter;
    NSMutableArray *forsteTimeMinutter;
    NSMutableArray *sisteTimeMinutter;
    NSMutableArray *varighet;
    
    NSString *moteID;
    //NSMutableArray *moteIDer;
    
    NSMutableArray *minuttArray;
    
    NSString *statusString;
    
}




//7 sep 12
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *headlineLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *startTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *sluttTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *eierLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *meetingOccupiedIndicator;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *editButton;

//22.okt 12

@property (unsafe_unretained, nonatomic) NSString *startString;
@property (unsafe_unretained, nonatomic) NSString *stopString;
@property (unsafe_unretained, nonatomic) NSString *headlineString;
@property (unsafe_unretained, nonatomic) NSString *ownerString;

//17 - 19 des 12
@property (retain,nonatomic) BookingView *bv;
@property (assign,nonatomic) NSInteger *minutt;
@property (retain,nonatomic) NSMutableArray *timer;
@property (retain,nonatomic) NSMutableArray *minutter;
@property (retain,nonatomic) NSMutableArray *forsteTimeMinutter;
@property (retain,nonatomic) NSMutableArray *sisteTimeMinutter;
@property (retain,nonatomic) NSMutableArray *varighet;
@property NSInteger kolonne1indeks;
@property NSInteger kolonne2indeks;
@property NSInteger kolonne3indeks;


@property (retain,nonatomic) NSString *romnavn;
@property NSInteger valgteminutter;
@property NSInteger maxminutter;
@property NSInteger gjenstaendeminutter;


//20 des 12
@property (retain,nonatomic) NSString *moteID;
@property (assign,nonatomic) NSMutableArray *moteIDer;
@property BOOL heledagSvar;

//9 jan 13
@property (retain,nonatomic) UIButton *tempbutton;
@property (retain,nonatomic) UIButton *slettingsknapp;

//10 jan 13
@property (retain,nonatomic) NSMutableArray *minuttArray;
@property NSInteger valgteIndeks;

//15 jan 13
@property (retain,nonatomic) NSString *statusString;


- (void) updateHeadline:(NSString *)headline;
- (void) updateStart:(NSString *)startTidspunkt;
- (void) updateStop:(NSString *)stoppTidspunkt;
- (void) updateEier:(NSString *)eier;

@end
