//
//  BookingView.m
//  Kantoko
//
//  Created by Maria Maria on 12/12/12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import "BookingView.h"
#import <UIKit/UIKit.h>

@implementation BookingView

@synthesize romnavn;
@synthesize pickedTimeIndex, pickedMinuttIndex;

//20 des 12
@synthesize b1, b2, b3;

//9 + 10 jan 13
@synthesize bbi1, bbi2, item, starttidspunktet;
@synthesize scroller;


-(id)init{
    return [self initWithFrame:CGRectMake(0,0,500,560)];
}
 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.superview bringSubviewToFront:self];
        romnavn = [[UILabel alloc]initWithFrame:CGRectMake(83,13,334,37)];
        romnavn.text = @"Romnavn";
        romnavn.backgroundColor = [UIColor blueColor];
        [self addSubview:romnavn];
        
        
        b1 = [[UIButton alloc]initWithFrame:CGRectMake(45,140,400,60)];
        b1.tag = 1;
        [b1 setTitle:@"15" forState:UIControlStateNormal];
        [b1 setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
        [b1 addTarget:self action:@selector(exitMetode) forControlEvents: UIControlEventTouchDown];
        b1.backgroundColor = [UIColor yellowColor];
        
        b2 = [[UIButton alloc]initWithFrame:CGRectMake(45,225,400,60)];
        b2.tag = 2;
        [b2 setTitle:@"30" forState:UIControlStateNormal];
        [b2 setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
        [b2 addTarget:self action:@selector(exitMetode) forControlEvents: UIControlEventTouchDown];
        b2.backgroundColor = [UIColor yellowColor];

        
        b3 = [[UIButton alloc]initWithFrame:CGRectMake(45,310,400,60)];
        b3.tag = 3;
        [b3 setTitle:@"60" forState:UIControlStateNormal];
        [b3 setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
        [b3 addTarget:self action:@selector(exitMetode) forControlEvents: UIControlEventTouchDown];
        b3.backgroundColor = [UIColor yellowColor];
        

        UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,500,50)];
        [self addSubview:bar];
        
        bbi1 = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                          target: self
                                          action: @selector(backButtonPressed)];
        
        bbi2 = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                target: self
                action: @selector(backButtonPressed)];
        
        item = [[UINavigationItem alloc] initWithTitle:@"Title"];
        item.rightBarButtonItem = bbi1;
        item.leftBarButtonItem = bbi2;
        [bar pushNavigationItem:item animated:NO];
        

        //PICKERVIEW
        self.scroller = [[UIPickerView alloc] initWithFrame:CGRectMake((500-445)/2,180,445,216)];
        self.scroller.delegate = self;
        self.scroller.dataSource = self;
        [self addSubview:self.scroller];
        
        
        starttidspunktet = [[UILabel alloc]initWithFrame:CGRectMake((500-200)/2, 100, 200, 40)];
        starttidspunktet.text = @"Time";
        starttidspunktet.textAlignment = UITextAlignmentCenter;
        starttidspunktet.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:starttidspunktet];
        
        
    }
    return self;
}


 



//12 des 12: Blir feil å fjerne seg selv hver gang man rører andre områder enn text, knapper osv.
/*
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Removed");
    [self removeFromSuperview];

}
 */
 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (void)dealloc
{
    // Release any retained subviews of the main view.
    //PICKERVIEW
    self.scroller = nil;
    b1 = nil;
    b2 = nil;
    b3 = nil;
    bbi1 = nil;
    bbi2 = nil;
    
    //[super dealloc];
}
 

//10 jan 13: Disse metoder er for self.scroller
//PICKERVIEW
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 0;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}





@end
