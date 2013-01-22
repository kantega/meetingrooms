//
//  TimeplanlappView.h
//  MeeRoo2
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeplanlappView : UIView
{
    NSTimer *timertoclose;

}


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *headlineLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *startTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *sluttTidspunktLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *eierLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *meetingOccupiedIndicator;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *exitButton;


- (void) updateHeadline:(NSString *)headline;
- (void) updateStart:(NSString *)startTidspunkt;
- (void) updateStop:(NSString *)stoppTidspunkt;
- (void) updateEier:(NSString *)eier;
- (void) updateExitButton:(NSString *)exittext;

@property (nonatomic,retain) NSTimer *timertoclose;

@end