//
//  KDCalendarLineReusableView.m
//  KDCalendar
//
//  Created by Michael Michailidis on 05/03/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCalendarLineReusableView.h"

@implementation KDCalendarLineReusableView

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
}

@end
