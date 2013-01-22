//
//  MeetingView2.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import "MeetingView2.h"
#import <QuartzCore/CoreAnimation.h>
#import "BookingView.h"

//17 - 18 des 12: For å få tak i current View Controller
#import "MeeRooViewController3.h"
#import "BookingVC.h"

@implementation MeetingView2

//31 aug 12

@synthesize headlineLabel = _headlineLabel;
@synthesize startTidspunktLabel = _startTidspunktLabel;
@synthesize sluttTidspunktLabel = _sluttTidspunktLabel;
@synthesize eierLabel = _eierLabel;
@synthesize meetingOccupiedIndicator = _meetingOccupiedIndicator;
@synthesize editButton = _editButton;

//17 des 12
@synthesize bv;

//19 des 12
@synthesize minutt;
@synthesize timer, minutter, varighet;
@synthesize kolonne1indeks, kolonne2indeks, kolonne3indeks;

@synthesize maxminutter, valgteminutter, gjenstaendeminutter;

@synthesize moteID, moteIDer, heledagSvar;

@synthesize tempbutton;

//@synthesize slettingsknapp;

@synthesize minuttArray, valgteIndeks;

@synthesize statusString;



#define kDontDisableUserInteraction 321


- (id)initWithFrame:(CGRect)frame
{
    //NSLog(@"initWithFrame inside MeetingView2");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.tag = kDontDisableUserInteraction;

        //10 jan 13: 
        //This log never gets triggered..., why?
        //11 jan 13:
        //Fordi dette initialiseres manuelt via andre koder, f.eks. [... initWithFrame:CGRect()]; osv,
        //mens initWithCoder initialiserer et objekt via nib-fil.
        //NSLog(@"initialization of MeetingView2-object");

        
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    //NSLog(@"initWithCoder inside MeetingView2");
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 3.0;
        [[self layer] setCornerRadius:14];
        self.layer.masksToBounds = YES;
        self.opaque = NO;
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-table.png"]];
        self.backgroundColor = background;
        [background release];
        
        
    }
    return self;
}



- (void) updateStart:(NSString *)startTidspunkt {
    [_startTidspunktLabel setFont:[UIFont fontWithName:@"Helvetica" size:48]];
    _startTidspunktLabel.adjustsFontSizeToFitWidth = YES;
    _startTidspunktLabel.numberOfLines = 1;
    [_startTidspunktLabel setText:startTidspunkt];
    //self.startTidspunktLabel.text = startTidspunkt;
    //NSLog(@"startTidspunkt %@", startTidspunkt);
}

- (void) updateStop:(NSString *)stoppTidspunkt {
    [_sluttTidspunktLabel setFont:[UIFont fontWithName:@"Helvetica" size:48]];
    _sluttTidspunktLabel.adjustsFontSizeToFitWidth = YES;
    _sluttTidspunktLabel.numberOfLines = 1;
    [_sluttTidspunktLabel setText:stoppTidspunkt];
}

- (void) updateEier:(NSString *)eier {
    [_eierLabel setFont:[UIFont fontWithName:@"Helvetica" size:25]];
    _eierLabel.adjustsFontSizeToFitWidth = YES;
    _eierLabel.numberOfLines = 1;
    _eierLabel.lineBreakMode = UILineBreakModeWordWrap;
    [_eierLabel setText:eier];
}

- (void) updateHeadline:(NSString *)headline {
    [_headlineLabel setFont:[UIFont fontWithName:@"Helvetica" size:38]];
    _headlineLabel.adjustsFontSizeToFitWidth = YES;
    _headlineLabel.numberOfLines = 3;
    _headlineLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [_headlineLabel setText:headline];
    
    
    //11 jan 13: Utkommenterte
    //if ([headline isEqualToString:@"Ledig"] && CGRectEqualToRect(self.frame, CGRectMake(0,0,500,560))) {
    if ([headline isEqualToString:@"Ledig"]){
        [_editButton setHidden:NO];
        //[_editButton addTarget:self action:@selector(bookingMethod:) forControlEvents:UIControlEventTouchDown];
        [_editButton addTarget:self action:@selector(bookingButtonEntered:) forControlEvents:UIControlEventTouchDown];


    } else {
        [_editButton setHidden:YES];
        
        //7.jan
        //[_sletteButton setHidden:NO];
        //[_sletteButton addTarget:self action:@selector(slettMetode:) forControlEvents:UIControlEventTouchDown];
    }
     
    
    /*
    slettingsknapp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [slettingsknapp setTitle:@"Slett" forState:UIControlStateNormal];
    slettingsknapp.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    [self addSubview:slettingsknapp];
     */
    
    //NSLog(@"initialization");
    
    //9 jan 13: Prøvde å lage slettingsfunksjonalitet
    /*
    if ([self.moteID isEqualToString:@""] || self.moteID == nil){
        //NSLog(@"slettingsknapp inni if");
        [slettingsknapp setHidden:YES];
    }else{
        //NSLog(@"slettingsknapp inni else");
        [slettingsknapp setHidden:NO];
        [slettingsknapp addTarget:self action:@selector(slettMetode:) forControlEvents:UIControlEventTouchDown];
    }
     */
    
    
    
}


