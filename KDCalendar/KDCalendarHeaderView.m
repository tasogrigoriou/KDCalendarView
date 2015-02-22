//
//  KDCalendarHeaderCollectionReusableView.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarHeaderView.h"

@implementation KDCalendarHeaderView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        // Day labels
        CGFloat xpos = 0.0f;
        CGFloat lwidth = frame.size.width / 7.0f;
        CGFloat lheight = frame.size.height;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        for (NSString* weekday in dateFormatter.weekdaySymbols)
        {
            
            UILabel* dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpos, 0.0f, lwidth, lheight)];
            dayLabel.backgroundColor = [UIColor clearColor];
            dayLabel.textColor = [UIColor whiteColor];
            dayLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.text = [weekday substringToIndex:2].uppercaseString;
            [self addSubview:dayLabel];
            
            xpos += lwidth;
            
        }
        
        
    }
    return self;
}



+ (CGFloat) height
{
    return 30.0f; // override
}

@end
