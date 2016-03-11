//
//  ConfigurationViewController.m
//  Kantoko
//
//  Created by Maria Maria on 8/24/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "KantokoDataController.h"
#import "MeetingRoom.h"

#import "BookingView.h"



@implementation ConfigurationViewController

@synthesize dataController;

@synthesize osloPickerView;

//10 des 12
@synthesize trondheimPickerView;
@synthesize trondheimrooms;
@synthesize oslorooms;

//30 aug 12
@synthesize velgmoteLabel;

@synthesize okButton;

@synthesize meetingrooms;

@synthesize roomPickedIndex;

//11 des 12
@synthesize pickedOsloIndex;
@synthesize pickedTrondheimIndex;

@synthesize trondheim, oslo;


-(void)loadView
{
    
    UIView *customView = [[UIView alloc]initWithFrame:[[[KantokoViewController getInstance] view] frame]];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"graa_bakgrunn1.jpg"]];
    customView.backgroundColor = background;
    customView.autoresizesSubviews = NO;
    customView.clipsToBounds = NO;

    UIColor *kantegaMorkGronn = [UIColor colorWithRed:30/255.0 green:106/255.0 blue:139/255.0 alpha:1.0];
    UIColor *kantegaOrange = [UIColor colorWithRed:200/255.0 green:115/255.0 blue:40/255.0 alpha:1.0];
    
    self.velgmoteLabel = [[UILabel alloc]initWithFrame:CGRectMake((1024-250)/2, 20, 250, 36)];
    self.velgmoteLabel.text = @"Velg møterom";
    self.velgmoteLabel.textAlignment = NSTextAlignmentCenter;
    [self.velgmoteLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:28]];
    [self.velgmoteLabel setTextColor:[UIColor blackColor]];
    self.velgmoteLabel.backgroundColor = [UIColor clearColor];
    self.velgmoteLabel.textColor = kantegaMorkGronn;
    [customView addSubview:self.velgmoteLabel];

    
    UILabel *oslolabel = [[UILabel alloc]initWithFrame:CGRectMake(111, 110, 169, 36)];
    oslolabel.text = @"Oslo";
    [oslolabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:24]];
    oslolabel.backgroundColor = [UIColor clearColor];
    oslolabel.textColor = kantegaMorkGronn;
    [customView addSubview:oslolabel];
    
    
    UILabel *trondheimlabel = [[UILabel alloc]initWithFrame:CGRectMake(594, 110, 169, 36)];
    trondheimlabel.text = @"Trondheim";
    [trondheimlabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:24]];
    trondheimlabel.backgroundColor = [UIColor clearColor];
    trondheimlabel.textColor = kantegaMorkGronn;
    [customView addSubview:trondheimlabel];

    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okButton.frame = CGRectMake((1024-153)/2, 460, 153, 62);
    self.okButton.backgroundColor = kantegaOrange;
    self.okButton.layer.opaque = YES;
    self.okButton.layer.cornerRadius = 10;
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(saveConfiguration:) forControlEvents:UIControlEventTouchUpInside];
    
    self.okButton.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.okButton.bounds cornerRadius:8] CGPath];
    self.okButton.layer.shadowOffset = CGSizeMake(8, 8);
    self.okButton.layer.shadowRadius = 2;
    self.okButton.layer.shadowOpacity = 0.5;
    
    [customView addSubview:self.okButton];
    
    int width = customView.frame.size.width;
    int pickerWidth = 350;
    int osloStartX = 95;
    int trondheimStartX = width - pickerWidth - 95;
    
    self.osloPickerView = [self createPickerViewWithStartX:osloStartX andWidth:pickerWidth];
    self.osloPickerView.tag = 1;
    [customView addSubview:self.osloPickerView];
    
    self.trondheimPickerView = [self createPickerViewWithStartX:trondheimStartX andWidth:pickerWidth];
    self.trondheimPickerView.tag = 2;
    [customView addSubview:self.trondheimPickerView];
    
    
    self.view = customView;
}

-(UIPickerView*) createPickerViewWithStartX:(int)startX andWidth:(int)width {
    UIPickerView *roomPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(startX, 165, width, 216)];
    roomPickerView.delegate = self;
    roomPickerView.showsSelectionIndicator = YES;
    roomPickerView.userInteractionEnabled = YES;
    roomPickerView.opaque = YES;
    roomPickerView.clearsContextBeforeDrawing = YES;
    roomPickerView.autoresizesSubviews = YES;
    
    roomPickerView.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:roomPickerView.bounds cornerRadius:8] CGPath];
    roomPickerView.layer.shadowOffset = CGSizeMake(6, 6);
    roomPickerView.layer.shadowRadius = 4;
    roomPickerView.layer.shadowOpacity = 0.8;
    
    return roomPickerView;
}


-(void)dealloc{
    
    
    self.velgmoteLabel = nil;
    self.trondheimPickerView = nil;
    self.osloPickerView = nil;
    self.okButton = nil;
    self.oslo = nil;
    self.trondheim = nil;
    self.trondheimrooms = nil;
    self.oslorooms = nil;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
    
}


