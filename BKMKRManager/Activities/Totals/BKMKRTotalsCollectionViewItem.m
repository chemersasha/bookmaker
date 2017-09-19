//
//  BKMKRTotalsCollectionViewItem.m
//  BKMKRManager
//
//  Created by Chemersky on 5/26/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRTotalsCollectionViewItem.h"
#import "BKMKRTotalAnalyzer.h"
#import "BKMKREventHandlerView.h"
#import "BKMKRSoundNotice.h"
#import "BKMKRPreferencesManager.h"
#import "Document.h"
#import "Total+CoreDataClass.h"
#import "Event+CoreDataClass.h"
#import "NSView+Layout.h"


@interface BKMKRTotalsCollectionViewItem ()
@property (weak) IBOutlet NSTextField *highlightView;
@property (weak) IBOutlet NSTextField *betLCoefficientLabel;
@property (weak) IBOutlet NSTextField *betLCurrentCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMCurrentCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMWaitCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMWaitLabel;

@property (weak) IBOutlet NSView *noticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *noticeControl;
@end

@implementation BKMKRTotalsCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self loadNotices];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self updateUI];
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
    
    [self.noticeControl stopNotice];
}

- (void)setRepresentedObject:(Total *)representedObject {
    [super setRepresentedObject:representedObject];
    
    [self updateUI];
}

-(void)setSelected:(BOOL)flag
{
    [super setSelected:flag];
    
    self.highlightView.hidden = !flag;
}

- (void)loadNotices {
    self.noticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"fork"];
    self.noticeControl.dataSource = [BKMKRPreferencesManager sharedInstance];
    [self.noticeContainer addSubview:self.noticeControl.view layout:BKMKRLayoutAligmentFit];
}

- (void)updateUI {
    Total *total = self.representedObject;
    self.betLCoefficientLabel.stringValue = (total.betL && total.betL != 0)
                ? [NSString stringWithFormat:@"%.2f", (total.profitL/total.betL)]
                : @"-";
    self.betMCoefficientLabel.stringValue = (total.betM && total.betM != 0)
                ? [NSString stringWithFormat:@"%.2f", (total.profitM/total.betM)]
                : @"-";

    self.betMWaitCoefficientLabel.stringValue = [NSString stringWithFormat:@"%.2f", [BKMKRTotalAnalyzer betMWaitCoefficientFromTotal:total]];
    [self updateBetMWait];
    [self updateWebViewUI];
}

- (void)updateBetMWait {
    Total *total = self.representedObject;
    Document *document = self.view.window.windowController.document;
    BKMKRTotalInfo totalInfo = [document.eventInfo totalInfoAtTotal:total.total];
    self.betMWaitLabel.stringValue = [NSString stringWithFormat:@"%.2f", [BKMKRTotalAnalyzer betMWaitFromTotal:total withCoefficient:totalInfo.mCoefficient]];
}

- (void)updateWebViewUI {
    Total *total = self.representedObject;
    Document *document = self.view.window.windowController.document;
    BKMKRTotalInfo totalInfo = [document.eventInfo totalInfoAtTotal:total.total];
    self.betLCurrentCoefficientLabel.stringValue =  (totalInfo.lCoefficient)
                ? [NSString stringWithFormat:@"%.2f", totalInfo.lCoefficient]
                : @"-";
    self.betMCurrentCoefficientLabel.stringValue =  (totalInfo.mCoefficient)
                ? [NSString stringWithFormat:@"%.2f", totalInfo.mCoefficient]
                : @"-";
}

#pragma mark -

- (void)betLCurrentCoefficientDidReceive:(float)currentCoefficient {
    if (currentCoefficient) {
        if (self.betLCurrentCoefficientLabel.floatValue != currentCoefficient) {
            self.betLCurrentCoefficientLabel.stringValue = [NSString stringWithFormat:@"%.2f", currentCoefficient];
        }
    } else {
        self.betLCurrentCoefficientLabel.stringValue = @"-";
    }
}

- (void)betMCurrentCoefficientDidReceive:(float)currentCoefficient {
    if (currentCoefficient) {
        if (self.betMCurrentCoefficientLabel.floatValue != currentCoefficient) {
            [self updateBetMWait];
            self.betMCurrentCoefficientLabel.stringValue = [NSString stringWithFormat:@"%.2f", currentCoefficient];
            
            if ([BKMKRTotalAnalyzer analyzeTotal:(Total *)self.representedObject withCoefficient:currentCoefficient]) {
                [self.noticeControl startNotice];
            }
        }
    } else {
        self.betMCurrentCoefficientLabel.stringValue = @"-";
    }
}

#pragma mark - BKMKREventHandlerViewDelegate

- (void)viewDidDoubleClick:(BKMKREventHandlerView *)item {
    if([self.delegate respondsToSelector:@selector(colleItemViewItemDidDoubleClick:)]) {
        [self.delegate colleItemViewItemDidDoubleClick:self];
    }
}

@end
