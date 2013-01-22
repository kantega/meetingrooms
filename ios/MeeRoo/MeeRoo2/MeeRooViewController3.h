//
//  MeeRooViewController3ViewController.h
//  MeeRoo2
//
//  Created by Maria Maria on 9/21/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CustomScrollView2.h"

#import "BookingVC.h"

//3.jan
#import "SlidingView2.h"

@class MeeRoo2DataController;

@interface MeeRooViewController3 : UIViewController <UIScrollViewDelegate, UITabBarDelegate>{
    
    UILabel *klokkeLabel;
    UILabel *moteromLabel;
    NSTimer *timerForMeeRooVC;
    UITabBar *tabbar;
    
}

@property (unsafe_unretained, nonatomic) UILabel *roomLabel;
@property (unsafe_unretained, nonatomic) UILabel *clockLabel;
@property (unsafe_unretained, nonatomic) UILabel *colorLabel;
@property (strong, nonatomic) MeeRoo2DataController *dataController;

@property (unsafe_unretained, nonatomic) UILabel *meetingStartLabel;
@property (unsafe_unretained, nonatomic) UILabel *meetingEndLabel;
@property (unsafe_unretained, nonatomic) UILabel *meetingOwnerLabel;
@property (unsafe_unretained, nonatomic) UILabel *meetingSubjectLabel;
@property (unsafe_unretained, nonatomic) UILabel *nextMeetingLabel;
@property (unsafe_unretained, nonatomic) CustomScrollView2 *scrollView;

@property (strong,nonatomic) UILabel *klokkeLabel;
@property (strong,nonatomic) UILabel *moteromLabel;


@property (retain,nonatomic) UIToolbar *toolbar;

@property (retain,nonatomic) NSTimer *timerForMeeRooVC;
@property (retain,nonatomic) UITabBar *tabbar;

-(void)onTimer:(NSTimer*)timer;
-(NSTimer*)getTimer;
-(void)stopTimer;
-(void)restartTimer;

//9 jan 13
-(void)configureView;

@end
