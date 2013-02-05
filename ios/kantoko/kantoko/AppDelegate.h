//
//  AppDelegate.h
//  kantoko
//
//  Created by nturpin on 2/4/13.
//  Copyright (c) 2013 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KantokoViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *navController;
}

@property (strong, nonatomic)UIWindow *window;
@property (strong, nonatomic)UINavigationController *navController;
@property (strong, nonatomic)KantokoViewController *viewController;

@end