//16 des - 19 des 12
-(void)callBookingLapp{
    
    //NSLog(@"call Booking Lapp");
    self.timer = [[NSMutableArray alloc]init];
    
    NSLog(@"startstring %@", self.startTidspunktLabel.text);
    NSLog(@"stopstring %@", self.sluttTidspunktLabel.text);
    
    NSArray *start = [self.startTidspunktLabel.text componentsSeparatedByString:@":"];
    NSArray *slutt = [self.sluttTidspunktLabel.text componentsSeparatedByString:@":"];
    
    self.forsteTimeMinutter = [[NSMutableArray alloc]init];
    
    self.sisteTimeMinutter = [[NSMutableArray alloc]init];
    
    NSLog(@"start og slutt %@ %@", start, slutt);
    
    
    
    //sjekke hvis minutter til maximum klokkeslett er mer enn 0, da blir siste time inkludert i timer-array
    if (![[slutt objectAtIndex:1] isEqualToString:@"00"]){
        for (int i = [[start objectAtIndex:0] intValue]; i <= [[slutt objectAtIndex:0] intValue]; i++){
            [self.timer addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0; i < [[slutt objectAtIndex:1] intValue]; i += 5){
            [self.sisteTimeMinutter addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        //maxminutter = ( 60 - [[slutt objectAtIndex:1] intValue]);

        
    }
    else{
        for (int i = [[start objectAtIndex:0] intValue]; i < [[slutt objectAtIndex:0] intValue]; i++){
            [self.timer addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    if (![[start objectAtIndex:1] isEqualToString:@"00"]){
        for (int i = [[start objectAtIndex:1] intValue]; i < 60; i += 5){
            [self.forsteTimeMinutter addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        //maxminutter = ( 60 - [[start objectAtIndex:1] intValue]);
        
    }

    
    NSDate* result;
    NSDateComponents *comps3 = [[NSDateComponents alloc] init];
    [comps3 setMinute:[[start objectAtIndex:1]intValue]];
    [comps3 setHour:[[start objectAtIndex:0]intValue]];
    //NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSLog(@"gregorian %@", gregorian);
    result = [gregorian dateFromComponents:comps3];
    [comps3 release];
    
    //NSLog(@"result: %@", result);
    
    NSDate *newDate;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    [dateComponents setMinute:[[start objectAtIndex:1]intValue]];
    [dateComponents setHour:[[start objectAtIndex:0]intValue] + 1];
    newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSLog(@"newDate: %@", newDate);
    NSLog(@"newDate: %.0f", ([newDate timeIntervalSince1970] * 1000));
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];

    
    NSLog(@"result %@", result);
    
    NSDate *now = [NSDate date];
    NSDateComponents *comp2 = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate: now];
    NSInteger hour2 = [comp2 hour];
    NSInteger minute2 = [comp2 minute];
    
    NSLog(@"hour and minute %ld:%ld", (long)hour2, (long)minute2);
    
    //17 jan 13:
    //Nyttig Kilde: http://www.picksourcecode.com/ps/ct/161110.php
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm"];
    NSString *nowString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:now]];
    
    NSLog(@"nowString %@", nowString);

    NSLog(@"now %@", now);
    //NSDate *naavaerende = [NSDate date];
    self.bv = [[BookingView alloc] init];

    
    int naatimer = 0;
    int rest = 0;
    
    if ([now compare:newDate] == NSOrderedDescending) {
        NSLog(@"date1 is later than date2");

        rest = ([[slutt objectAtIndex:0]intValue] * 60) + [[slutt objectAtIndex:1]intValue];
        
        naatimer = (hour2 * 60) + minute2;
        
        //self.bv.starttidspunktet.text = [NSString stringWithFormat:@"%ld:%ld", (long)hour2, (long)minute2];
        self.bv.starttidspunktet.text = nowString;
        
        
    } else if ([now compare:newDate] == NSOrderedAscending) {
        NSLog(@"date1 is earlier than date2");
        
        naatimer = ([[start objectAtIndex:0]intValue] * 60) + [[start objectAtIndex:1]intValue];
        
        rest = ([[slutt objectAtIndex:0]intValue] * 60) + [[slutt objectAtIndex:1]intValue];
        
        self.bv.starttidspunktet.text = [NSString stringWithFormat:@"%@:%@", [start objectAtIndex:0], [start objectAtIndex:1]];
        
        NSLog(@"naatimer %i rest %i", naatimer, rest);
        
        
    } else {
        NSLog(@"dates are the same");
        
    }
    


    
    //7.jan 13
    //NSDate *naa = [NSDate date];
    //NSString *datotekst = [DateUtil2 hourAndMinutes:naa];
    //NSArray *splittetdato = [datotekst componentsSeparatedByString:@":"];
    
    //int naatimer = ([[splittetdato objectAtIndex:0]intValue] * 60) + [[splittetdato objectAtIndex:1]intValue];
    
    /*
    int naatimer = ([[start objectAtIndex:0]intValue] * 60) + [[start objectAtIndex:1]intValue];
    
    int rest = ([[slutt objectAtIndex:0]intValue] * 60) + [[slutt objectAtIndex:1]intValue];
     */
    
    int totalgjenstaende = rest - naatimer;
    
    
    
    NSLog(@"timer rest totalgjenstaende %ld %ld %ld", (long) naatimer, (long)rest, (long)totalgjenstaende);
    
    NSArray *tempArray = [NSArray arrayWithObjects:@"15 minutter", @"30 minutter", @"60 minutter", nil];
    
    self.minuttArray = [[NSMutableArray alloc]init];
    
    if (totalgjenstaende > 60){
        totalgjenstaende = 60;
    }else if (totalgjenstaende < 0){
        totalgjenstaende = 0;
    }
    
    if (totalgjenstaende >= 60){
        [self.minuttArray removeAllObjects];

        [self.minuttArray addObjectsFromArray:tempArray ];
    }else if (totalgjenstaende >= 30 && totalgjenstaende < 60){
        [self.minuttArray removeAllObjects];

        [self.minuttArray addObject:[tempArray objectAtIndex:0]];
        [self.minuttArray addObject:[tempArray objectAtIndex:1]];
        
    }else if (totalgjenstaende >= 15 && totalgjenstaende < 30){
        [self.minuttArray removeAllObjects];

        [self.minuttArray addObject:[tempArray objectAtIndex:0]];
        
    }else{
        [self.minuttArray removeAllObjects];
    }
    
    

    
    NSLog (@"final totalgjenstaende %ld", (long)totalgjenstaende);
    
    
    self.maxminutter = ([self.timer count] * 60) - (([self.forsteTimeMinutter count] * 5) + ([self.sisteTimeMinutter count] * 5));
    
    //self.gjenstaendeminutter = ([self.timer count] * 60) - (([self.forsteTimeMinutter count] * 5) + ([self.sisteTimeMinutter count] * 5));
    
    //self.gjenstaendeminutter = totalgjenstaende;

    
    NSLog(@"maxminutter %ld", (long)maxminutter);
    
    NSLog(@"siste min %@", self.sisteTimeMinutter);
    
    NSLog(@"timer %@", self.timer);
    
    
    self.minutter = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < 60; i += 5){
        [self.minutter addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.varighet = [[NSMutableArray alloc] initWithObjects:@"15", @"30", @"60", nil];


    
    NSString *temp = @"13:40";
    NSArray *testArray = [temp componentsSeparatedByString:@":"];
    NSLog(@"testarray %@", testArray);
    
    
    MeeRooViewController3 *mvc3 = [self viewMVC];

    
    self.bv.backgroundColor = [UIColor whiteColor];
    self.bv.autoresizingMask = NO;
    
    //17 des 12: Gir variabler til innholdet i booking-lappen
    [self.bv.romnavn setText:mvc3.moteromLabel.text];
    self.romnavn = mvc3.moteromLabel.text;
    self.bv.romnavn.backgroundColor = [UIColor lightGrayColor];
    
    
    //10 jan 13:
    //PICKERVIEW
    self.bv.scroller.delegate = self;
    self.bv.scroller.dataSource = self;
    //Skalere UIPickerView
    //Kilde: http://www.mlsite.net/blog/?p=221
    self.bv.scroller.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.bv.scroller.showsSelectionIndicator = YES;
    self.bv.scroller.userInteractionEnabled = YES;
    self.bv.scroller.opaque = YES;
    self.bv.scroller.clearsContextBeforeDrawing = YES;
    self.bv.scroller.autoresizesSubviews = YES;
    
    
    NSInteger maxDefault = [self.minuttArray count] - 1; //størrelse til arrayen minus 1 for eksisterende siste indeks
    NSLog(@"self.minuttArray count %i", [self.minuttArray count]);
    //Dette fordi UIPickerView sin metode oppdaterer ikke row før man har beveget på scrollen, og dermed er oppstartindeks alltid 0, selv om det er på andre indekser enn 0.
    if ([self.minuttArray count] > 0){
        [self.bv.scroller selectRow:maxDefault inComponent:0 animated:YES];
        valgteIndeks = maxDefault;
    }else{
        [self.minuttArray addObject:@" "];
    }
    
    


    
    //self.bv.tidsvelger = [[UIPickerView alloc]initWithFrame:CGRectMake(50, 150, 450, 216)];
    //self.bv.tidsvelger = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 71, 1024, 216)];
    
    //NSLog(@"timearray %@", self.bv.timearray);
    //NSLog(@"minuttarray %@", self.bv.minuttarray);
    

    
    //7 jan 13 endre metodenavn!
    //10 jan 13 Unkommenterte for å gi plass til self.bv.scroller-objektet
    //KNAPPER
    /*
    [self.bv.b1 addTarget:self action:@selector(klikketMinutter:) forControlEvents: UIControlEventTouchDown];
    [self.bv.b2 addTarget:self action:@selector(klikketMinutter:) forControlEvents: UIControlEventTouchDown];
    [self.bv.b3 addTarget:self action:@selector(klikketMinutter:) forControlEvents: UIControlEventTouchDown];
     

    
    NSLog(@"gj %ld", (long)self.gjenstaendeminutter);
    //20 des 12
    if (self.gjenstaendeminutter >= 60){
        [self.bv addSubview:self.bv.b1 ];
        [self.bv addSubview:self.bv.b2 ];
        [self.bv addSubview:self.bv.b3 ];
        
    }else if (self.gjenstaendeminutter >= 30){
        [self.bv addSubview:self.bv.b1 ];
        [self.bv addSubview:self.bv.b2 ];
        
    }else if (self.gjenstaendeminutter >= 15){
    
        [self.bv addSubview:self.bv.b1];
        
    }
     */
    
   [self.bv.bbi1 setAction:@selector(standardknappok:)];
    [self.bv.bbi1 setTarget:self];
    [self.bv.bbi2 setAction:@selector(standardknappavbryt:)];
    [self.bv.bbi2 setTarget:self];
    

    [self addSubview:self.bv];
    
        
    
}

-(void)standardknappok:(id)sender{
    
    //NSLog(@"valgteIndeks %i", valgteIndeks);
    
    //hente tidspunkter (time og minutt) fra møtelappen
    NSArray *start = [self.startTidspunktLabel.text componentsSeparatedByString:@":"];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    [dateComponents setMinute:[[start objectAtIndex:1]intValue]];
    [dateComponents setHour:[[start objectAtIndex:0]intValue]];
    NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSLog(@"newDate: %@", newDate);
    NSLog(@"newDate: %.0f", ([newDate timeIntervalSince1970] * 1000));
    
    //nåværende tidspunkt
    NSDate *now = [NSDate date];
    
    //deklarere dem så de er tilgjengelige i hele metodeskopen
    NSString *startpunkt = nil;
    NSString *sluttpunkt = nil;
    
    if ([now compare:newDate] == NSOrderedDescending) {
        NSLog(@"now er senere enn new Date");
        
        //11 jan 13 : Uten ekstra 60000 millisekunder, fordi ønsket tidspunktet er faktisk senere enn nåværende tidspunkt
        startpunkt = [NSString stringWithFormat:@"%lld",
                      (long long)([now timeIntervalSince1970] * 1000)];
        
        sluttpunkt = [NSString stringWithFormat:@"%lld",
                      (long long)(([now timeIntervalSince1970] * 1000)) + (long long)([[self.minuttArray objectAtIndex:valgteIndeks] doubleValue] * 60 * 1000)];
        
    } else if ([now compare:newDate] == NSOrderedAscending) {
        NSLog(@"now er tidligere enn newDate");
        
        //11 jan 13: Med ekstra 60000 millisekunder (1 minutt), for å kunne booke.
        //15 jan 13: Feil!
        startpunkt = [NSString stringWithFormat:@"%lld",
                      (long long)([newDate timeIntervalSince1970] * 1000) + 60000];
        
        sluttpunkt = [NSString stringWithFormat:@"%lld",
                      (long long)(([newDate timeIntervalSince1970] * 1000)) + (long long)([[self.minuttArray objectAtIndex:valgteIndeks] doubleValue] * 60 * 1000) + 60000];
        
        
    } else {
        NSLog(@"Begge datoer er eksakt samme");
        
    }
    
    
    //NSLog(@"startpunkt %@", startpunkt);
    //NSLog (@"end %@", sluttpunkt);
    
    
    //10 jan 13 : Unkommenterer
    [self sendJSON:self.romnavn heledag:false start:startpunkt slutt:sluttpunkt eier:@"" tittel:@"Opptatt"];
  
}



-(void)standardknappavbryt:(id)sender{
    
    [self.tempbutton removeFromSuperview];
    [self.bv removeFromSuperview];
    MeeRooViewController3 *myController = [self viewMVC];
    myController.scrollView.userInteractionEnabled = YES;
    [myController restartTimer];

    
}



//PICKERVIEW
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.minuttArray count];
    
}

-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //10 jan 13 NSString stringWithFormat er her for å gjøre tekster senter
    return [NSString stringWithFormat:@"                      %@",[self.minuttArray objectAtIndex:row]];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //[self.bv.scroller reloadAllComponents];
    valgteIndeks = row;
    
}




-(void)sendJSON:(NSString*)lokalisjon heledag:(BOOL)heledagResultat start:(NSString*)starttid slutt:(NSString*)sluttid eier:(NSString*)e tittel:(NSString*)t{
    
    
    NSLog(@"lokalisjon %@", lokalisjon);
    
    NSString *servernavn = [self finneriktigserverromnavn:lokalisjon];
        
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://prototype.kantega.lan/meeroo/appointments/%@/", servernavn]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];

    
    NSString *temp = [NSString stringWithFormat:@"{\"subject\":\"%@\",\"location\":\"%@\",\"organizer\":\"%@\",\"allDayEvent\":%@,\"startDate\":%@,\"endDate\":%@}", t, lokalisjon, e, @"false", starttid, sluttid];
    
    //7 jan 13, vil det fungere?
    const char *str1 = [temp UTF8String];
    
    NSString *jsonRequest = [NSString stringWithUTF8String:str1];

    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    
    NSLog(@"Request: %@", jsonRequest);

    
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [request release];
    
    if (connection) {
        NSLog(@"connected!");
        //       receivedData = [[NSMutableData data] retain];
        
        NSMutableData *d = [[NSMutableData data] retain];
        NSLog(@"d %@", d);
        [d release];
    }
    
    [connection release];
    

}

-(NSString*)finneriktigserverromnavn:(NSString*)romnavn{
 
    NSDictionary *romnavner = [NSDictionary dictionaryWithObjectsAndKeys:  @"mrokathmandu", @"Kathmandu", @"mromonjo", @"Monjo",  @"mro.lukla", @"Lukla", @"mronamcheBazaar",@"Namche Bazaar",  @"mro.chule", @"Chule", @"mro.haibung",@"Haibung",  @"mro.kantina",@"Kantina",  @"MRTNordlys",@"Nordlys",  @"MRTHimalaya",@"Himalaya",  @"MRTPlay",@"Play",  @"MRTAlexandria",@"Alexandria",  @"MRTBuen",@"Buen", nil];
    
    NSString *servernavn = [romnavner valueForKey:romnavn];
    NSLog(@"romnavn %@", romnavn);
    NSLog(@"servernavn %@", servernavn);
    
    return servernavn;
    
    
}

-(void)slettMetode:(id)sender{
    
    NSLog(@"slettMetode");
    
    //7.jan
    [self slettMetode:self.moteID rom:self.romnavn];
    
}



-(void)slettMetode:(NSString*)ID rom:(NSString*)romnavn{
    
    //3.jan går det uten (id)sender?
    
    NSString *servernavn = [self finneriktigserverromnavn:romnavn];
    
    //NSLog(@"servernavn: %@", servernavn);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://prototype.kantega.lan/meeroo/appointments/%@/delete/", servernavn]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];

    
    NSString *str1 = [NSString stringWithFormat:@"{%@}",ID];
    
    //3.jan vil det fungere med const char *?
    //11 jan JA!
    const char *str = [str1 UTF8String];
    
    NSString *jsonRequest = [NSString stringWithUTF8String:str];
    
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSLog(@"Request: %@", jsonRequest);

    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [request release];
    
    if (connection) {
        NSLog(@"connected!");
        //       receivedData = [[NSMutableData data] retain];
        
        NSMutableData *d = [[NSMutableData data] retain];
        NSLog(@"d %@", d);
        [d release];
    }

    [connection release];
    
}



//KNAPPER
-(void)klikketMinutter:(id)sender{
    
    MeeRooViewController3 *myController = [self viewMVC];
    myController.scrollView.userInteractionEnabled = YES;
    [myController restartTimer];
    [tempbutton removeFromSuperview];
    
    NSString *startpunkt = [NSString stringWithFormat:@"%lld",
                            (long long)([[NSDate date] timeIntervalSince1970] * 1000) + 60000];
    NSLog (@"time %@", startpunkt);
    
    //7.jan 13 For å gjøre om 15, 30 og 60 minutter til millisekunder
    int femten = 15 * 60 * 1000;
    int tretti = 30 * 60 * 1000;
    int seksti = 60 * 60 * 1000;
    
    UIButton *button = (UIButton*)sender;
    
    NSString *sluttpunkt = nil;
    
    if (button.tag == 1){
        NSLog(@"b1 er klikket");
        sluttpunkt = [NSString stringWithFormat:@"%lld",
                                (long long)(([[NSDate date] timeIntervalSince1970] * 1000)) + femten + 60000];
        NSLog (@"end %@", sluttpunkt);
    }else if (button.tag == 2){
        NSLog(@"b2 er klikket");

        sluttpunkt = [NSString stringWithFormat:@"%lld",
                                (long long)(([[NSDate date] timeIntervalSince1970] * 1000)) + tretti + 60000];
        NSLog (@"end %@", sluttpunkt);
    }else if (button.tag == 3){
        NSLog(@"b3 er klikket");

        sluttpunkt = [NSString stringWithFormat:@"%lld",
                                (long long)(([[NSDate date] timeIntervalSince1970] * 1000)) + seksti + 60000];
        NSLog (@"end %@", sluttpunkt);
    }else{
        NSLog(@"No such button exists");
    }

    

    
}





-(void)dealloc{
    
    self.minuttArray = nil;
    self.bv = nil;
    self.romnavn = nil;
    self.startTidspunktLabel = nil;
    self.sluttTidspunktLabel = nil;

    self.moteID = nil;
    self.moteIDer = nil;
    [super dealloc];

    
}




//22.okt 12
-(void)bookingButtonEntered:(id)sender{
    
    NSLog(@"Her er booking");
    
    //if (self ...)?
    //17 des 12, det er nok med å fylle ut møteromslappen slik at ny lapp kan ikke skapes før den første lappen lukkes.
    [self performSelector:@selector(callBookingLapp)];
    
    MeeRooViewController3 * myController = [self viewMVC];
    [myController stopTimer];
    

    
    //10 jan 13: For å ha valgfri bakgrunnsfarge, må man gå for UIButtonTypeCustom, ikke UIButtonTypeRoundedRect
    //tempbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tempbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempbutton addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    [tempbutton setTitle:@"" forState:UIControlStateNormal];
    tempbutton.frame = myController.view.frame;
    tempbutton.backgroundColor = [UIColor darkGrayColor];
    tempbutton.alpha = 0.5;
    [myController.view addSubview:tempbutton];
    
    myController.scrollView.userInteractionEnabled = NO;
    
    //NSLog(@"self.bounds %@", NSStringFromCGRect(self.bounds));
    //NSLog(@"self.frame %@", NSStringFromCGRect( self.frame));

    
    //10 jan 13 : Redusere høyde litt!
    //self.bv.frame = CGRectMake((1024 - 500)/2, (768-560)/2, 500,560);
    self.bv.frame = CGRectMake((1024 - 500)/2, (768-460)/2, 500,460);

    
    self.bv.item.title = self.romnavn;

    self.bv.layer.cornerRadius = 10.0;
    self.bv.layer.masksToBounds = YES;
    self.bv.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bv.layer.shadowRadius = 5.0;
    self.bv.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.bv.layer.opacity = 1.0;
    self.bv.layer.borderWidth = 3.0;
    
    //1024×768
    [myController.view addSubview:self.bv];

    self.userInteractionEnabled = YES;
    self.bv.userInteractionEnabled = YES;
    
 
}



- (BookingVC *)viewBVC {
    Class vcc = [BookingVC class];
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) if ([responder isKindOfClass: vcc]) return (BookingVC *)responder;
    return nil;
}


//17 des 12
//Kilde: http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone
- (MeeRooViewController3 *)viewMVC {
    Class vcc = [MeeRooViewController3 class];
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: vcc]) return (MeeRooViewController3 *)responder;
    }
    return nil;
}
    
    



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //Kilde: http://stackoverflow.com/questions/917932/retrieve-httpresponse-httprequest-status-codes-iphone-sdk
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    
    NSLog(@"response %i", responseStatusCode);
    
    
    if (responseStatusCode == 201){
        
        //NSLog(@"Godkjent");
        
        self.statusString = @"Godkjent";
        
    }else if (responseStatusCode == 400){
        
        self.statusString = @"Feil input";
        
    }else if (responseStatusCode == 500){
        
        self.statusString = @"Feil på serveren";
        
    }else if (responseStatusCode == 503){
        
        self.statusString = @"Tjenesten er utilgjengelig";
        
    }
 
    NSLog(@"self.statusString %@", self.statusString);
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"didFinishLoading %@", self.statusString);
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake((500-100)/2,400,100,50)];
    statusLabel.textColor = [UIColor blueColor];
    statusLabel.font = [UIFont systemFontOfSize:20.0f];
    statusLabel.text = self.statusString;
    [self.bv addSubview:statusLabel];
    
    //standard koder
    /*
     NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     
     NSMutableDictionary *jsonDictionary = [parser objectWithString:responseString error:nil];
     NSNumber * statusCode = [jsonDictionary objectForKey:@"StatusCode"];
     NSString * message = [jsonDictionary objectForKey:@"Message"];
     NSDictionary * content = [jsonDictionary objectForKey:@"Content"];
     // osv...
     */
    
    
    [self performSelector:@selector(fjerneObjekter) withObject:nil afterDelay:3];
    
    
}


