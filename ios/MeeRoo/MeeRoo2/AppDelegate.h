//
//  AppDelegate.h
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

//21 sep 12
@class MeeRooViewController3;


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navController;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navController;

//21 sep 12: Test
@property (strong, nonatomic) MeeRooViewController3 *viewController;



@end
