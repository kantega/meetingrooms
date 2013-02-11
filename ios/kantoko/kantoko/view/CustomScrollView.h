//
//  CustomScrollView.h
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CustomScrollView : UIScrollView <UIScrollViewDelegate>{

}

+ (int) smallBoxWidth;
+ (int) smallBoxHeight;
+ (int) largeBoxWidth;
+ (int) largeBoxHeight;
+ (int) boxSpacing;
- (int) leftMostPointAt:(int)index forContentOffset:(float) contentOffset;
- (int)indexOfElementLeavingScene:(float)contentOffset;
- (int) scrollToBoxAt:(int)index;



@end
