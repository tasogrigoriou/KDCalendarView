//
//  KDCalendarViewController.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarViewController.h"
#import "KDCalendarViewDayCell.h"

@interface KDCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSCalendar *_calendar;
}

@property (nonatomic, readonly) KDCalendarViewMonthCell* currentMonthCell;
@property (nonatomic, readonly) NSInteger monthIndex;
@property (nonatomic, strong) UICollectionView* collectionView;

@end

@implementation KDCalendarViewController

-(id)init
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
    
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    // Create Collection View and add it to the View
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:flowLayout];
    
    self.collectionView.pagingEnabled = YES;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[KDCalendarViewMonthCell class]
            forCellWithReuseIdentifier:NSStringFromClass([KDCalendarViewMonthCell class])];
    
    
    [self.view addSubview:self.collectionView];
}


-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = self.view.frame.size;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    
    self.collectionView.collectionViewLayout = flowLayout;
    
    
    self.collectionView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12; // * Default, a year...
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KDCalendarViewMonthCell *monthCell = (KDCalendarViewMonthCell*)[collectionView dequeueReusableCellWithReuseIdentifier: NSStringFromClass([KDCalendarViewMonthCell class])
                                                                                                               forIndexPath: indexPath];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // offset by a month
    offsetComponents.month = indexPath.item;
    
    monthCell.displayMonthDate = [_calendar dateByAddingComponents:offsetComponents
                                                            toDate:[NSDate date]
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
    
    
    _dateSelected = dateSelected;
    
    
    NSDateComponents* components;
    
    // how many months distance does today which is the first cell have with the selected date?
    components = [_calendar components:NSCalendarUnitMonth
                              fromDate:[NSDate date]
                                toDate:dateSelected
                               options:0];
    
    
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width * components.month, 0.0f)
                                 animated:animated];
    
    
    KDCalendarViewMonthCell* monthCell = [self monthCellForMonthIndex:components.month];
    
    monthCell.dateSelected = _dateSelected;
    
    
}

- (void) setDateSelected:(NSDate *)dateSelected
{
    
    [self setDateSelected:dateSelected animated:NO];
}

-(KDCalendarViewMonthCell*)monthCellForMonthIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return (KDCalendarViewMonthCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
}

-(NSInteger)monthIndex
{
    return (NSInteger)(self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
}

- (NSDate*)monthDisplayed
{
    
    if(CGRectIsEmpty(self.collectionView.frame))
    {
        return nil;
    }
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // offset by a month
    offsetComponents.month = self.monthIndex;
    
    return [_calendar dateByAddingComponents:offsetComponents
                                      toDate:[NSDate date]
                                     options:0];
}

-(KDCalendarViewMonthCell*)currentMonthCell
{
    CGFloat monthCellWidth = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize.width;
    CGFloat pageNumberRoundedDown = floor( self.collectionView.contentOffset.x / monthCellWidth );
    
    return (KDCalendarViewMonthCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pageNumberRoundedDown inSection:0]];
    
}

@end