-(void)fjerneObjekter{
    
    NSLog(@"fjerneObjekter triggered");
    
    [self.bv removeFromSuperview];
    [self.tempbutton removeFromSuperview];
    MeeRooViewController3 *myController = [self viewMVC];
    myController.scrollView.userInteractionEnabled = YES;
    [myController restartTimer];
    
}



- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSMutableData *d = [[NSMutableData data] retain];
    [d appendData:data];
    
    NSString *a = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSDictionary *appointmentlist = [NSJSONSerialization JSONObjectWithData:d
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:&error];
    
    [d release];
    
    for (NSDictionary *entry in appointmentlist) {
        
        /*
        NSString *startDate = [entry objectForKey:@"startDate"];
        NSString *endDate = [entry objectForKey:@"endDate"];
        NSString *subject = [entry objectForKey:@"subject"];
        NSString *organizer = [entry objectForKey:@"organizer"];
         */
        
        NSString *status = [entry objectForKey:@"StatusCode"];
        NSString *message = [entry objectForKey:@"Message"];
        NSString *content = [entry objectForKey:@"Content"];
        
        NSLog(@"status %@", status);
        NSLog(@"message %@", message);
        NSLog(@"content %@", content);
        
        
    }
    
    
    NSLog(@"DataID: %@", a);
    
    self.moteID = a;
    [a release];
    [self.moteIDer addObject:self.moteID];
    



}




 

@end