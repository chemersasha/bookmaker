//
//  BKMKRTotalsCollectionViewItem.h
//  BKMKRManager
//
//  Created by Chemersky on 5/26/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BKMKRTotalsCollectionViewItem;

@protocol BKMKRTotalsCollectionViewItemDelegate <NSObject>
- (void)colleItemViewItemDidDoubleClick:(BKMKRTotalsCollectionViewItem *)item;
@end


@interface BKMKRTotalsCollectionViewItem : NSCollectionViewItem
@property (nonatomic, weak) id<BKMKRTotalsCollectionViewItemDelegate> delegate;

- (void)betLCurrentCoefficientDidReceive:(float)currentCoefficient;
- (void)betMCurrentCoefficientDidReceive:(float)currentCoefficient;

@end
