//
//  CustomScrollView2.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import "CustomScrollView2.h"

@implementation CustomScrollView2

@synthesize smallBoxHeight, smallBoxWidth, largeBoxHeight, largeBoxWidth, boxSpacing;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //18 sep 12: original
        
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
        //scrollPosition = (self.smallBoxWidth + self.boxSpacing) * (index -1) - self.boxSpacing;

    }
    
    
    //7. jan 13
    /*setContentOffset:animated:
    Sets the offset from the content view’s origin that corresponds to the receiver’s origin.
    
    - (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
     
    Parameters
    contentOffset
    A point (expressed in points) that is offset from the content view’s origin.
    animated
    YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
     */
    
    NSLog(@"self.width %f", self.frame.size.width);
    
    [self setContentOffset:CGPointMake(scrollPosition + 5, 0) animated:YES];
    NSLog(@"scrollToPosition: %f", scrollPosition);
    
    return scrollPosition;
}

- (int) leftMostPointAt:(int)index forContentOffset:(float) contentOffset {
    if (index <= 0) { return boxSpacing; }
    //if (index <= 0) { return self.boxSpacing; }

    
    int elementLeavingScene = [self indexOfElementLeavingScene:contentOffset];
    //NSLog(@"elementLeavingScene value is %i", elementLeavingScene);
    
    //NSLog(@"contentOffset value is %f", contentOffset);
    
    
    if (index <= elementLeavingScene) {
        
        //10 des 12, for å unngå overlapping av møtelappene, løser dette alt?
        return (smallBoxWidth + boxSpacing) * (index);
        
        //Marias kode
        //return boxSpacing + (smallBoxWidth + boxSpacing) * (index);
        
        //original kode
        //return self.boxSpacing + (self.smallBoxWidth + self.boxSpacing) * (index);

    }


    
    return boxSpacing + (largeBoxWidth + boxSpacing) + (smallBoxWidth + boxSpacing) * (index - 1);
    //return self.boxSpacing + (self.largeBoxWidth + self.boxSpacing) + (self.smallBoxWidth + self.boxSpacing) * (index -1);
    
    
}

- (int)indexOfElementLeavingScene:(float)contentOffset {
    if (contentOffset > 0 && contentOffset < smallBoxWidth) { return 0; }
    
    return contentOffset / (smallBoxWidth + boxSpacing);
    
    //if (contentOffset > 0 && contentOffset < self.smallBoxWidth) { return 0; }
    
    //return contentOffset / (self.smallBoxWidth + self.boxSpacing);

}


//30 august 2012
-(id)initAtIndex:(int)index
{
    NSLog (@"Ubrukt metode");
    return nil;
}



@end
