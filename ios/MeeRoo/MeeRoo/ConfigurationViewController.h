//
//  ConfigurationViewControllerViewController.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 10.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeeRooDataController;

@interface ConfigurationViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) MeeRooDataController *dataController;
@property (weak, nonatomic) IBOutlet UISwitch *mockSwitch; 
@property (weak, nonatomic) IBOutlet UIPickerView *roomPickerView;
@property (strong, nonatomic) NSArray *roomNames;
@property NSInteger roomPickedIndex;

- (IBAction)saveConfiguration:(id)sender;

@end
