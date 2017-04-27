//
//  KDCalendarViewWeekCell.m
//  KDCalendar
//
//  Created by Anastasios Grigoriou on 4/9/17.
//  Copyright © 2017 karmadust. All rights reserved.
//

#import "KDCalendarViewWeekCell.h"
#import "KDCalendarViewDayCell.h"
#import "KDCollectionViewFlowLayout.h"
#import "KDCalendarHeaderView.h"


@interface KDCalendarViewWeekCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger firstWeekdayOfMonthIndex;

@property (nonatomic, assign) NSInteger numberOfDaysInMonth;

@property (nonatomic, strong) NSDateComponents *monthComponents;

@property (nonatomic, strong) NSDateComponents *weekComponents;
@property (nonatomic, assign) NSInteger numberOfWeeks;

@property (nonatomic, strong) NSDateComponents *todayDateComponents;

@property (nonatomic, strong) NSCalendar *calendar;

@end


@implementation KDCalendarViewWeekCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        KDCollectionViewFlowLayout *weekFlowLayout = [[KDCollectionViewFlowLayout alloc]
                                                      initWithCollectionViewSize:frame.size
                                                                    headerHeight:[KDCalendarHeaderView height]
                                                                           scope:KDCalendarScopeWeek];
        
        self.collectionView = [[UICollectionView alloc]
                               initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)
                        collectionViewLayout:weekFlowLayout];
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[KDCalendarViewDayCell class]
                forCellWithReuseIdentifier:NSStringFromClass([KDCalendarViewDayCell class])];
        
        [self.collectionView registerClass:[KDCalendarHeaderView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:NSStringFromClass([KDCalendarHeaderView class])];
    }
    
    return self;
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


// Return 7 cells for each day in the week.
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (!self.displayWeekDate) {
        return 0;
    }
    
    return 7;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        KDCalendarHeaderView *headerView = (KDCalendarHeaderView *)
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:NSStringFromClass([KDCalendarHeaderView class])
                                                  forIndexPath:indexPath];
        reusableView = headerView;
    }
    
    return reusableView;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDCalendarViewDayCell *dayCell = (KDCalendarViewDayCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KDCalendarViewDayCell class]) forIndexPath:indexPath];
    
    // Use NSDateComponents to draw out each cell item for each day in the month,
    // plus the offsetted days at beginning and end of each month.
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // Start at 0 to begin with our calculations below...
    offsetComponents.day = 0;
    
    // Make room for the days of the previous month.
    // (ex. If the first day of the month is a Tue then we need 2 slots)
    offsetComponents.day -= _firstWeekdayOfMonthIndex;
    
    // Add the day offset corresponding to the cell about to be drawn (will increment up by 1 for each cell item).
    offsetComponents.day += indexPath.item;
    
    // Get the date for each day cell corresponding to the offsetComponents.
    NSDate *dayCellDate = [_calendar dateByAddingComponents:offsetComponents
                                                     toDate:_displayWeekDate
                                                    options:0];
    
    // Get date components from our dayCellDate to display in our dayCell label.
    NSDateComponents *dayDateComponents = [_calendar
                                           components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                           fromDate:dayCellDate];
    
    // Give each dayCell label text which displays the day from our dayDateComponents as an integer
    dayCell.label.text = [NSString stringWithFormat:@"%d", (int)dayDateComponents.day];
    
    dayCell.date = dayCellDate;
    
    dayCell.isToday = (dayDateComponents.day == _todayDateComponents.day && dayDateComponents.month == _todayDateComponents.month && dayDateComponents.year == _todayDateComponents.year);
    
    dayCell.isDaySelected = NO;
    
    if (self.dateSelected) {
        
        NSDateComponents *selectedDateComponents = [_calendar
                                                    components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                      fromDate:self.dateSelected];
        
        // Set isDaySelected to yes if our comparisons match
        if (dayDateComponents.year == selectedDateComponents.year && dayDateComponents.month == selectedDateComponents.month && dayDateComponents.day == selectedDateComponents.day) {
            dayCell.isDaySelected = YES;
        }
        
    }
    
    // Check if we have events loaded from the iOS calendar
    if (self.events) {
        
        id entry = self.events[dayDateComponents.day - 1]; // events array is 0-indexed.
        
        if (entry != [NSNull null]) {
            NSMutableArray *eventContainer = (NSMutableArray *)entry;
            dayCell.events = eventContainer;
        }
    }
    
    return dayCell;
}


#pragma mark - UICollectionViewDelegate


- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDCalendarViewDayCell *dayCell = (KDCalendarViewDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // If the cell we select is not the cell that's already selected, assign the properties to the correct date.
    if (!dayCell.isDaySelected) {
        
        _dateSelected = dayCell.date;
        dayCell.isDaySelected = YES;
    }
    // Or else if the selected cell is the same cell, de-select it.
    else {
        _dateSelected = nil;
        dayCell.isDaySelected = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    [self.collectionView reloadData];
}


// Calculations for dates, components, and indexes go here
- (void)setDisplayWeekDate:(NSDate *)weekDate
{
    _displayWeekDate = weekDate;
    
    _todayDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                            fromDate:[NSDate date]];
    
    _weekComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:_displayWeekDate];
    
    // Get the first day of the month that's being displayed.
    NSDateComponents *firstOfTheMonthComponents = [_weekComponents copy];
    
    // Convert the components into an NSDate that is the first date of that month.
    NSDate *firstOfTheMonthDate = [self.calendar dateFromComponents:firstOfTheMonthComponents];
    
    _firstWeekdayOfMonthIndex = [self.calendar component:NSCalendarUnitWeekday
                                                fromDate:firstOfTheMonthDate] - 1;
    
    [self.collectionView reloadData];
}


- (NSCalendar *)calendar
{
    // Lazy loading of our calendar.
    if(!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    return _calendar;
}


- (void)setDateSelected:(NSDate *)dateSelected
{
    _dateSelected = dateSelected;
    [self.collectionView reloadData];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<KDCalendarViewWeekCell %p (display:%@, date:%@)>", self, self.displayWeekDate, self.dateSelected];
}


@end


























