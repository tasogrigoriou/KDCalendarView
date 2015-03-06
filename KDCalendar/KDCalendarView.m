//
//  KDCalendarViewController.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarView.h"
#import "KDCalendarViewDayCell.h"

#define DEFAULT_NUMBER_OF_MONTHS 24

@interface KDCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSCalendar *_calendar;
    NSDate *_startDateCache;
    NSDate *_endDateCache;
    BOOL _manualScroll;
}

@property (nonatomic, readonly) KDCalendarViewMonthCell* currentMonthCell;
@property (nonatomic, readonly) NSInteger monthIndex;
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, readonly) NSUInteger cellDisplayedIndex;

@end

@implementation KDCalendarView

@dynamic monthDisplayed;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Create Collection View and add it to the View
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    
    CGRect sFrame = self.frame;
    sFrame.origin = CGPointZero;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:sFrame
                                             collectionViewLayout:flowLayout];
    
    self.collectionView.pagingEnabled = YES;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[KDCalendarViewMonthCell class]
            forCellWithReuseIdentifier:NSStringFromClass([KDCalendarViewMonthCell class])];
    
    
    [self addSubview:self.collectionView];
    
    
    
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(self.dataSource)
    {
        
        
        _startDateCache = self.dataSource.startDate;
        
        // complaining about undeclared selector
        #pragma GCC diagnostic ignored "-Wundeclared-selector"
        if([self.dataSource respondsToSelector:@selector(endDate)])
        {
            _endDateCache = self.dataSource.endDate;
        }
        
        
        
    }
    
    // If the method did not return nil we can have a calendar
    return _startDateCache ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(self.delegate)
    {
        [self.delegate calendarController:self
                         didScrollToMonth:self.dataSource.startDate];
    }
    
    
    if(_endDateCache)
    {
        
        
        
        return [_calendar components:NSCalendarUnitMonth
                            fromDate:_startDateCache
                              toDate:_endDateCache
                             options:0].month;
        

    }
    else
    {
        // note: Setting it to large numbers like INT_MAX will result in a lot of overhead while launching the view
        // this is due to [UICollectionViewFlowLayout _getSizingInfos] running for all cells at launch
        return DEFAULT_NUMBER_OF_MONTHS;
    }
    
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KDCalendarViewMonthCell *monthCell = (KDCalendarViewMonthCell*)[collectionView dequeueReusableCellWithReuseIdentifier: NSStringFromClass([KDCalendarViewMonthCell class])
                                                                                                               forIndexPath: indexPath];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // offset by a month
    offsetComponents.month = indexPath.item;
    
    monthCell.displayMonthDate = [_calendar dateByAddingComponents:offsetComponents
                                                            toDate:_startDateCache
                                                           options:0];
    
    monthCell.delegate = self;
    
    monthCell.dateSelected = self.dateSelected;
    
    // * This will capture all the date as well as day selections in one place
    //monthCell.collectionView.delegate = self;
    
    return monthCell;
}


