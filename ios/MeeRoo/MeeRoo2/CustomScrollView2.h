//
//  CustomScrollView2.h
//  MeeRoo2
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomScrollView2 : UIScrollView{


    
}

@property (readwrite)int smallBoxWidth;
@property (readwrite)int smallBoxHeight;
@property (readwrite)int largeBoxWidth;
@property (readwrite)int largeBoxHeight;
@property (readwrite)int boxSpacing;
 


- (id) initAtIndex:(int)index;
- (int) leftMostPointAt:(int)index forContentOffset:(float) contentOffset;
- (int)indexOfElementLeavingScene:(float)contentOffset;
- (int) scrollToBoxAt:(int)index;



@end
