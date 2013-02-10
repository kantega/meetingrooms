//
//  BookingView.m
//  Kantoko
//
//  Created by Maria Maria on 12/12/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "BookingView.h"
#import <UIKit/UIKit.h>
#import "Meeting.h"
#import "DateUtil.h"
#import "Configuration.h"
#import "KantokoViewController.h"

@implementation BookingView

@synthesize meeting = _meeting;

@synthesize barButtonAvbryt, item, starttidspunktet, onBookingRequestCompleted;

NSString* _statusString;
NSInteger _statusCode;

Configuration* _configuration;
NSString* _roomnavn;
NSDate* _bookMoteFra;
NSDate* _bookMoteTil;
NSDate* _naermesteKvarterTilNaa;  // møtet kan ikke starte kl.1600 hvis det er allerede 16:28 -> da blir dette 16:30

UIButton* btnBook15Minutes;
UIButton* btnBook30Minutes;
UIButton* btnBook45Minutes;
UIButton* btnBook60Minutes;


-(id)init { 
    return [self initWithFrame:CGRectMake(0,0,500,560)];
}
 

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _configuration = [KantokoViewController getCurrentConfiguration];
        _roomnavn = _configuration.room.displayname;
        _naermesteKvarterTilNaa = [DateUtil roundToClosestQuarter:[NSDate date]];

        [self.superview bringSubviewToFront:self];
        
        UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,500,50)];
        bar.tintColor = [UIColor colorWithRed:0.541 green:0.768 blue:0.831 alpha:1];
        [self addSubview:bar];

        
        barButtonAvbryt = [[UIBarButtonItem alloc] initWithTitle:@"Tilbake"
                                                   style:UIBarButtonItemStyleBordered target:self
                                                   action:@selector(standardknappavbryt)];
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titlelabel.backgroundColor = [UIColor clearColor];
        titlelabel.font = [UIFont boldSystemFontOfSize:20.0];
        titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.text = [@"Smidig booking: " stringByAppendingString:_roomnavn];
        titlelabel.textColor = [UIColor blackColor];
        
        item = [[UINavigationItem alloc] init];
        item.titleView = titlelabel;
        [titlelabel sizeToFit];
        item.leftBarButtonItem = barButtonAvbryt;
        [bar pushNavigationItem:item animated:NO];

        [self layer].cornerRadius = 10.0;
        [self layer].masksToBounds = YES;
        [self layer].shadowColor = [UIColor blackColor].CGColor;
        [self layer].shadowRadius = 5.0;
        [self layer].shadowOffset = CGSizeMake(3.0, 3.0);
        [self layer].opacity = 1.0;
        [self layer].borderWidth = 3.0;
        
        self.backgroundColor = [UIColor whiteColor];

        starttidspunktet = [[UILabel alloc]initWithFrame:CGRectMake((500-200)/2, 80, 200, 40)];
        starttidspunktet.text = @"Time";
        starttidspunktet.textAlignment = UITextAlignmentCenter;
        starttidspunktet.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:starttidspunktet];
        
        btnBook15Minutes = [self makeBookingButtonWithTitle:@"     15 minutter" andOffsetY: 160];
        [btnBook15Minutes addTarget:self action:@selector(book15Minutes:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBook15Minutes];
        
        btnBook30Minutes = [self makeBookingButtonWithTitle:@"     30 minutter" andOffsetY: 250];
        [btnBook30Minutes addTarget:self action:@selector(book30Minutes:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBook30Minutes];
        
        btnBook45Minutes = [self makeBookingButtonWithTitle:@"     45 minutter" andOffsetY: 340];
        [btnBook45Minutes addTarget:self action:@selector(book45Minutes:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBook45Minutes];
        
        btnBook60Minutes = [self makeBookingButtonWithTitle:@"     60 minutter" andOffsetY: 430];
        [btnBook60Minutes addTarget:self action:@selector(book60Minutes:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBook60Minutes];

    }
    return self;
}

-(UIButton*)makeBookingButtonWithTitle:(NSString*) title andOffsetY: (NSInteger) offsetY {
    UIButton* btnBooking = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBooking.frame = CGRectMake((500-200)/2, offsetY, 200, 60);
    btnBooking.opaque = YES;
    UIImage* image = [UIImage imageNamed:@"clock60.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(29, 55, 29, 4);
    image = [image resizableImageWithCapInsets:insets];
    [btnBooking setBackgroundImage:image forState:UIControlStateNormal];
    [btnBooking setTitle:title forState:UIControlStateNormal];
    btnBooking.layer.cornerRadius = 10.f;
    btnBooking.layer.masksToBounds = YES;
    return btnBooking;
}


-(void)setMeeting:(Meeting*) meeting {
    _meeting = meeting;

    NSInteger tilgjengeligeMinutter = 0;
    if (_meeting.isNow) {
        _bookMoteFra = _naermesteKvarterTilNaa;
        starttidspunktet.text = [DateUtil hourAndMinutes:_naermesteKvarterTilNaa];
        tilgjengeligeMinutter = [DateUtil minutesBetweenStart:_naermesteKvarterTilNaa andEnd:_meeting.end];
    } else {
        _bookMoteFra = _meeting.start;
        starttidspunktet.text = [DateUtil hourAndMinutes:_meeting.start];
        tilgjengeligeMinutter = _meeting.durationInMinutes;
    }
 
    btnBook15Minutes.hidden = (tilgjengeligeMinutter < 15);
    btnBook30Minutes.hidden = (tilgjengeligeMinutter < 30);
    btnBook45Minutes.hidden = (tilgjengeligeMinutter < 45);
    btnBook60Minutes.hidden = (tilgjengeligeMinutter < 60);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    
    NSLog(@"response %i", responseStatusCode);
    
    _statusCode = responseStatusCode;
    _statusString = [self messageForStatusCode:_statusCode];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"didFinishLoading %@", _statusString);
    
    if (_statusCode == 201)
        onBookingRequestCompleted(_statusString, NULL);
    else
        onBookingRequestCompleted(NULL, _statusString);
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    _statusCode = 999; //TODO : error?
    _statusString = error.localizedDescription;
    onBookingRequestCompleted(NULL, _statusString);
}

- (NSString*)messageForStatusCode:(NSInteger)statusCode {
    NSString* message;
    switch (statusCode) {
        case 201: message = @"Godkjent"; break;
        case 400: message = @"Feil input"; break;
        case 500: message = @"Feil på serveren"; break;
        case 503: message = @"Tjenesten er utilgjengelig"; break;
        default: message = @"Ukjent feil"; break;
    }
    return message;
}

-(void)sendBookingRequestForMinutes:(NSInteger)meetingDuration {
    NSUInteger intervalMinutes = meetingDuration * 60;
    _bookMoteTil = [_bookMoteFra dateByAddingTimeInterval:intervalMinutes];
    NSString *bookerFra = [NSString stringWithFormat:@"%lld",(long long)([_bookMoteFra timeIntervalSince1970] * 1000)];
    NSString *bookerTil = [NSString stringWithFormat:@"%lld",(long long)([_bookMoteTil timeIntervalSince1970] * 1000)];
    [self sendJSON:_roomnavn heledag:false start:bookerFra slutt:bookerTil eier:@"" tittel:@"Opptatt"];
}

- (void)book15Minutes:(id)sender{
    [self sendBookingRequestForMinutes: 15];
}

- (void)book30Minutes:(id)sender{
    [self sendBookingRequestForMinutes: 30];
}

- (void)book45Minutes:(id)sender{
    [self sendBookingRequestForMinutes: 45];
}

- (void)book60Minutes:(id)sender{
    [self sendBookingRequestForMinutes: 60];
}


// TODO HARDCODED URLs??? 
-(void)sendJSON:(NSString*)location heledag:(BOOL)heledagResultat start:(NSString*)starttid slutt:(NSString*)sluttid eier:(NSString*)eier tittel:(NSString*)tittel{
    
    
    NSLog(@"lokalisjon %@", location);
    
    NSString *servernavn = [self finneriktigserverromnavn:location];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://prototype.kantega.lan/meeroo/appointments/%@/", servernavn]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    
    NSString *temp = [NSString stringWithFormat:@"{\"subject\":\"%@\",\"location\":\"%@\",\"organizer\":\"%@\",\"allDayEvent\":%@,\"startDate\":%@,\"endDate\":%@}", tittel, location, eier, @"false", starttid, sluttid];
    
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
    
    if (connection) {
        NSLog(@"connected!");
        //       receivedData = [[NSMutableData data] retain];
        
        NSMutableData *d = [NSMutableData data];
        NSLog(@"d %@", d);
    }
}

-(NSString*)finneriktigserverromnavn:(NSString*)romnavn{
    
    NSDictionary *romnavner = [NSDictionary dictionaryWithObjectsAndKeys:  @"mrokathmandu", @"Kathmandu", @"mromonjo", @"Monjo",  @"mro.lukla", @"Lukla", @"mronamcheBazaar",@"Namche Bazaar",  @"mro.chule", @"Chule", @"mro.haibung",@"Haibung",  @"mro.kantina",@"Kantina",  @"MRTNordlys",@"Nordlys",  @"MRTHimalaya",@"Himalaya",  @"MRTPlay",@"Play",  @"MRTAlexandria",@"Alexandria",  @"MRTBuen",@"Buen", nil];
    
    NSString *servernavn = [romnavner valueForKey:romnavn];
    NSLog(@"romnavn %@", romnavn);
    NSLog(@"servernavn %@", servernavn);
    
    return servernavn;
}

@end
    
