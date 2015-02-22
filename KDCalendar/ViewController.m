//
//  ViewController.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "ViewController.h"
#import "KDCalendarView.h"

@interface ViewController () <KDCalendarDelegate, KDCalendarDataSource>


@property (nonatomic, weak) IBOutlet KDCalendarView* calendarView;

@property (nonatomic, strong) NSDateFormatter* formatter;


@property (nonatomic, weak) IBOutlet UILabel* selectedDayLabel;
@property (nonatomic, weak) IBOutlet UILabel* monthDisplayedDayLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formatter = [[NSDateFormatter alloc] init];
    
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.formatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.selectedDayLabel.text = NSLocalizedString(@"No date selected", nil);
    
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
}



#pragma mark - KDCalendarDataSource


-(NSDate*)startDate
{
    return [NSDate date];
}


-(NSDate*)endDate
{
    NSDateComponents *offsetDateComponents = [[NSDateComponents alloc] init];
    
    offsetDateComponents.year = 1;
    
    NSDate *yearLaterDate = [[NSCalendar currentCalendar]dateByAddingComponents:offsetDateComponents
                                                                   toDate:[NSDate date]
                                                                  options:0];
    
    return yearLaterDate;
}

#pragma mark - KDCalendarDelegate

-(void)calendarController:(KDCalendarView*)calendarViewController didSelectDay:(NSDate*)date
{
    if(!date)
    {
        self.selectedDayLabel.text = NSLocalizedString(@"No date selected", nil);
    }
    else
    {
        self.selectedDayLabel.text = [self.formatter stringFromDate:date];
    }
    
    
}

-(void)calendarController:(KDCalendarView*)calendarViewController didScrollToMonth:(NSDate*)date
{
    
    
    self.monthDisplayedDayLabel.text = [self.formatter stringFromDate:date];
}

@end
