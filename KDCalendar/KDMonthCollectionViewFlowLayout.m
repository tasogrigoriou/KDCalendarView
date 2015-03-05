//
//  KDMonthCollectionViewFlowLayout.m
//  KDCalendar
//
//  Created by Michael Michailidis on 05/03/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDMonthCollectionViewFlowLayout.h"

@implementation KDMonthCollectionViewFlowLayout

- (instancetype) initWithCollectionViewSize:(CGSize)size andHeaderHeight:(CGFloat)height
{
    if (self = [super init]) {
        
        self.itemSize = CGSizeMake(floor(size.width / 7.0), (size.height - height) / 6.0f);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 0.0f;
        self.minimumInteritemSpacing = 0.0f;
        self.sectionInset = UIEdgeInsetsZero;
        
        self.headerReferenceSize = CGSizeMake(size.width, height);
        self.footerReferenceSize = CGSizeZero;
    }
    return self;
}

@end
