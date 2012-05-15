//
//  ConfigurationViewControllerViewController.m
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 10.05.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "MeeRooDataController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

@synthesize dataController = _dataController;
@synthesize mockSwitch = _mockSwitch;
@synthesize roomPickerView = _roomPickerView;
@synthesize roomNames = _roomNames;
@synthesize roomPickedIndex;

- (IBAction) saveConfiguration:(id)sender {

    self.dataController.configuration.isUsingMockData = self.mockSwitch.on;

    if (roomPickedIndex) {
        self.dataController.configuration.room = [self.roomNames objectAtIndex:roomPickedIndex];
    }
        
    // Post a notification to configChanged
    [[NSNotificationCenter defaultCenter] postNotificationName:@"configChanged" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.roomNames = [self.dataController getMeetingRooms];
    
    [self.roomPickerView selectRow:[self.roomNames indexOfObject:self.dataController.configuration.room] inComponent:0 animated:YES];
    
    self.mockSwitch.on = self.dataController.configuration.isUsingMockData;
    
    //self.roomPickerView.frame = CGRectMake(400, 219, 20*13.3, 216);
            
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.roomPickerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)roomPickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)roomPickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.roomNames count];
}
- (NSString *)pickerView:(UIPickerView *)roomPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.roomNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.roomPickedIndex = row;
}

@end
