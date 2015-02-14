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
        
        _todayLabel = [[UILabel alloc] initWithFrame:CGRectZero]; // set through size that fits as it is static text
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        _todayLabel.font = font;
        _todayLabel.backgroundColor = [UIColor clearColor];
        _todayLabel.textColor = [UIColor brownColor];
        
        _todayLabel.text = NSLocalizedString(@"Today", nil);
        [_todayLabel sizeToFit];
        
        _todayLabel.center = CGPointMake(self.label.center.x, self.label.center.y + labelFrame.size.height * 0.5 - 6.0f);
        
        
        _todayLabel.hidden = YES;
        
        
        _circleMarkView = [[UIView alloc] initWithFrame:CGRectInset(labelFrame, 3.0f, 3.0f)];
        _circleMarkView.clipsToBounds = YES;
        _circleMarkView.layer.cornerRadius = _circleMarkView.frame.size.width * 0.5f;
        _circleMarkView.backgroundColor = [UIColor brownColor];
        
        [self addSubview:_circleMarkView];
        [self addSubview:self.label];
        [self addSubview:_todayLabel];
        
        self.isDaySelected = NO;
        
        UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 1.0f, frame.size.width, 1.0f)];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:separatorView];
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
        _todayLabel.hidden = NO;
    }
    else
    {
        _todayLabel.hidden = YES;
    }
}

- (void) setIsDaySelected:(BOOL)isDaySelected
{
    
    _isDaySelected = isDaySelected;
    
    if (isDaySelected)
    {
        
        _circleMarkView.hidden = NO;
        _todayLabel.hidden = YES;
        
        self.label.textColor = [UIColor whiteColor];
        
        
    }
    else
    {
        self.label.textColor = [UIColor darkGrayColor];
        
        _circleMarkView.hidden = YES;
        
        self.isToday = _isToday; // * Pass value to call setter which defines the opacity of the Today label
        
    }
    
}



-(NSString*)description
{
    return [NSString stringWithFormat:@"<KDCalendarViewDayCell %p (date:%@)>", self, self.date];
}
@end
