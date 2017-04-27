//
//  KDMonthCollectionViewFlowLayout.m
//  KDCalendar
//
//  Created by Michael Michailidis on 05/03/2015.
//  Copyright (c) 2015 karmadust. All rights reserved.
//

#import "KDCollectionViewFlowLayout.h"
#import "KDCalendarLineReusableView.h"

static NSInteger KDCalendarColumns = 7; // days in week
static CGFloat KDDecorationViewHeight = 1.0;

@interface KDCollectionViewFlowLayout ()

@end

@implementation KDCollectionViewFlowLayout

- (instancetype)initWithCollectionViewSize:(CGSize)size headerHeight:(CGFloat)height scope:(KDCalendarScope)scope
{
    if (self = [super init]) {
        
        switch (scope) {
            case KDCalendarScopeWeek: {
                self.itemSize = CGSizeMake(floor(size.width / (CGFloat)KDCalendarColumns), (size.height - height));
                break;
            }
            case KDCalendarScopeMonth: {
                self.itemSize = CGSizeMake(floor(size.width / (CGFloat)KDCalendarColumns), (size.height - height) / 6.0f);
                break;
            }
        }
        
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 0.0f;
        self.minimumInteritemSpacing = 0.0f;
        self.sectionInset = UIEdgeInsetsZero;
        
        self.headerReferenceSize = CGSizeMake(size.width, height);
        self.footerReferenceSize = CGSizeZero;
        
        [self registerClass:[KDCalendarLineReusableView class]
    forDecorationViewOfKind:NSStringFromClass([KDCalendarLineReusableView class])];
        
        
    }
    return self;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    
    NSMutableArray* layoutAttributesMutableArray = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    
   
    NSMutableArray* decorationLayoutAttributesMutableArray = @[].mutableCopy;
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in layoutAttributesMutableArray)
    {

        if(layoutAttributes.indexPath.item % KDCalendarColumns == 0)
        {
            
            
            
            UICollectionViewLayoutAttributes* decorationLayoutAttributes = [self layoutAttributesForDecorationViewOfKind:NSStringFromClass([KDCalendarLineReusableView class])
                                                                                                             atIndexPath:layoutAttributes.indexPath];
            
            
            [decorationLayoutAttributesMutableArray addObject:decorationLayoutAttributes];
        }
        
        
        
    }
    
    // Combine Arrays
    [layoutAttributesMutableArray addObjectsFromArray:decorationLayoutAttributesMutableArray];
    
    
    
    return layoutAttributesMutableArray;
}


// layout attributes for a specific decoration view
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    NSInteger rowIndex = indexPath.item / KDCalendarColumns;
    
    CGFloat bottomOfCell = self.headerReferenceSize.height + self.itemSize.height - KDDecorationViewHeight;
    
    CGFloat yPosition = (rowIndex * self.itemSize.height) + bottomOfCell;
    
    
    layoutAttributes.frame = CGRectIntegral( CGRectMake(0.0, yPosition, self.collectionView.frame.size.width, rowIndex == 2 ? KDDecorationViewHeight + 1.0 : KDDecorationViewHeight) );
 
    return layoutAttributes;
}

@end
