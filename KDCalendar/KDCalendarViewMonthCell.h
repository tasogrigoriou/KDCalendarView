//
//  KDCalendarViewMonthCell.h
//  KDCalendar
//
//  Created by Michael Michailidis on 14/02/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDCalendarViewMonthCell : UICollectionViewCell

@property (nonatomic, copy) NSDate* displayMonthDate;
@property (nonatomic, copy) NSDate* dateSelected;
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, weak) id<UICollectionViewDelegate> delegate;

@end
