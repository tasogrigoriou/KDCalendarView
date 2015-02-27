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
    
    
    
    self.selectedDayLabel.text = NSLocalizedString(@"No date selected", nil);
    
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    
    self.calendarView.layer.borderWidth = 1.0;
    self.calendarView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
}



#pragma mark - KDCalendarDataSource


-(NSDate*)startDate
{
    
    NSDateComponents *offsetDateComponents = [[NSDateComponents alloc] init];
    
    offsetDateComponents.month = -3;
    
    NSDate *threeMonthsBeforeDate = [[NSCalendar currentCalendar]dateByAddingComponents:offsetDateComponents
                                                                                 toDate:[NSDate date]
                                                                                options:0];
    
    
    return threeMonthsBeforeDate;
}


-(NSDate*)endDate
{
    NSDateComponents *offsetDateComponents = [[NSDateComponents alloc] init];
    
    offsetDateComponents.year = 2;
    offsetDateComponents.month = 3;
    
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
        self.selectedDayLabel.text = NSLocalizedString(@"No Date Selected.", nil);
    }
    else
    {
        [self.formatter setDateStyle:NSDateFormatterMediumStyle];
        [self.formatter setTimeStyle:NSDateFormatterNoStyle];
        
        self.selectedDayLabel.text = [self.formatter stringFromDate:date];
    }
    
    
}

-(void)calendarController:(KDCalendarView*)calendarViewController didScrollToMonth:(NSDate*)date
{
    [self.formatter setDateFormat:@"MMMM, yyyy"];
    
    self.monthDisplayedDayLabel.text = [self.formatter stringFromDate:date];
}

@end
