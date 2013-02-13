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

@synthesize roomPickerView;

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
    
    UIView *customView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]] ;
    customView.backgroundColor = [UIColor darkGrayColor];
    customView.autoresizesSubviews = NO;
    customView.clipsToBounds = NO;
    
    self.velgmoteLabel = [[UILabel alloc]initWithFrame:CGRectMake((1024-250)/2, 20, 250, 36)];
    self.velgmoteLabel.text = @"Velg møterom";
    self.velgmoteLabel.textAlignment = NSTextAlignmentCenter;
    [self.velgmoteLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:25]];
    [self.velgmoteLabel setTextColor:[UIColor whiteColor]];
    self.velgmoteLabel.backgroundColor = [UIColor clearColor];
    [customView addSubview:self.velgmoteLabel];
    
    
    UILabel *oslolabel = [[UILabel alloc]initWithFrame:CGRectMake(74, 80, 169, 36)];
    oslolabel.text = @"Oslo";
    [oslolabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:20]];
    oslolabel.backgroundColor = [UIColor clearColor];
    [customView addSubview:oslolabel];
    
    
    UILabel *trondheimlabel = [[UILabel alloc]initWithFrame:CGRectMake(594, 80, 169, 36)];
    trondheimlabel.text = @"Trondheim";
    [trondheimlabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:20]];
    trondheimlabel.backgroundColor = [UIColor clearColor];
    [customView addSubview:trondheimlabel];

    
    self.okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.okButton.frame = CGRectMake((1024-153)/2, 451, 153, 62);
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    //Hvis man vil ha highlight på knappen etter trykk, unkommenter denne linje
    //[self.okButton setTitle:@"OK" forState:UIControlStateHighlighted];

    [self.okButton addTarget:self action:@selector(saveConfiguration:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:self.okButton];
    
    
    
    //10 des 12 (endret CGRect-størrelser for å gi rom til to PickerView
    self.roomPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(50, 150, 450, 216)];
    self.roomPickerView.delegate = self;
    self.roomPickerView.showsSelectionIndicator = YES;
    self.roomPickerView.userInteractionEnabled = YES;
    self.roomPickerView.opaque = YES;
    self.roomPickerView.clearsContextBeforeDrawing = YES;
    self.roomPickerView.autoresizesSubviews = YES;
    self.roomPickerView.tag = 1;
    [customView addSubview:self.roomPickerView];
    
    self.trondheimPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(550, 150, 400, 216)];    
    self.trondheimPickerView.delegate = self;
    self.trondheimPickerView.showsSelectionIndicator = YES;
    self.trondheimPickerView.userInteractionEnabled = YES;
    self.trondheimPickerView.opaque = YES;
    self.trondheimPickerView.clearsContextBeforeDrawing = YES;
    self.trondheimPickerView.autoresizesSubviews = YES;
    self.trondheimPickerView.tag = 2;
    [customView addSubview:self.trondheimPickerView];
    

    //create toolbar using new
    toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    //31 aug 12: Denne frame brukes når navController.navigationBarHidden er nei
    //toolbar.frame = CGRectMake(0, 748 - (44 *2), 1024, 44);
    toolbar.frame = CGRectMake(0, 748 - 44, 1024, 44);
   
    
    [customView addSubview:toolbar];
    
    
    self.view = customView;    
}



-(void)dealloc{
    
    
    self.velgmoteLabel = nil;
    self.trondheimPickerView = nil;
    self.roomPickerView = nil;
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
    

   
    
    //11 des 12; La til to test-setninger for Oslo og Trondheim
    //Feil type objekter!
    //senere i desember 12: Fikset!

    if(pickedOsloIndex && [self.oslorooms count] > 0) {
        //NSLog(@"pickedOsloIndex %i", pickedOsloIndex);
        self.dataController.configuration.room = [self.oslorooms objectAtIndex:self.pickedOsloIndex];
    }
    
    
    if (pickedTrondheimIndex && [self.trondheimrooms count] > 0) {
        //NSLog(@"pickedTrondheimIndex %i", pickedTrondheimIndex);
        self.dataController.configuration.room = [self.trondheimrooms objectAtIndex:self.pickedTrondheimIndex];
    }
    

     
    // Post a notification to configChanged
    [[NSNotificationCenter defaultCenter] postNotificationName:@"configChanged" object:nil];
    
    //Save configuration on the physical device
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
        [self.roomPickerView selectRow:[self.oslorooms indexOfObject:self.dataController.configuration.room]  inComponent:0 animated:YES];
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
    self.roomPickerView = nil;
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
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    
    if (pickerView.tag == 1){

        return [self.oslo objectAtIndex:row];
        
    
    }else if (pickerView.tag == 2){
    
        return [self.trondheim objectAtIndex:row];

    }
    
    return 0;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if (pickerView.tag == 1){
        //Oslo
        self.pickedOsloIndex = row;
        //NSLog(@"row in oslo %i", row);
    }else if (pickerView.tag == 2){
        //Trondheim
        self.pickedTrondheimIndex = row;
        //NSLog(@"row in trondheim %i", row);
    }
    
    NSLog(@"pickedOsloIndex in method %i", pickedOsloIndex);
    NSLog(@"pickedTrondheimIndex in method %i", pickedTrondheimIndex);
    
}


-(void)didReceiveMemoryWarning{
    
    NSLog(@"Memory Warning in Configuration2ViewController");
    
}


@end
