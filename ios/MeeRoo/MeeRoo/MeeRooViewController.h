//
//  MeeRooViewController.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 08.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeeRooDataController;

@interface MeeRooViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel; 
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) MeeRooDataController *dataController;

@property (weak, nonatomic) IBOutlet UILabel *meetingStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingSubjectLabel;

@end


