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

static const float kBKMKRDefaultTotalValue = 3.5;

@interface BKMKRTotalsViewController () <NSCollectionViewDelegate, NSCollectionViewDataSource, BKMKRTotalsCollectionViewItemDelegate, BKMKRTotalsCollectionViewItemDataSource>
@property (nonatomic, strong) BKMKRDataModelManager *dataModelManager;
@property (nonatomic, strong) NSArray *totals;

@property (weak) IBOutlet NSCollectionView *totalsCollectionView;
@property (nonatomic, strong) BKMKRTotalsCollectionViewItem *totalsCollectionViewItem;
@property BOOL selectedItems;

@property (weak) IBOutlet NSButton *notifyCheckbox;
@property (weak) IBOutlet NSTextField *betSumTextField;

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

- (void)loadBetSum {
    self.betSumTextField.enabled = YES;
    self.betSumTextField.floatValue = self.document.event.totalsBetSum;
}

- (void)unloadBetSum {
    self.betSumTextField.enabled = NO;
    self.betSumTextField.stringValue = @"";
}

#pragma mark - Overloaded

- (void)eventDidLoad {
    [self update];
    [self loadBetSum];
}

- (void)eventDidUnload {
    self.totals = nil;
    [self.totalsCollectionView reloadData];
    
    [self unloadBetSum];
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
    total.total = kBKMKRDefaultTotalValue;
    
    NSMutableSet *totals = self.document.event.totals.mutableCopy;
    [totals addObject:total];
    self.document.event.totals = totals.copy;
    
    self.selectedItems = NO;
    [self update];
}

- (IBAction)remove:(id)sender {
    NSSet<NSIndexPath *> *selectedPaths = self.totalsCollectionView.selectionIndexPaths;
    NSMutableSet *totals = self.document.event.totals.mutableCopy;
    for (NSIndexPath *index in selectedPaths) {
        [totals removeObject:self.totals[index.item]];
    }
    self.document.event.totals = totals.copy;
    
    self.selectedItems = NO;
    [self update];
}

- (IBAction)updateBetSumModel:(NSTextField *)sender {
    self.document.event.totalsBetSum = sender.floatValue;
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
    item.dataSource = self;
    item.representedObject = self.totals[indexPath.item];

    return item;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    self.selectedItems = self.totalsCollectionView.selectionIndexPaths.anyObject ? YES : NO;
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    self.selectedItems = self.totalsCollectionView.selectionIndexPaths.anyObject ? YES : NO;
}

#pragma mark - BKMKRTotalsCollectionViewItemDelegate, BKMKRTotalsCollectionViewItemDataSource

- (void)colleItemViewItemDidDoubleClick:(BKMKRTotalsCollectionViewItem *)item {
    BKMKRTotalDetailViewController *totalDetailViewController = [[BKMKRTotalDetailViewController alloc] initWithTotal:item.representedObject];
    [self presentViewController:totalDetailViewController animator:[BKMKRViewControllerAnimator new]];
}

- (BOOL)enabledNotifying {
    BOOL result = ((self.notifyCheckbox.state == NSOnState) ? YES : NO);
    return result;
}

@end
