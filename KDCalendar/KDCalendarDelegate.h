//
//  KDCalendarProtocol.h
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KDCalendarViewController;

@protocol KDCalendarDelegate <NSObject>

@optional
-(void)calendarController:(KDCalendarViewController*)calendarViewController didSelectDay:(NSDate*)date;
-(void)calendarController:(KDCalendarViewController*)calendarViewController didScrollToMonth:(NSDate*)date;
-(NSDate*)fromDate;
-(NSDate*)toDate;

/* YES by default */
-(BOOL)calendarController:(KDCalendarViewController*)calendarViewController canSelectDate:(NSDate*)date;


@end
