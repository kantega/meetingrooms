//
//  AppointmentsRow.h
//  MeeRoo
//
//  Created by Øyvind Kringlebotn on 07.06.12.
//  Copyright (c) 2012 Kantega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentsRow : UIView

@property (retain, nonatomic) NSString *roomName;

- (void)refresh;

@end