- (void)saveConfiguration:(id)sender {

    if(pickedOsloIndex && [self.oslorooms count] > 0) {
        self.dataController.configuration.room = [self.oslorooms objectAtIndex:self.pickedOsloIndex];
    }
    
    if (pickedTrondheimIndex && [self.trondheimrooms count] > 0) {
        self.dataController.configuration.room = [self.trondheimrooms objectAtIndex:self.pickedTrondheimIndex];
    }    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"configChanged" object:nil];
    [self.dataController updateUserDefaults];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.meetingrooms = [self.dataController getMeetingRooms];
    
    //11 des 12: Uten dette (allocation og initialisation), vil ikke objekter kunne lagres i disse to mutable arrayer (NSMutableArray) til forskjell fra immutable array (NSArray)
    self.oslorooms = [[NSMutableArray alloc]init];
    self.trondheimrooms = [[NSMutableArray alloc]init];
    
    self.oslo = [[NSMutableArray alloc]init];
    self.trondheim = [[NSMutableArray alloc]init];
    
    //11 des 12: Følger opprinnelig oppsett, der en tom linje over romnavn er nødvendig for å få riktig rom på forsiden
    
    [self.oslorooms addObject:@""];
    [self.trondheimrooms addObject:@""];
    
    [self.oslo addObject:@""];
    [self.trondheim addObject:@""];
     
    
    NSLog(@"self.meetingrooms %@", self.meetingrooms);

    
    for( NSInteger i = 0; i < self.meetingrooms.count; i++){
        
        //10 des 12
        //via dot methods
        NSString* line = ((MeetingRoom*)[self.meetingrooms objectAtIndex:i]).getLocation;
        //Kan også bruke NSString *line = [(MeetingRoom2*)[self.meetingrooms objectAtIndex:i] getLocation] via accessor methods;
        //NSLog(@"line is %@", line);
        
        
        if([line isEqualToString:@"Oslo"]){
            
            //11 des 12 Dette lagrer stringer
            if ([self.meetingrooms count] > 0){
                [self.oslorooms addObject:[self.meetingrooms objectAtIndex:i]];
                [self.oslo addObject:[[self.meetingrooms objectAtIndex:i] displayname]];
            }
            
            
        }else if([line isEqualToString:@"Trondheim"]){
            
            NSLog(@"Trondheim");
            
            if ([self.meetingrooms count] > 0){
                [self.trondheimrooms addObject:[self.meetingrooms objectAtIndex:i]];
                [self.trondheim addObject:[[self.meetingrooms objectAtIndex:i] displayname]];
            }

        }
        
    }
    
    
    //12.des 12: Ettersom vi jobber med to forskjellige arrayer, er det nødvendig å finne ut om et rom fins i en array før vi plukker det ut av arrayen, ellers blir det out of bounds-feilmelding dersom objektet fins ikke i arrayen
    if([self.oslorooms containsObject:self.dataController.configuration.room] && [self.oslorooms count] > 0){
        [self.osloPickerView selectRow:[self.oslorooms indexOfObject:self.dataController.configuration.room]  inComponent:0 animated:YES];
    }else if ([self.trondheimrooms containsObject:self.dataController.configuration.room] && [self.trondheimrooms count] > 0){
        [self.trondheimPickerView selectRow:[self.trondheimrooms indexOfObject:self.dataController.configuration.room] inComponent:0 animated:YES];
    }else{
        NSLog(@"Ingen rom funnet");
    }
    
    NSLog(@"pickedOsloIndex %i", pickedOsloIndex);
    NSLog(@"pickedTrondheimIndex %i", pickedTrondheimIndex);
    
}

- (void)viewDidUnload
{
    
    self.velgmoteLabel = nil;
    self.trondheimPickerView = nil;
    self.osloPickerView = nil;
    self.okButton = nil;
    self.oslo = nil;
    self.trondheim = nil;
    self.trondheimrooms = nil;
    self.oslorooms = nil;

    [super viewDidUnload];


}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    if(pickerView.tag == 1){
        
        //gjøre noe med første pickerView
        
        //[self.roomPickerView reloadAllComponents];
        
    }else if (pickerView.tag == 2){
        
        //gjøre noe med andre pickerView
        
        //[self.trondheimPickerView reloadAllComponents];
        
    }
    
    return 1;
    
    
}


 
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == 1){
        
        return [self.oslorooms count];
        
    }else if (pickerView.tag == 2){
        
        return [self.trondheimrooms count];
        
    }
    
    return 0;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if (pickerView.tag == 1) {
        title = [self.oslo objectAtIndex:row];
    } else if (pickerView.tag == 2) {
        title = [self.trondheim objectAtIndex:row];
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    
    if (pickerView.tag == 1){

        return [self.oslo objectAtIndex:row];
        
    
    }else if (pickerView.tag == 2){
    
        return [self.trondheim objectAtIndex:row];

    }
    
    return 0;
    
}*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if (pickerView.tag == 1){
        //Oslo
        self.pickedOsloIndex = row;
    }else if (pickerView.tag == 2){
        //Trondheim
        self.pickedTrondheimIndex = row;
    }
    
    NSLog(@"pickedOsloIndex in method %i", pickedOsloIndex);
    NSLog(@"pickedTrondheimIndex in method %i", pickedTrondheimIndex);
    
}


-(void)didReceiveMemoryWarning{
    
    NSLog(@"Memory Warning in Configuration2ViewController");
    
}


@end
