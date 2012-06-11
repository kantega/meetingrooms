//
//  MeetingView.h
//  MeeRoo
//
//  Created by Joachim Skeie on 6/8/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingView : UIView
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTidspunktLabel;
@property (weak, nonatomic) IBOutlet UILabel *sluttTidspunktLabel;
@property (weak, nonatomic) IBOutlet UILabel *eierLabel;
@property (weak, nonatomic) IBOutlet UIView *meetingOccupiedIndicator;

- (void) updateHeadline:(NSString *)headline;
- (void) updateStart:(NSString *)startTidspunkt;
- (void) updateStop:(NSString *)stoppTidspunkt;
- (void) updateEier:(NSString *)eier;

@end
