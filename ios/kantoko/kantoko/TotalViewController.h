//
//  TotalViewController.h
//  Kantoko
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KantokoDataController;

@interface TotalViewController : UIViewController

{
    UIToolbar *toolbar;
    //7 sep 12
    UILabel *locationLabel;
    NSString *location;
    KantokoDataController *dataController;
    
}

//6 sep 12
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) KantokoDataController *dataController;
@property (copy, nonatomic) NSString *location;
@property (retain, nonatomic) UIToolbar *toolbar;

- (IBAction)close:(id)sender;

@end
