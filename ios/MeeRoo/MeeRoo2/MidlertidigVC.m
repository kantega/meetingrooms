//
//  MidlertidigVC.m
//  MeeRoo2
//
//  Created by Maria Maria on 1/17/13.
//  Copyright (c) 2013 Maria Maria. All rights reserved.
//

#import "MidlertidigVC.h"

@interface MidlertidigVC ()

@end

@implementation MidlertidigVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    
    for (UIView *subview in self.view.subviews){
        
        if ([subview isKindOfClass:[MeetingView2 class]]){
            
            MeetingView2 *mv2 = (MeetingView2*) subview;

            
            NSLog(@"stl %@", mv2.startTidspunktLabel.text);
            
            NSArray *start = [mv2.startTidspunktLabel.text componentsSeparatedByString:@":"];
            //NSArray *slutt = [mv2.sluttTidspunktLabel.text componentsSeparatedByString:@":"];
            NSLog(@"start %@", start);
            
            NSDate *newDate;
            NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
            [dateComponents setMinute:[[start objectAtIndex:1]intValue]];
            [dateComponents setHour:[[start objectAtIndex:0]intValue]];
            //[dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
            newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
            NSLog(@"newDate: %@", newDate);
            NSLog(@"newDate: %.0f", ([newDate timeIntervalSince1970] * 1000));
            
            
            NSDate *now = [NSDate date];
            
            
            if ([now compare:newDate] == NSOrderedDescending) {
                NSLog(@"date1 is later than date2");
                
                
                
            } else if ([now compare:newDate] == NSOrderedAscending) {
                NSLog(@"date1 is earlier than date2");
                
                
                
                if ([mv2.headlineLabel.text isEqualToString:@"Ledig"]){
                    [mv2.editButton setHidden:NO];
                    //[_editButton addTarget:mv2 action:@selector(bookingMethod:) forControlEvents:UIControlEventTouchDown];
                    [mv2.editButton addTarget:mv2 action:@selector(bookingButtonEntered:) forControlEvents:UIControlEventTouchDown];
                    
                    
                    
                    
                    
                } else {
                    [mv2.editButton setHidden:YES];
                    
                    //7.jan
                    //[_sletteButton setHidden:NO];
                    //[_sletteButton addTarget:self action:@selector(slettMetode:) forControlEvents:UIControlEventTouchDown];
                }
                
                
            } else {
                NSLog(@"dates are the same");
                
            }

            
            
        }
        
        
    }
    
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
