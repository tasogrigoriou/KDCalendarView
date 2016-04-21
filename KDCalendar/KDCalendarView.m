//
//  KDCalendarViewController.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarView.h"
#import "KDCalendarViewDayCell.h"
#import <EventKit/EventKit.h>

#define DEFAULT_NUMBER_OF_MONTHS 24
#define MAX_NUMBER_OF_DAYS_IN_MONTH 31

@interface KDCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSCalendar *_calendar;
    NSDate *_startDateCache;
    NSDate *_endDateCache;
    NSDate *_startOfMonthCache;
    BOOL _manualScroll;
    EKEventStore *_store;
    
    NSInteger _numberOfItemsInSectionCache;
    
    NSInteger _firstDayActive;
    NSInteger _lastDayActive;
    
}

@property (nonatomic, readonly) KDCalendarViewMonthCell* currentMonthCell;
@property (nonatomic, readonly) NSInteger monthIndex;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray *events;

@property (nonatomic, readonly) NSUInteger cellDisplayedIndex;

@end

@implementation KDCalendarView

@dynamic monthDisplayed;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
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
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[KDCalendarViewMonthCell class]
            forCellWithReuseIdentifier:NSStringFromClass([KDCalendarViewMonthCell class])];
    
    
    [self addSubview:self.collectionView];
    
    // Events
    
    
}





#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(self.dataSource)
    {
        
        
        _startDateCache = self.dataSource.startDate;
        
        // * Get the start of the first month and set it as the base date
        NSDateComponents *components = [_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                    fromDate:_startDateCache];
        components.day = 1;
        
        _startOfMonthCache = [_calendar dateFromComponents:components];
        
        
        // complaining about undeclared selector
        #pragma GCC diagnostic ignored "-Wundeclared-selector"
        if([self.dataSource respondsToSelector:@selector(endDate)])
        {
            _endDateCache = self.dataSource.endDate;
        }
        else
        {
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            
            
            offsetComponents.month = DEFAULT_NUMBER_OF_MONTHS;
            
            // Set the end date as the last day of that month
            offsetComponents.month += 1;
            offsetComponents.day = 0;
            
            _endDateCache = [_calendar dateByAddingComponents:offsetComponents
                                                       toDate:_startDateCache
                                                      options:0];
            
        }
        
        if(!self.showsWholeMonthsOnStartAndEnd) // if we select NOT to show all the days of the first and last month (default) we must calculate the difference and cache it.
        {
            _firstDayActive = [_calendar component:NSCalendarUnitDay
                                          fromDate:_startDateCache];
            
            _lastDayActive = [_calendar component:NSCalendarUnitDay
                                         fromDate:_endDateCache];
        }
        else
        {
            _firstDayActive = 0;
            _lastDayActive = 0;
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
    
    if(self.showsEvents)
    {
        [self loadEventsInCalendar];
    }
    
    _numberOfItemsInSectionCache = [_calendar components:NSCalendarUnitMonth
                                                fromDate:_startDateCache
                                                  toDate:_endDateCache
                                                 options:0].month + 1;
    
    
    return _numberOfItemsInSectionCache;
    
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KDCalendarViewMonthCell *monthCell = (KDCalendarViewMonthCell*)[collectionView dequeueReusableCellWithReuseIdentifier: NSStringFromClass([KDCalendarViewMonthCell class])
                                                                                                               forIndexPath: indexPath];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // offset by a month
    offsetComponents.month = indexPath.item;
    
    
    
    monthCell.displayMonthDate = [_calendar dateByAddingComponents:offsetComponents
                                                            toDate:_startOfMonthCache
                                                           options:0];
    
    
    monthCell.firstDayActive = indexPath.item == 0 ? _firstDayActive : 0; // if it is the first cell then it might have an offset to its start
    
    monthCell.lastDayActive = indexPath.item == (_numberOfItemsInSectionCache - 1) ? _lastDayActive : 31; // if it is the last cell it might not finish at the end, otheriwe set it to the largest number possible
    
    
    
    monthCell.delegate = self;
    
    monthCell.dateSelected = self.dateSelected;
    

    if(_events)
    {
        monthCell.events = _events[indexPath.item];
    }
    
    return monthCell;
}


#pragma mark - UICollectionViewDelegate



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
    
    
    
    [self setMonthDisplayed:dateSelected animated:animated];
    
    NSInteger month = [_calendar components:NSCalendarUnitMonth
                                   fromDate:_startDateCache
                                     toDate:dateSelected
                                    options:0].month;
    
    KDCalendarViewMonthCell* monthCell = [self monthCellForMonthIndex:month];
    
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

- (void) setShowsEvents:(BOOL)showsEvents
{
    
    if(showsEvents && !_showsEvents &&  _startDateCache) // if we set to YES and the view has fetched the dates from the delegates
    {
        [self loadEventsInCalendar];
        
        
    }
    
    _showsEvents = showsEvents;
}


- (void) loadEventsInCalendar
{
    
    if(!_store)
    {
        _store = [[EKEventStore alloc] init];
    }
    
    void(^FetchEventsBlock)(void) = ^{
        
        NSPredicate *predicate = [_store predicateForEventsWithStartDate:_startDateCache
                                                                 endDate:_endDateCache
                                                               calendars:nil];
        
        NSArray* eventsArray = [_store eventsMatchingPredicate:predicate];
        
        
        // Process Events
        
        NSInteger numberOfItems = [self collectionView:self.collectionView numberOfItemsInSection:0];
        
        NSMutableArray* eventsByMonth = [NSMutableArray arrayWithCapacity:numberOfItems];
        
        for (int i = 0; i < numberOfItems; i++)
        {
            NSMutableArray* eventsByDay = [NSMutableArray arrayWithCapacity:MAX_NUMBER_OF_DAYS_IN_MONTH];
            for (int j = 0; j < MAX_NUMBER_OF_DAYS_IN_MONTH; j++)
            {
                NSMutableArray* eventsContainer = [NSMutableArray array];
                [eventsByDay addObject:eventsContainer];
            }
            [eventsByMonth addObject:eventsByDay];
         
        }
        
        for (EKEvent* event in eventsArray)
        {
          
            NSDateComponents *components = [_calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_startDateCache toDate:event.startDate options:0];
            
            NSMutableArray* monthMutableArray = (NSMutableArray*)eventsByMonth[components.month];
            
            NSMutableArray* eventsContainer = (NSMutableArray*)monthMutableArray[components.day];
            
            [eventsContainer addObject:event];
        }
        
        self.events = [NSArray arrayWithArray:eventsByMonth];
        
        __weak KDCalendarView* wself = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [wself.collectionView reloadData];
            
        });
        
    };
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
            
            [_store requestAccessToEntityType:EKEntityTypeEvent
                                   completion:^(BOOL granted, NSError *error) {
                                       
                                       if(granted) {
                                           
                                           FetchEventsBlock();
                                           
                                       }
                                       
                                       
                                   }];
        }
        else {
            FetchEventsBlock();
        }
        
    });
    
    
    
}


@end
