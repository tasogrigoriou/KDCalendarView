//
//  ViewController.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "ViewController.h"
#import "KDCalendarView.h"

@interface ViewController () <KDCalendarDelegate, KDCalendarDataSource, UITextFieldDelegate>


@property (nonatomic, weak) IBOutlet KDCalendarView* calendarView;

@property (nonatomic, strong) NSDateFormatter* formatter;
@property (nonatomic, strong) NSDateFormatter* parser;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstaint;

@property (nonatomic, weak) IBOutlet UILabel* selectedDayLabel;
@property (nonatomic, weak) IBOutlet UILabel* monthDisplayedDayLabel;

@property (nonatomic, weak) IBOutlet UITextField* inputTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formatter = [[NSDateFormatter alloc] init];
    self.parser = [[NSDateFormatter alloc] init];
    
    self.parser.dateFormat = @"dd.MM.yyyy";
    
    
    self.selectedDayLabel.text = NSLocalizedString(@"No date selected", nil);
    
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    
    self.calendarView.layer.borderWidth = 1.0;
    self.calendarView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) keyboardFrameDidChange:(NSNotification*)notification
{
    
    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    self.bottomConstaint.constant = (notification.name == UIKeyboardWillShowNotification) ? 256.0 : 60.0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
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
    
    NSDate *yearLaterDate = [[NSCalendar currentCalendar] dateByAddingComponents:offsetDateComponents
                                                                          toDate:[NSDate date]
                                                                         options:0];
    
    return yearLaterDate;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.inputTextField.text = @"";
    [self.inputTextField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString* mutableTextString = self.inputTextField.text.mutableCopy;
    
    [mutableTextString replaceCharactersInRange:range withString:string];
    
    if(range.length == 0) // we are adding a sinlge digit
    {
        if(range.location == 1 || range.location == 4)
        {
            [mutableTextString appendString:@"."];
        }
    }
    
    
    self.inputTextField.text = mutableTextString;
    
    return NO;
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
- (IBAction)selectPressed:(UIButton *)sender {
    
    
    NSDate* dateParsed = [self.parser dateFromString:self.inputTextField.text];
    if(!dateParsed)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error Parsing Date"
                                    message:@"The date you entered is not valid!"
                                   delegate:self cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
 
    }
    else
    {
        
        
        [self.calendarView setDateSelected:dateParsed];
        
        [self textFieldShouldReturn:self.inputTextField];
        
       
    }
}

-(void)calendarController:(KDCalendarView*)calendarViewController didScrollToMonth:(NSDate*)date
{
    [self.formatter setDateFormat:@"MMMM, yyyy"];
    
    self.monthDisplayedDayLabel.text = [self.formatter stringFromDate:date];
}

@end
