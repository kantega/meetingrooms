//
//  TimeplanlappView.h
//  Kantoko
//
//  Created by Maria Maria on 9/11/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeplanlappView : UIView

{

    
}

@property (strong, retain) NSString * headline;
@property (strong, retain) NSString * startTimestamp;
@property (strong, retain) NSString * stopTimestamp;
@property (strong, retain) NSString * owner;
@property (strong, retain) NSString * exitlabel;


- (id)initWithFrame:(CGRect)frame headline:(NSString *)headline start:(NSString *)start stop:(NSString *)stop owner:(NSString *)owner exitlabel:(NSString *)exitlabel;

@end