#pragma mark - UICollectionViewDataSource



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView != self.collectionView) // * This is the callback from the collection view inside each month cell, it refers to day cells
    {
        
        KDCalendarViewDayCell* dayCell = (KDCalendarViewDayCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        if(dayCell.isDaySelected)
        {
            _dateSelected = dayCell.date;
        }
        else // * De-select
        {
            _dateSelected = nil;
        }
        
        // Notify the delegate if there is one
        if([self.delegate respondsToSelector:@selector(calendarController:didSelectDay:)])
        {
            [self.delegate calendarController:self
                                 didSelectDay:_dateSelected];
        }
    }
    
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KDCalendarViewDayCell* dayCell = (KDCalendarViewDayCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if(!dayCell.isCurrentMonth) // * Cannot select grayed out dates
    {
        return NO;
    }
    
    
    // * This is implemented in KDMeetingDatePropertyController where we check for whether the
    if([self.delegate respondsToSelector:@selector(calendarController:canSelectDate:)])
    {
        BOOL canSelect = [self.delegate calendarController:self canSelectDate:dayCell.date];
        
        if(!canSelect)
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UIScrollViewDelegate


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:(UIScrollView*)self];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    // Notify the Delegate if there
    if(self.delegate && [self.delegate respondsToSelector:@selector(calendarController:didScrollToMonth:)])
    {
        
        [self.delegate calendarController:self
                         didScrollToMonth:self.currentMonthCell.displayMonthDate];
    }
    
}


#pragma mark - Accessors

- (void) setDateSelected:(NSDate *)dateSelected
                animated:(BOOL)animated
{
    
    // check whether the date asked is indeed between two dates
    if([dateSelected compare:_startDateCache] == NSOrderedAscending)
    {
        return;
    }
    else if (_endDateCache != nil && [dateSelected compare:_endDateCache] == NSOrderedDescending)
    {
        return;
    }
    
    _dateSelected = dateSelected;
    
    
    
    self.monthDisplayed = dateSelected;
    
    KDCalendarViewMonthCell* monthCell = [self monthCellForMonthIndex:[_calendar component:NSCalendarUnitMonth fromDate:dateSelected]];
    
    monthCell.dateSelected = _dateSelected;
    
    
}


-(KDCalendarViewMonthCell*)monthCellForMonthIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return (KDCalendarViewMonthCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
}




-(KDCalendarViewMonthCell*)currentMonthCell
{
    CGFloat monthCellWidth = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize.width;
    CGFloat pageNumberRoundedDown = floor( self.collectionView.contentOffset.x / monthCellWidth );
    
    return (KDCalendarViewMonthCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pageNumberRoundedDown inSection:0]];
    
}



#pragma mark - Accessors

// This gets a visual reference from the calendar
- (NSDate*)monthDisplayed
{
    
    // not loaded with the correct frame
    if(CGRectIsEmpty(self.collectionView.frame))
    {
        return nil;
    }
    
    // the date has not been set
    if(!_startDateCache)
    {
        return nil;
    }
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // offset by a month
    offsetComponents.month = self.cellDisplayedIndex;
    

    
    return [_calendar dateByAddingComponents:offsetComponents toDate:_startDateCache options:0];
}

- (void) setMonthDisplayed:(NSDate *)monthDisplayed
{
    [self setMonthDisplayed:monthDisplayed animated:NO];
    
}
- (void)setMonthDisplayed:(NSDate *)monthDisplayed animated:(BOOL)animated
{
    
    if(!self.monthDisplayed)
    {
        return;
    }
    
    
    // check whether the date asked is indeed between two dates
    if([monthDisplayed compare:_startDateCache] == NSOrderedAscending)
    {
        return;
    }
    else if (_endDateCache != nil && [monthDisplayed compare:_endDateCache] == NSOrderedDescending)
    {
        return;
    }
    
    NSDateComponents* differenceComponents = [_calendar components:NSCalendarUnitMonth
                                                          fromDate:_startDateCache
                                                            toDate:monthDisplayed
                                                           options:0];
    
    if(differenceComponents.month != self.cellDisplayedIndex)
    {
        CGRect rectToScroll = CGRectZero;
        rectToScroll.size = self.collectionView.bounds.size;
        rectToScroll.origin.x = differenceComponents.month * self.collectionView.bounds.size.width;
        
        _manualScroll = YES;
        [self.collectionView scrollRectToVisible:rectToScroll
                                        animated:animated];
    }
    
}

- (void) setDateSelected:(NSDate *)dateSelected
{
    
    [self setDateSelected:dateSelected animated:NO];
}



-(void) setDataSource:(id<KDCalendarDataSource>)dataSource
{
    _dataSource = dataSource;
    
    // if the view has already been presented, refresh with the new dataSource
    if(self.superview)
    {
        [self.collectionView reloadData];
    }
    
}

#pragma mark - Utility Methods

-(NSUInteger)cellDisplayedIndex
{
    return (NSInteger)(self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
}


@end
