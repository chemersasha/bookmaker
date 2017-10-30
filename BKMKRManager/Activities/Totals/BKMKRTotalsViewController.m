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
#import "BKMKRViewControllerAnimator.h"
#import "BKMKRTotalAnalyzer.h"
#import "BKMKRAutopilot.h"
#import "Document+notifications.h"
#import "Total+CoreDataClass.h"
#import "Event+CoreDataClass.h"


@interface BKMKRTotalsViewController () <NSCollectionViewDelegate, NSCollectionViewDataSource, BKMKRTotalsCollectionViewItemDelegate, BKMKRTotalsCollectionViewItemDataSource>
@property (nonatomic, strong) NSArray *totals;

@property (weak) IBOutlet NSCollectionView *totalsCollectionView;
@property (nonatomic, strong) BKMKRTotalsCollectionViewItem *totalsCollectionViewItem;
@property BOOL selectedItems;

@property (weak) IBOutlet NSButton *autopilotCheckbox;
@property (weak) IBOutlet NSButton *notifyCheckbox;
@property (weak) IBOutlet NSTextField *betSumTextField;

@property (strong, nonatomic) NSMutableSet *betProcesses;
@end

@implementation BKMKRTotalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.betProcesses = [NSMutableSet new];
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
    [self.document createTotal];
    self.selectedItems = NO;
    [self update];
}

- (IBAction)remove:(id)sender {
    //@TODO can not remove total when betting process on. Fix it
    NSSet<NSIndexPath *> *selectedPaths = self.totalsCollectionView.selectionIndexPaths;
    NSMutableArray *removedTotals = [NSMutableArray new];
    for (NSIndexPath *index in selectedPaths) {
        [removedTotals addObject:self.totals[index.item]];
    }
    [self.document removeTotals:removedTotals];

    self.selectedItems = NO;
    [self update];
}

- (IBAction)updateBetSumModel:(NSTextField *)sender {
    self.document.event.totalsBetSum = sender.floatValue;
}

#pragma mark - Notifications

- (void)webViewTotalsDidReceiveNotification:(NSNotification *)notification {
    if (!self.view.hidden) {
        for (int i=0; i<self.totals.count; i++) {
            Total *total = self.totals[i];
            BKMKRTotalsCollectionViewItem *item = (BKMKRTotalsCollectionViewItem *)[self.totalsCollectionView itemAtIndex:i];

            BKMKRTotalInfo totalInfo = [self.document.eventInfo totalInfoAtTotalValue:total.total];
            [item betLCurrentCoefficientDidReceive:totalInfo.lCoefficient];
            [item betMCurrentCoefficientDidReceive:totalInfo.mCoefficient];
            
            if ([BKMKRTotalAnalyzer analyzeTotal:total withCoefficient:totalInfo.mCoefficient]) {
                [self processBetTotalOver:total];
            }
        }
    }
}

- (void)processBetTotalOver:(Total *)total {
    NSNumber *totalNum = [NSNumber numberWithFloat:total.total];
    if (self.autopilotCheckbox.state == NSOnState && ![self.betProcesses containsObject:totalNum]) {
        [self.betProcesses addObject:totalNum];
        BKMKRTotalsViewController * __weak wSelf = self;
        [self.document.autopilot processBetTotalOver:total completion:^{
            //@TODO update model and UI
            [wSelf.betProcesses removeObject:totalNum];
        }];
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

#pragma mark - BKMKRTotalsCollectionViewItemDelegate

- (void)colleItemViewItemDidDoubleClick:(BKMKRTotalsCollectionViewItem *)item {
    BKMKRTotalDetailViewController *totalDetailViewController = [[BKMKRTotalDetailViewController alloc] initWithTotal:item.representedObject];
    [self presentViewController:totalDetailViewController animator:[BKMKRViewControllerAnimator new]];
}

#pragma mark - BKMKRTotalsCollectionViewItemDataSource

- (BOOL)enabledNotifying {
    return (self.notifyCheckbox.state == NSOnState) ? YES : NO;
}

@end
