//
//  KDCalendarHeaderCollectionReusableView.m
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarHeaderCollectionReusableView.h"

@implementation KDCalendarHeaderCollectionReusableView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        // day labels
        CGFloat xpos = 0.0f;
        CGFloat lwidth = frame.size.width / 7.0f;
        CGFloat lheight = frame.size.height;
        NSArray* dayNames = @[@"SU", @"MO", @"TU", @"WE", @"TH", @"FR", @"SA"];
        
        for (int i = 0; i < 7; i++)
        {
            UILabel* dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpos, 0.0f, lwidth, lheight)];
            dayLabel.backgroundColor = [UIColor clearColor];
            dayLabel.textColor = [UIColor whiteColor];
            dayLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.text = (NSString*)dayNames[i];
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
