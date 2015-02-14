//
//  KDCalendarViewController.h
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCalendarViewMonthCell.h"

@protocol KDCalendarDelegate;

@interface KDCalendarViewController : UIViewController



@property (nonatomic, strong) NSDate* dateSelected;
@property (nonatomic, readonly) NSDate* monthDisplayed;

@property (nonatomic, weak) id<KDCalendarDelegate> delegate;

- (void) setDateSelected:(NSDate *)dateSelected animated:(BOOL)animated;

@end


@protocol KDCalendarDelegate <NSObject>

@optional
-(void)calendarController:(KDCalendarViewController*)calendarViewController didSelectDay:(NSDate*)date;
-(void)calendarController:(KDCalendarViewController*)calendarViewController didScrollToMonth:(NSDate*)date;

/* YES by default */
-(BOOL)calendarController:(KDCalendarViewController*)calendarViewController canSelectDate:(NSDate*)date;

@end

@protocol KDCalendarDataSource <NSObject>

@optional
-(NSDate*)fromDate;
-(NSDate*)toDate;

@end
