//
//  BKMKRTotalsCollectionViewItem.h
//  BKMKRManager
//
//  Created by Chemersky on 5/26/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BKMKRTotalsCollectionViewItem;
@class Total;

@protocol BKMKRTotalsCollectionViewItemDelegate <NSObject>
@optional
- (void)colleItemViewItemDidDoubleClick:(BKMKRTotalsCollectionViewItem *)item;
@end

@protocol BKMKRTotalsCollectionViewItemDataSource <NSObject>
- (BOOL)enabledNotifying;
@end


@interface BKMKRTotalsCollectionViewItem : NSCollectionViewItem
@property (nonatomic, weak) id<BKMKRTotalsCollectionViewItemDelegate> delegate;
@property (nonatomic, weak) id<BKMKRTotalsCollectionViewItemDataSource> dataSource;

- (void)betLCurrentCoefficientDidReceive:(float)currentCoefficient;
- (void)betMCurrentCoefficientDidReceive:(float)currentCoefficient;

- (void)stopNotice;

@end
