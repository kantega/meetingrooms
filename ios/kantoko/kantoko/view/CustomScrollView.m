//
//  CustomScrollView.m
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "CustomScrollView.h"
#import "SlidingView.h"

@implementation CustomScrollView

const int _smallBoxWidth = 250;
const int _smallBoxHeight = 280;
const int _largeBoxWidth = 500;
const int _largeBoxHeight = 560;
const int _boxSpacing = 10;


- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

+ (int) smallBoxWidth { return _smallBoxWidth; };
+ (int) smallBoxHeight { return _smallBoxHeight; };
+ (int) largeBoxWidth { return _largeBoxWidth; };
+ (int) largeBoxHeight { return _largeBoxHeight; };
+ (int) boxSpacing { return _boxSpacing; };


-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event  {
    
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
        scrollPosition = (_smallBoxWidth  + _boxSpacing ) * (index - 1) - _boxSpacing;
    }
    
    NSLog(@"self.width %f", self.frame.size.width);
    
    [self setContentOffset:CGPointMake(scrollPosition + 5, 0) animated:YES];
    NSLog(@"scrollToPosition: %f", scrollPosition);
    
    return scrollPosition;
}

- (int) leftMostPointAt:(int)index forContentOffset:(float) contentOffset {
    if (index <= 0) { return _boxSpacing; }
    
    int elementLeavingScene = [self indexOfElementLeavingScene:contentOffset];
    
    
    if (index <= elementLeavingScene) {        
        return (_smallBoxWidth + _boxSpacing) * (index);
    }
    
    return _boxSpacing + (_largeBoxWidth + _boxSpacing) + (_smallBoxWidth + _boxSpacing) * (index - 1);
}

- (int)indexOfElementLeavingScene:(float)contentOffset {
    
    if (contentOffset > 0 && contentOffset < _smallBoxWidth) { return 0; }
    
    return contentOffset / (_smallBoxWidth + _boxSpacing);
}

#pragma mark scrollview delegate


// Animere størrelsen på møteromsboksene
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if ([[self subviews] count] <= 2) { return; }

    float contentOffset = self.contentOffset.x;
    int leavingElementIndex = [self indexOfElementLeavingScene:contentOffset];
    
    if (leavingElementIndex > ([[self subviews] count] - 2)) {
        leavingElementIndex = [[self subviews] count] - 2;
    }
    
    int enteringElementIndex = leavingElementIndex + 1;
    
    if (leavingElementIndex < 0 || contentOffset <= 0) { return; }
    
    int currentBoxOffset = 0;
    int previousBoxWidth = 0;
    
    for (int i = 0; i < [[self subviews] count]; i++) {
        
        UIView *currentView = [[self subviews] objectAtIndex:i];
        if( ![currentView isKindOfClass:[SlidingView class]] ) { continue; }
        
        currentBoxOffset += (previousBoxWidth + CustomScrollView.boxSpacing);
        float scalePercentage = [self scalePercentageForElementIndex:i andEnteringElementIndex:enteringElementIndex andLeavingElementIndex:leavingElementIndex];
        
        CGRect frame = currentView.frame;
        frame.size.width = _smallBoxWidth * scalePercentage;
        frame.size.height = _smallBoxHeight * scalePercentage;
        frame.origin.x = currentBoxOffset;
        [currentView setFrame:frame];
        
        previousBoxWidth = frame.size.width;
    }
}

- (float)scalePercentageForElementIndex: (int)index andEnteringElementIndex: (int)enteringElementIndex andLeavingElementIndex: (int)leavingElementIndex   {
    if (index != enteringElementIndex && index != leavingElementIndex) {
        return 1.f; // bare entering og leaving index blir skalert
    }
    
    float contentOffset = self.contentOffset.x;  
    float fractionOfLeavingElOutsideScreen = (contentOffset - ((_smallBoxWidth + _boxSpacing)
                                                               * leavingElementIndex)) / (_smallBoxWidth);
    
    float scalePercentage;
    if (index == leavingElementIndex) {
        scalePercentage = 2.f - MIN(fractionOfLeavingElOutsideScreen, 1.f);
    } else {
        scalePercentage = 1.f + MIN(fractionOfLeavingElOutsideScreen, 1.f);
    }
    return scalePercentage;
}



// Scroller til leaving- eller enteringlapp avhengig av hvilken av de to er mest synlig
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    
    if ([[self subviews] count] <= 2) { return; }
    
    float contentOffset = self.contentOffset.x;
    int leavingElementIndex = [self indexOfElementLeavingScene:contentOffset];
    
    if (leavingElementIndex > ([[self subviews] count] - 2)) {
        leavingElementIndex = [[self subviews] count] - 2;
    }
    
    int enteringElementIndex = leavingElementIndex + 1;
    
    if (leavingElementIndex < 0 || contentOffset <= 0) { return; }

    float fractionOfLeavingElOutsideScreen = (contentOffset - ((_smallBoxWidth + _boxSpacing) * leavingElementIndex)) / (_smallBoxWidth);
    int scrollToElementIndex = (fractionOfLeavingElOutsideScreen > 0.5f) ? enteringElementIndex : leavingElementIndex;
    [self scrollToBoxAt:scrollToElementIndex + 1];
  
}



@end
