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
@protocol KDCalendarDataSource;

// Define an NS_ENUM to handle both our month and week views
typedef NS_ENUM(NSUInteger, KDCalendarScope) {
    KDCalendarScopeMonth,
    KDCalendarScopeWeek
};


@interface KDCalendarView : UIView


@property (nonatomic, strong) NSDate* dateSelected;
@property (nonatomic, strong) NSDate* monthDisplayed; // a date representing the first of the month

// Declare the scope of the calendar
@property (nonatomic, assign) KDCalendarScope scope;


@property (nonatomic) BOOL showsEvents;
@property (nonatomic) BOOL showsWholeMonthsOnStartAndEnd;

@property (nonatomic, weak) id<KDCalendarDelegate> delegate;
@property (nonatomic, weak) id<KDCalendarDataSource> dataSource;

- (void)setDateSelected:(NSDate *)dateSelected animated:(BOOL)animated;
- (void)setMonthDisplayed:(NSDate *)monthDisplayed animated:(BOOL)animated;
- (void)setWeekDisplayed:(NSDate *)weekDisplayed animated:(BOOL)animated;

@end



@protocol KDCalendarDelegate <NSObject>

@optional

-(void)calendarController:(KDCalendarView*)calendarViewController didSelectDay:(NSDate*)date;
-(void)calendarController:(KDCalendarView*)calendarViewController didScrollToMonth:(NSDate*)date;
- (void)calendarController:(KDCalendarView *)calendarViewController didScrollToWeek:(NSDate *)date;

/* YES by default */
-(BOOL)calendarController:(KDCalendarView*)calendarViewController canSelectDate:(NSDate*)date;

@end


@protocol KDCalendarDataSource <NSObject>

@required
-(NSDate*)startDate;


@optional
-(NSDate*)endDate;

@end




