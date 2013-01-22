//
//  AppointmentsRow2.m
//  MeeRoo2
//
//  Created by Maria Maria on 8/27/12.
//  Copyright (c) 2012 Maria Maria. All rights reserved.
//

#import "AppointmentsRow2.h"
#import "Meeting2.h"
#import "DateUtil2.h"

@implementation AppointmentsRow2

@synthesize room, buttonMap, focusedMeeting;

UIColor *kantegaOrange;

double scale, max, now, hours, startX, height, padding, startY;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        scale = 39;
        startX = 156;
        //height = 50; //frame.size.height;
        height = frame.size.height;
        hours = 8;
        padding = 1.5;
        max = (3600 * hours);
        now =  [[NSDate date] timeIntervalSince1970];
        kantegaOrange = [UIColor colorWithRed:200/255.0 green:115/255.0 blue:40/255.0 alpha:1.0];
        
        //9 sep 12
        startY = 106;
        
    }
    return self;
}

//Dette viser romnavn
- (void)refresh {
    
    
    UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(2.0,2.0,160.0, height )];
    roomName.text = self.room.displayname;
    roomName.backgroundColor = [UIColor clearColor];
    roomName.textColor = [UIColor lightTextColor];
    roomName.font = [UIFont fontWithName:@"Verdana" size:20];
    roomName.lineBreakMode = UILineBreakModeWordWrap;
    roomName.numberOfLines = 0;
    [roomName sizeToFit];
    NSLog(@"roomname numberOfLine %i", roomName.numberOfLines);
    [self addSubview:roomName];
    [roomName release];
    
    //dette tegner oransje linjer i respektive rom (vertikale linjene)
    
    for (Meeting2 *meeting in self.room.meetings) {
        [self drawMeeting:meeting];
    }
     
}

//Denne metode tegner vertikale timelinjer under klokkeslettene
- (void) drawTimeline {
    NSDate *hour = [DateUtil2 roundHourDown:[NSDate date]];
    for (int i = 0; i < hours; i++) {
        int x = startX + ((([hour timeIntervalSince1970] - now) + 3600) / scale);
        [self drawVerticalLineAt:x];
        [self drawHourLabelAt:x hourText:[DateUtil2 hourAndMinutes:hour]];
        hour = [DateUtil2 roundHourUp:(hour)];
    }
}


//Denne metode skriver klokkesletter over timeplanen
- (void) drawHourLabelAt:(int)xValue hourText:(NSString *)hourText  {
    
    UILabel *hour = [[UILabel alloc] initWithFrame:CGRectMake(xValue - 20 ,0,60, 20)];
    hour.text = hourText;
    hour.backgroundColor = [UIColor clearColor];
    hour.textColor = [UIColor lightTextColor];
    [self addSubview:hour];
    [hour release];
     
}
 

- (void) drawVerticalLineAt:(int)xValue {
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(xValue,20,1,height * 2)];
    line.backgroundColor = [UIColor lightTextColor];
    [self addSubview:line];
    [line release];
}




//dette tegner de oransje linjene i timeplanen
- (void) drawMeeting:(Meeting2 *)meeting{
    
    
    NSLog (@"meeting.subject %@", meeting.subject);
    
    NSMutableArray *addSubjects = [[NSMutableArray alloc]init];
    [addSubjects addObject:meeting.subject];
    
    NSUInteger countOfMeetings = [addSubjects count];
    NSLog (@"self.room.displayname %@", self.room.displayname);
    [addSubjects release];

    
    NSMutableArray *addRooms = [[NSMutableArray alloc]init];
    [addRooms addObject:self.room.displayname];
    
    NSLog (@"self.room.meetings %@", self.room.meetings);
    
    NSLog (@"addRooms count %i", [addRooms count]);
    [addRooms release];
    NSLog (@"countOfMeetings %i", countOfMeetings);
    
    
    
    int startTime = ([meeting.start timeIntervalSince1970] - now);
    int endTime = ([meeting.end timeIntervalSince1970] - now);
    
    if (endTime < -3600) {
        return;
    }
    
    if (startTime > max) {
        return;
    }
    
    if (startTime < -3600) {
        startTime = -3600;
    }
    if (endTime > max) {
        endTime = max;
    }
    
    //x forteller når en oransje linje sin x skal begynne og width forteller hvor lang en oransje linje skal være avhengig av tidslengde på booking
    int x = startX + (3600 / scale) + (startTime / scale) + padding;
    
    //int x = startX + (3600 / scale) + (startTime / scale) + 20;
    //int y = startY + (height * 2);

    int width = ((endTime - startTime) / scale) - (2 * padding) ;
    
    
    UIButton *appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [appointmentButton addTarget:self
                          action:@selector(meetingTouched:)
                forControlEvents:UIControlEventTouchUpInside];
    

    
    
    //Dette gir tekst til oransje linjer, men jeg skjuler dem ved å gi samme tekstfarge som linjefarge,
    //dette er en foreløpig fiks på visning av riktig infolapp
    //23.okt subject
    //[appointmentButton setTitle:meeting.subject forState:UIControlStateNormal];
    //23.okt owner
    [appointmentButton setTitle:meeting.owner forState:UIControlStateNormal];

    //23.okt sette farge på tittel
    //[appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [appointmentButton setTitleColor:kantegaOrange forState:UIControlStateNormal ];

    
    //23.okt 12 for å gi luft mellom horisontale oransje linjene
    appointmentButton.frame = CGRectMake(x + 33, padding , width - 5, height - (2 * padding));
    
    //23.okt 12 Kommenterte ut.
    //appointmentButton.frame = CGRectMake(x + 20, padding , width + 10, height - (2 * padding));
    //appointmentButton.frame = CGRectMake(x, padding , width, ((height * 2) + height) );
    //[appointmentButton setFrame: CGRectMake(x, padding , width, (height * 2))]; //(height * 2));// + (2 * padding));
    

    appointmentButton.backgroundColor = kantegaOrange;
    appointmentButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    [self.buttonMap setObject:meeting forKey:[self button2string:appointmentButton]];
    [self addSubview:appointmentButton];
}


//Dette fremkaller møtelappen!
- (void) meetingTouched:(id)sender {
    
    
    NSString *key = [self button2string:sender];
    Meeting2 *meeting = [self.buttonMap objectForKey:key];
     
    
    self.focusedMeeting.subject = meeting.subject;
    self.focusedMeeting.start = meeting.start;
    self.focusedMeeting.end = meeting.end;
    self.focusedMeeting.owner = meeting.owner;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"meetingFocused" object:nil];
    
    
}




//Denne metode gir x- og y-verdier til oransje linjene
- (NSString *) button2string:(UIButton *)button {
       
    
    NSString *buttonString = [NSString stringWithFormat:@"%f:%f:%@",
                              button.frame.origin.x,
                              button.frame.origin.y,
                              [button titleForState:UIControlStateNormal]];
    
    return buttonString;
     
}


-(void)dealloc{
    
    self.buttonMap = nil;
    
    [super dealloc];
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
