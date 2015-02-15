//
//  ViewController.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "ViewController.h"
#import "KDCalendarViewController.h"
#import "KDCalendarDelegate.h"

@interface ViewController () <KDCalendarDelegate>

// weak so as to be added through vc containment
@property (nonatomic, weak) KDCalendarViewController* calendarViewController;

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
    
    self.selectedDayLabel.text = @"No date selected";
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"KDCalendarViewContainment"])
    {
        self.calendarViewController = (KDCalendarViewController*)segue.destinationViewController;
        [self addChildViewController:self.calendarViewController];
        
        self.calendarViewController.delegate = self;
    }
}


#pragma mark - KDCalendarDelegate

-(void)calendarController:(KDCalendarViewController*)calendarViewController didSelectDay:(NSDate*)date
{
    if(!date)
    {
        self.selectedDayLabel.text = @"No date selected";
    }
    else
    {
        self.selectedDayLabel.text = [self.formatter stringFromDate:date];
    }
    
    
    
}

-(void)calendarController:(KDCalendarViewController*)calendarViewController didScrollToMonth:(NSDate*)date
{
    
    
    self.monthDisplayedDayLabel.text = [self.formatter stringFromDate:date];
}

@end
