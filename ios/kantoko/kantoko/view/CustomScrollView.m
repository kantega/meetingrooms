//
//  CustomScrollView.m
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
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
    //NSLog(@"touchedEnded");
    
    if (!self.dragging) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        point.y = 0;
        //NSLog(@"Point %f, %f", point.x, point.y);
        
        self.decelerationRate = 10.0f;
        
        [self scrollToBoxAt:[self indexOfElementLeavingScene:point.x]];
    }
}

- (int) scrollToBoxAt:(int)index {
    
    CGFloat scrollPosition = 0;
    
    //11 jan 13: Gjøre scrollhastigheten sakte slik designen blir penere og mer brukervennlig
    self.decelerationRate = 1.0f;
    
    if (index > 0) {
        scrollPosition = (smallBoxWidth  + boxSpacing ) * (index - 1) - boxSpacing;
    }
    
    NSLog(@"self.width %f", self.frame.size.width);
    
    [self setContentOffset:CGPointMake(scrollPosition + 5, 0) animated:YES];
    NSLog(@"scrollToPosition: %f", scrollPosition);
    
    return scrollPosition;
}

- (int) leftMostPointAt:(int)index forContentOffset:(float) contentOffset {
    if (index <= 0) { return boxSpacing; }
    
    int elementLeavingScene = [self indexOfElementLeavingScene:contentOffset];
    //NSLog(@"elementLeavingScene value is %i", elementLeavingScene);
    
    //NSLog(@"contentOffset value is %f", contentOffset);
    
    
    if (index <= elementLeavingScene) {        
        return (smallBoxWidth + boxSpacing) * (index);
    }
    
    return boxSpacing + (largeBoxWidth + boxSpacing) + (smallBoxWidth + boxSpacing) * (index - 1);
}

- (int)indexOfElementLeavingScene:(float)contentOffset {
    
    if (contentOffset > 0 && contentOffset < smallBoxWidth) { return 0; }
    
    return contentOffset / (smallBoxWidth + boxSpacing);
}


@end
