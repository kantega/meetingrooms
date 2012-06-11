//
//  SlidingView.h
//  MeeRoo
//
//  Created by Joachim Skeie on 6/8/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingView : UIView
@property (strong, retain) NSString * headline;
@property (strong, retain) NSString * startTimestamp;
@property (strong, retain) NSString * stopTimestamp;
@property (strong, retain) NSString * owner;

- (id)initWithFrame:(CGRect)frame headline:(NSString *)headline start:(NSString *)start stop:(NSString *)stop owner:(NSString *)owner;
@end
