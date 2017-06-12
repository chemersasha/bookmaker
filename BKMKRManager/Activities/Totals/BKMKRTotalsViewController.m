//
//  BKMKRTotalsViewController.m
//  BKMKRManager
//
//  Created by Chemersky on 5/24/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRTotalsViewController.h"
#import "BKMKRTotalsCollectionViewItem.h"
#import "BKMKRTotalDetailViewController.h"
#import "BKMKRDataModelManager.h"
#import "BKMKRViewControllerAnimator.h"
#import "Document+notifications.h"
#import "Total+CoreDataClass.h"

@interface BKMKRTotalsViewController () <NSCollectionViewDelegate, NSCollectionViewDataSource, BKMKRTotalsCollectionViewItemDelegate>
@property (nonatomic, strong) BKMKRDataModelManager *dataModelManager;
@property (nonatomic, strong) NSArray *totals;
@property (weak) IBOutlet NSCollectionView *totalsCollectionView;
@property (nonatomic, strong) BKMKRTotalsCollectionViewItem *totalsCollectionViewItem;
@end

@implementation BKMKRTotalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)update {
    self.totals = [[self.document.event.totals allObjects] sortedArrayUsingDescriptors:@[
        [NSSortDescriptor sortDescriptorWithKey:@"total" ascending:NO]
    ]];
    [self.totalsCollectionView reloadData];
}

#pragma mark - Overloaded

- (void)eventDidLoad {
    [self update];
}

- (void)eventDidUnload {
    self.totals = nil;
    [self.totalsCollectionView reloadData];
}

- (void)eventListenDidStart {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewTotalsDidReceiveNotification:) name:self.document.webViewTotalsDidReceiveNotification object:self.document];
}

- (void)eventListenDidStop {
    [self webViewTotalsDidReceiveNotification:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.document.webViewTotalsDidReceiveNotification object:self.document];
}

#pragma mark - Actions

- (IBAction)add:(id)sender {
    Total *total = [NSEntityDescription insertNewObjectForEntityForName:@"Total" inManagedObjectContext:self.dataModelManager.context];
    
    NSMutableSet *totals = self.document.event.totals.mutableCopy;
    [totals addObject:total];
    self.document.event.totals = totals.copy;
    
    [self update];
}

- (IBAction)remove:(id)sender {
    NSSet<NSIndexPath *> *selectedPaths = self.totalsCollectionView.selectionIndexPaths;
    NSMutableSet *totals = self.document.event.totals.mutableCopy;
    for (NSIndexPath *index in selectedPaths) {
        [totals removeObject:self.totals[index.item]];
    }
    self.document.event.totals = totals.copy;
    
    [self update];
}

#pragma mark - Getters

- (BKMKRDataModelManager *)dataModelManager {
    if(!_dataModelManager) {
        _dataModelManager = [[BKMKRDataModelManager alloc]
            initWithContext:[self.document managedObjectContext]
        ];
    }
    return _dataModelManager;
}

#pragma mark - Notifications

- (void)webViewTotalsDidReceiveNotification:(NSNotification *)notification {
    for (int i=0; i<self.totals.count; i++) {
        Total *total = self.totals[i];
        BKMKRTotalsCollectionViewItem *item = (BKMKRTotalsCollectionViewItem *)[self.totalsCollectionView itemAtIndex:i];

        BKMKRTotalInfo totalInfo = [self.document.eventInfo totalInfoAtTotal:total.total];
        [item betLCurrentCoefficientDidReceive:totalInfo.lCoefficient];
        [item betMCurrentCoefficientDidReceive:totalInfo.mCoefficient];
    }
}

#pragma mark - NSCollectionViewDelegate, NSCollectionViewDataSource

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totals.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    BKMKRTotalsCollectionViewItem *item = [self.totalsCollectionView makeItemWithIdentifier:@"BKMKRTotalsCollectionViewItem" forIndexPath:indexPath];
    item.delegate = self;
    item.representedObject = self.totals[indexPath.item];

    return item;
}

#pragma mark - BKMKRTotalsCollectionViewItemDelegate

- (void)colleItemViewItemDidDoubleClick:(BKMKRTotalsCollectionViewItem *)item {
    BKMKRTotalDetailViewController *totalDetailViewController = [[BKMKRTotalDetailViewController alloc] initWithTotal:item.representedObject];
    [self presentViewController:totalDetailViewController animator:[BKMKRViewControllerAnimator new]];
}

@end
