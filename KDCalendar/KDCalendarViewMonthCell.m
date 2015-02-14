//
//  KDCalendarViewMonthCell.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarViewMonthCell.h"
#import "KDCalendarHeaderCollectionReusableView.h"
#import "KDCalendarViewDayCell.h"

@interface KDCalendarViewMonthCell () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger _firstDayOfMonthIndex;
    NSInteger _numberOfDaysInMonth;
    NSDateComponents* _monthComponents;
    NSCalendar *_calendar;
    NSDateComponents *_todayDateComponents;
}


@end

@implementation KDCalendarViewMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat headerHeight = [KDCalendarHeaderCollectionReusableView height];
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(frame.size.width / 7.0, (frame.size.height - headerHeight) / 6.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        
        flowLayout.headerReferenceSize = CGSizeMake(frame.size.width, headerHeight);
        flowLayout.footerReferenceSize = CGSizeZero;
        
        
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)
                                                 collectionViewLayout:flowLayout];
        
        // delegate is the parent controller
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        [self addSubview:self.collectionView];
        
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        
        [self.collectionView registerClass:[KDCalendarViewDayCell class]
                forCellWithReuseIdentifier:NSStringFromClass([KDCalendarViewDayCell class])];
        
        [self.collectionView registerClass:[KDCalendarHeaderCollectionReusableView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:NSStringFromClass([KDCalendarHeaderCollectionReusableView class])];
        
        
        
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (!self.displayMonthDate)
    {
        return 0;
    }
    
    
    NSInteger numberOfDaysPlusOffset = _numberOfDaysInMonth + _firstDayOfMonthIndex;
    NSInteger remainingDaysToFillCalendar = 7 - (numberOfDaysPlusOffset % 7);
    return numberOfDaysPlusOffset + remainingDaysToFillCalendar;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView* reusableView;
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        
        KDCalendarHeaderCollectionReusableView* headerView = (KDCalendarHeaderCollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                       withReuseIdentifier:NSStringFromClass([KDCalendarHeaderCollectionReusableView class])
                                                                                                              forIndexPath:indexPath];
        
        
        reusableView = headerView;
    }
    
    return reusableView;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KDCalendarViewDayCell *dayCell = (KDCalendarViewDayCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KDCalendarViewDayCell class])
                                                                                                         forIndexPath:indexPath];
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day = 0; // zero out the day (is is a stack variable)
    offsetComponents.day -= _monthComponents.day - 1; // take the date back to the first day of the month
    offsetComponents.day -= _firstDayOfMonthIndex; // make room for the days of the previous month (ex. If the first day of the month is a Tue then we need 2 slots)
    offsetComponents.day += indexPath.item; // add the day offset corresponding to the cell about to be drawn
    
    NSDate* dayCellDate = [_calendar dateByAddingComponents:offsetComponents
                                                     toDate:_displayMonthDate
                                                    options:0];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *dayDateComponens = [_calendar components:calendarUnit
                                                      fromDate:dayCellDate];
    // check if current date has events and add dot
    
    dayCell.label.text = [NSString stringWithFormat:@"%li", (long)dayDateComponens.day];
    
    dayCell.date = dayCellDate;
    
    dayCell.isToday = (dayDateComponens.day == _todayDateComponents.day && dayDateComponens.month == _todayDateComponents.month && dayDateComponens.year == _todayDateComponents.year);
    
    dayCell.isDaySelected = NO;
    
    if(self.dateSelected) // if we have a selected date
    {
        NSDateComponents *selectedDateComponens = [_calendar components:calendarUnit
                                                               fromDate:self.dateSelected];
        
        if(selectedDateComponens.year == dayDateComponens.year && selectedDateComponens.month == dayDateComponens.month)
        {
            
            dayCell.isDaySelected = (BOOL)(indexPath.item == selectedDateComponens.day + _firstDayOfMonthIndex - 1);
        }
        
        
    }
    
    
    dayCell.isCurrentMonth = (indexPath.item >= _firstDayOfMonthIndex) && (indexPath.item <= _numberOfDaysInMonth + _firstDayOfMonthIndex - 1);
    
    
    return dayCell;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)])
    {
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
        
    }
    
    return YES;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KDCalendarViewDayCell* cell = (KDCalendarViewDayCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    // * The cell is already selected
    if(!cell.isDaySelected)
    {
        
        _dateSelected = cell.date;
        cell.isDaySelected = YES;
    }
    else
    {
        _dateSelected = nil;
        cell.isDaySelected = NO;
    }
    
    
    if([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)])
    {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        
    }
    
    [self.collectionView reloadData];
}




-(void)setDisplayMonthDate:(NSDate *)monthDate
{
    
    if(!_calendar)
    {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    // Precalculate values below...
    
    _displayMonthDate = monthDate;
    
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    _monthComponents = [_calendar components:calendarUnit
                                    fromDate:_displayMonthDate];
    
    
    
    NSDateComponents* firstOfTheMonthComponents = [_monthComponents copy];
    firstOfTheMonthComponents.day = 1;
    NSDate* dateFromComponents = [_calendar dateFromComponents:firstOfTheMonthComponents];
    
    _firstDayOfMonthIndex = [_calendar component:NSCalendarUnitWeekday
                                        fromDate:dateFromComponents] - 1; // zero indexed
    
    _numberOfDaysInMonth = [_calendar rangeOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitMonth
                                          forDate:_displayMonthDate].length;
    
    _todayDateComponents = [_calendar components:calendarUnit
                                        fromDate:[NSDate date]];
    
    
    [self.collectionView reloadData];
    
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"<KDCalendarViewMonthCell %p (display:%@, date:%@)>", self, self.displayMonthDate, self.dateSelected];
}

@end
