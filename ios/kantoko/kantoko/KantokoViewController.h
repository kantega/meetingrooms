//
//  KantokoViewController.h
//  Kantoko
//
//  Created by Maria Maria on 9/21/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CustomScrollView.h"
#import "KantokoDataController.h"
#import "SlidingView.h"

@class KantokoViewController;

@interface KantokoViewController : UIViewController <UIScrollViewDelegate, UITabBarDelegate>{
    
    UILabel *klokkeLabel;
    UILabel *moteromLabel;
    NSTimer *timerForMeeRooVC;
    UITabBar *tabbar;
    
}

@property (unsafe_unretained, nonatomic) UILabel *roomLabel;
@property (unsafe_unretained, nonatomic) UILabel *clockLabel;
@property (unsafe_unretained, nonatomic) UILabel *colorLabel;
@property (strong, nonatomic) KantokoDataController *dataController;

@property (unsafe_unretained, nonatomic) UILabel *meetingStartLabel;
@property (unsafe_unretained, nonatomic) UILabel *meetingEndLabel;
@property (unsafe_unretained, nonatomic) UILabel *meetingOwnerLabel;
@property (unsafe_unretained, nonatomic) UILabel *meetingSubjectLabel;
@property (unsafe_unretained, nonatomic) UILabel *nextMeetingLabel;
@property (strong, nonatomic) CustomScrollView *scrollView;

@property (strong,nonatomic) UILabel *klokkeLabel;
@property (strong,nonatomic) UILabel *moteromLabel;


@property (strong,nonatomic) UIToolbar *toolbar;

@property (strong,nonatomic) NSTimer *timerForMeeRooVC;
@property (strong,nonatomic) UITabBar *tabbar;

-(void)onTimer:(NSTimer*)timer;
-(NSTimer*)getTimer;
-(void)stopTimer;
-(void)restartTimer;
-(void)configureView;

@end
