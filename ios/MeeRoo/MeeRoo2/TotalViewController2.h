//
//  TotalViewController2ViewController.h
//  MeeRoo2
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeeRoo2DataController;

@interface TotalViewController2 : UIViewController

{
    UIToolbar *toolbar;
    //7 sep 12
    UILabel *locationLabel;
    NSString *location;
    MeeRoo2DataController *dataController;
    
}

//6 sep 12
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) MeeRoo2DataController *dataController;
@property (copy, nonatomic) NSString *location;
@property (retain, nonatomic) UIToolbar *toolbar;

- (IBAction)close:(id)sender;

@end
