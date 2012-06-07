//
//  TotalViewController.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 07.06.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeeRooDataController;

@interface TotalViewController : UIViewController

@property (weak, nonatomic) MeeRooDataController *dataController;
@property NSString *location;

- (IBAction)close:(id)sender;

@end
