//
//  AppDelegate.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import "AppDelegate.h"

//30 aug 12: Denne mvc brukes som test
//#import "MainViewController.h"

#import "MeeRoo2DataController.h"

//30 aug 12: a part of UITabController
//#import "TotalViewController2.h"

#import "Configuration2ViewController.h"

#import "MeeRooViewController3.h"


@implementation AppDelegate

@synthesize window, viewController, navController;





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    

    //Fungerbare koder
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
     
    //21 sep 12
    //self.viewController = [[MeeRoo2ViewController alloc]init];
    self.viewController = [[[MeeRooViewController3 alloc]init] autorelease];

    
    self.navController = [[[UINavigationController alloc]initWithRootViewController:self.viewController] autorelease];
    
    self.viewController.dataController = [[[MeeRoo2DataController alloc] init] autorelease];
    
    self.viewController.navigationItem.title= @"Navigation Controller Example";
    
    
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    
    //self.navController = (UINavigationController*)self.window.rootViewController;
    
    [self.window addSubview:self.navController.view];
    
    [self.window makeKeyAndVisible];
    

    
    return YES;

    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
- (void)dealloc
{
    
    self.window = nil;
    self.navController = nil;
    self.viewController = nil;
    [super dealloc];
    
    //30 aug 12: a part of UITabController
    //[self.viewController release];
    
}
 */


//10 jan 13
-(void)didReceiveMemoryWarning{
    NSLog(@"Memory Warning in AppDelegate");
}


@end
