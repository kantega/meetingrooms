//
//  TimeplanlappTimerView.m
//  Kantoko
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "TimeplanlappTimerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimeplanlappTimerView

//31 aug 12

@synthesize headlineLabel = _headlineLabel;
@synthesize startTidspunktLabel = _startTidspunktLabel;
@synthesize sluttTidspunktLabel = _sluttTidspunktLabel;
@synthesize eierLabel = _eierLabel;
@synthesize meetingOccupiedIndicator = _meetingOccupiedIndicator;
@synthesize exitButton = _exitButton;

@synthesize timertoclose;



- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}


-(void)timerMethod:(NSTimer*)timer{
    
    NSLog(@"15 seconds har gått");
    
    //21 sep 12
    //Hvis self er ikke på skjermen, blir ingenting fjernet, ellers blir det fjernet
    if (self == nil){
        
        //[timertoclose invalidate];
        //[self removeFromSuperview];
        NSLog(@"Self blir ikke fjernet");

    }
     else{
         self.timertoclose = nil;
        [self removeFromSuperview];
    }
     
    
}

- (id)initWithCoder:(NSCoder *)coder {
    NSLog(@"initWithCoder");
    

    
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 3.0;
        [[self layer] setCornerRadius:14];
        self.layer.masksToBounds = YES;
        self.opaque = NO;
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-table.png"]];
        self.backgroundColor = background;
        
        self.timertoclose = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                        target:self
                                                      selector:@selector(timerMethod:)
                                                      userInfo:nil
                                                       repeats:NO];
        /*
        else if (self != nil){
            
            [timertoclose invalidate];
        }*/
        
    }
    return self;
}

- (void) updateHeadline:(NSString *)headline {
    [_headlineLabel setFont:[UIFont fontWithName:@"Helvetica" size:28]];
    _headlineLabel.adjustsFontSizeToFitWidth = YES;
    _headlineLabel.numberOfLines = 1;
    [_headlineLabel setText:headline];
    
}

- (void) updateStart:(NSString *)startTidspunkt {
    [_startTidspunktLabel setFont:[UIFont fontWithName:@"Helvetica" size:48]];
    _startTidspunktLabel.adjustsFontSizeToFitWidth = YES;
    _startTidspunktLabel.numberOfLines = 1;
    [_startTidspunktLabel setText:startTidspunkt];
}

- (void) updateStop:(NSString *)stoppTidspunkt {
    [_sluttTidspunktLabel setFont:[UIFont fontWithName:@"Helvetica" size:48]];
    _sluttTidspunktLabel.adjustsFontSizeToFitWidth = YES;
    _sluttTidspunktLabel.numberOfLines = 1;
    [_sluttTidspunktLabel setText:stoppTidspunkt];
}

- (void) updateEier:(NSString *)eier {
    [_eierLabel setFont:[UIFont fontWithName:@"Helvetica" size:38]];
    _eierLabel.adjustsFontSizeToFitWidth = YES;
    _eierLabel.numberOfLines = 1;
    [_eierLabel setText:eier];
}

-(void) updateExitButton:(NSString *)exittext{
    
    
    //exittext = @"X";
    /*
    [_exitButton setTitle:exittext forState:UIControlStateNormal];
    [_exitButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:32]];
    _exitButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _exitButton.titleLabel.numberOfLines = 1;
    //[_exitButton addTarget:self action:@selector(AvsluttMetode:) forControlEvents:UIControlEventTouchUpInside];
    [_exitButton addTarget:self action:@selector(AvsluttMetode:) forControlEvents:
     //UIControlEventTouchDragOutside];
     UIControlEventTouchDown];
    [_exitButton addTarget:self action:@selector(AvsluttMetode:) forControlEvents:
     UIControlEventTouchUpInside];
     */
    
    //[_exitButton addTarget:self action:@selector(AvsluttMetode:) forControlEvents: UIControlEventTouchUpInside];
    
    [_exitButton addTarget:self action:@selector(AvsluttMetode:) forControlEvents:UIControlEventTouchDown];
 
     

}


-(void)AvsluttMetode:(id)sender{
    
    NSLog(@"Avslutt-knappen var rørt!");
    
    //15 jan 13 : Hvorfor må det være to klikk til for å avslutte etter den øverste lappen er fjernet?
    self.timertoclose = nil;
    [self removeFromSuperview];
}

-(void)dealloc{
    
    self.timertoclose = nil;
    
    //[super dealloc];
}



@end
