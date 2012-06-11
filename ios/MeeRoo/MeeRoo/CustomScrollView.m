//
//  CustomScrollView.m
//  MeeRoo
//
//  Created by Joachim Skeie on 6/8/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView
@synthesize smallBoxHeight, smallBoxWidth, largeBoxHeight, largeBoxWidth, boxSpacing;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.smallBoxWidth = 250;
        self.smallBoxHeight = 280;
        self.largeBoxWidth = 500;
        self.largeBoxHeight = 560;
        self.boxSpacing = 10;
        
    }
    return self;
}

-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event  {
    NSLog(@"touchedEnded");
    
    if (!self.dragging) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        point.y = 0;
        NSLog(@"Point %f, %f", point.x, point.y);
        
        [self scrollToBoxAt:[self indexOfElementLeavingScene:point.x]];        
    }
}

- (int) scrollToBoxAt:(int)index {
    CGFloat scrollPosition = 0;
    
    if (index > 0) {
        scrollPosition = (smallBoxWidth + boxSpacing) * (index -1) - boxSpacing;
    }
    
    [self setContentOffset:CGPointMake(scrollPosition, 0) animated:YES];
    NSLog(@"scrollToPosition: %f", scrollPosition);
    
    return scrollPosition;
}

- (int) leftMostPointAt:(int)index {
    if (index <= 0) { return boxSpacing; }
    
    return boxSpacing + (largeBoxWidth + boxSpacing) + (smallBoxWidth + boxSpacing) * (index -1);
}

- (int)indexOfElementLeavingScene:(float)contentOffset {
    if (contentOffset > 0 && contentOffset < smallBoxWidth) { return 0; }
    
    return contentOffset / (smallBoxWidth + boxSpacing);
}

@end
