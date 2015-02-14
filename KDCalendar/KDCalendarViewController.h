//
//  KDCalendarViewController.h
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCalendarViewMonthCell.h"
#import "KDCalendarDelegate.h"

@interface KDCalendarViewController : UIViewController



@property (nonatomic, strong) NSDate* dateSelected;
@property (nonatomic, readonly) NSDate* monthDisplayed;

@property (nonatomic, weak) id<KDCalendarDelegate> delegate;

- (void) setDateSelected:(NSDate *)dateSelected animated:(BOOL)animated;

@end




