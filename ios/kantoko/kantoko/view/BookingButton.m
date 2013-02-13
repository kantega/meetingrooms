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
        UIEdgeInsets insets = UIEdgeInsetsMake(29, 55, 29, 4);
        image = [image resizableImageWithCapInsets:insets];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        [self setMinutes:min];
        [self setTitle:[NSString stringWithFormat:@"     %i minutter", min] forState:UIControlStateNormal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
