//
//  KDMonthCollectionViewFlowLayout.h
//  KDCalendar
//
//  Created by Michael Michailidis on 05/03/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCalendarView.h"

@interface KDCollectionViewFlowLayout : UICollectionViewFlowLayout

- (instancetype)initWithCollectionViewSize:(CGSize)size headerHeight:(CGFloat)height scope:(KDCalendarScope)scope;

@end
