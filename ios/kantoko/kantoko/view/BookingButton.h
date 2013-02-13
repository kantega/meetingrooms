//
//  BookingButton.h
//  kantoko
//
//  Created by Nadia Turpin on 2/13/13.
//  Copyright (c) 2013 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingButton : UIButton{}

@property (nonatomic) NSInteger minutes;

- (id)initWithMinutes:(int)minutes andOffsetY:(int)offsetY;

@end
