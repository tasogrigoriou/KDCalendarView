//
//  KDCalendarViewWeekCell.h
//  KDCalendar
//
//  Created by Anastasios Grigoriou on 4/9/17.
//  Copyright © 2017 karmadust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDCalendarViewWeekCell : UICollectionViewCell

@property (nonatomic, copy) NSDate *displayWeekDate;
@property (nonatomic, copy) NSDate *dateSelected;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) NSArray *events;

@property (nonatomic, weak) id<UICollectionViewDelegate> delegate;

@end
