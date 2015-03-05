//
//  KDCalendarViewDayCell.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarViewDayCell.h"

@implementation KDCalendarViewDayCell


- (id)initWithFrame:(CGRect)frame
{
    
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // setup label
        
        UIFont* font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        CGFloat labelSideLength = MIN(frame.size.width, frame.size.height);
        
        CGRect labelFrame = CGRectZero;
        labelFrame.size = CGSizeMake(labelSideLength, labelSideLength);
        
        self.label = [[UILabel alloc] initWithFrame:labelFrame];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = font;
        self.label.backgroundColor = [UIColor clearColor];
        
        self.label.center = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
        self.label.minimumScaleFactor = 10.0f;
        self.label.adjustsFontSizeToFitWidth = YES;
        
        labelFrame = self.label.frame;
        
        // This marks the selected day with a circle
        
        _selectedMarkView = [[UIView alloc] initWithFrame:CGRectInset(labelFrame, 3.0f, 3.0f)];
        _selectedMarkView.clipsToBounds = YES;
        _selectedMarkView.layer.cornerRadius = _selectedMarkView.frame.size.width * 0.5f;
        _selectedMarkView.backgroundColor = [UIColor brownColor];
        
        [self addSubview:_selectedMarkView];
        [self addSubview:self.label];
        
        
        // This marks the day as being today
        
        
        _todayMarkView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 12.0f, 7.0f, 7.0f)];
        _todayMarkView.center = CGPointMake(self.bounds.size.width * 0.5 + 1.0f, _todayMarkView.center.y);
        _todayMarkView.backgroundColor = [UIColor redColor];
        _todayMarkView.layer.cornerRadius = _todayMarkView.frame.size.width * 0.5f;
        
        [self addSubview:_todayMarkView];
        
        self.isDaySelected = NO;;
        
        
    }
    return self;
}

#pragma mark - Accessors

// suport for later synch with iOS calendar
-(void)setHasEvent:(BOOL)hasEvent
{
    _hasEvent = hasEvent;
    if (_hasEvent)
    {
        
    }
    else
    {
        
    }
}

-(void)setIsCurrentMonth:(BOOL)isCurrentMonth
{
    _isCurrentMonth = isCurrentMonth;
    if (!_isCurrentMonth)
    {
        self.label.textColor = [UIColor lightGrayColor];
    }
    
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}

-(void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    
    if (_isToday)
    {
        _todayMarkView.hidden = NO;
    }
    else
    {
        _todayMarkView.hidden = YES;
    }
}

- (void) setIsDaySelected:(BOOL)isDaySelected
{
    
    _isDaySelected = isDaySelected;
    
    if (isDaySelected)
    {
        
        _selectedMarkView.hidden = NO;
        _todayMarkView.hidden = YES;
        
        self.label.textColor = [UIColor whiteColor];
        
        
    }
    else
    {
        self.label.textColor = [UIColor darkGrayColor];
        
        _selectedMarkView.hidden = YES;
        
        self.isToday = _isToday; // * Pass value to call setter which defines the opacity of the Today label
        
    }
    
}



-(NSString*)description
{
    return [NSString stringWithFormat:@"<KDCalendarViewDayCell %p (date:%@)>", self, self.date];
}
@end
