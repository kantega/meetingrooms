//
//  CustomScrollView.h
//  MeeRoo
//
//  Created by Joachim Skeie on 6/8/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomScrollView : UIScrollView
@property (readwrite) int smallBoxWidth;
@property (readwrite)int smallBoxHeight;
@property (readwrite)int largeBoxWidth;
@property (readwrite)int largeBoxHeight;
@property (readwrite)int boxSpacing;


- (id) initAtIndex:(int)index;
- (int) leftMostPointAt:(int)index;
- (int)indexOfElementLeavingScene:(float)contentOffset;
- (int) scrollToBoxAt:(int)index;

@end
