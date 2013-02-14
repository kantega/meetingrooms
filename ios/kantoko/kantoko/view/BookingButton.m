//
//  BookingButton.m
//  kantoko
//
//  Created by Nadia Turpin on 2/13/13.
//  Copyright (c) 2013 Kantega. All rights reserved.
//

#import "BookingButton.h"
#import <QuartzCore/CoreAnimation.h>

@implementation BookingButton

@synthesize minutes;

- (id)initWithMinutes:(int)min andOffsetY:(int)offsetY
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake((500-200)/2, offsetY, 200, 60);
        UIImage* image = [UIImage imageNamed:@"clock60.png"];
        UIEdgeInsets insets = UIEdgeInsetsMake(29, 53, 29, 6);
        image = [image resizableImageWithCapInsets:insets];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setMinutes:min];
        [self setTitle:[NSString stringWithFormat:@"     %i minutter", min] forState:UIControlStateNormal];
        
        // shadow
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8] CGPath];
        self.layer.shadowOffset = CGSizeMake(8, 8);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5;
    }
    return self;
}

@end
