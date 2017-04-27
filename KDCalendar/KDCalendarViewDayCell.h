//
//  KDCalendarViewDayCell.h
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDCalendarViewDayCell : UICollectionViewCell
{
    UIView* _selectedMarkView;
    UIView* _todayMarkView;
    UIView* _eventsMarksView;
}

@property (nonatomic, strong) UILabel* label;
@property (nonatomic) BOOL isToday;
@property (nonatomic) BOOL isCurrentMonth;
@property (nonatomic) BOOL isDaySelected;


@property (nonatomic, weak) NSArray* events;

@property (nonatomic, strong) NSDate* date;


@end
