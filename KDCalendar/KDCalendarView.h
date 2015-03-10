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


@interface KDCalendarView : UIView


@property (nonatomic, strong) NSDate* dateSelected;
@property (nonatomic, strong) NSDate* monthDisplayed;

@property (nonatomic) BOOL showsEvents;

@property (nonatomic, weak) id<KDCalendarDelegate> delegate;
@property (nonatomic, weak) id<KDCalendarDataSource> dataSource;

- (void) setDateSelected:(NSDate *)dateSelected animated:(BOOL)animated;
- (void)setMonthDisplayed:(NSDate *)monthDisplayed animated:(BOOL)animated;

@end



@protocol KDCalendarDelegate <NSObject>

@optional
-(void)calendarController:(KDCalendarView*)calendarViewController didSelectDay:(NSDate*)date;
-(void)calendarController:(KDCalendarView*)calendarViewController didScrollToMonth:(NSDate*)date;


/* YES by default */
-(BOOL)calendarController:(KDCalendarView*)calendarViewController canSelectDate:(NSDate*)date;


@end


@protocol KDCalendarDataSource <NSObject>

@required
-(NSDate*)startDate;


@optional
-(NSDate*)endDate;

@end




