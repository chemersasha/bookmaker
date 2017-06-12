//
//  BKMKRTotalsCollectionViewItem.m
//  BKMKRManager
//
//  Created by Chemersky on 5/26/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BKMKRTotalsCollectionViewItem.h"
#import "BKMKRTotalAnalyzer.h"
#import "BKMKREventHandlerView.h"
#import "Document.h"
#import "Total+CoreDataClass.h"
#import "Event+CoreDataClass.h"

@interface BKMKRTotalsCollectionViewItem ()
@property (weak) IBOutlet NSTextField *highlightView;
@property (weak) IBOutlet NSTextField *betLCoefficientLabel;
@property (weak) IBOutlet NSTextField *betLCurrentCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMCurrentCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMWaitCoefficientLabel;
@property (weak) IBOutlet NSTextField *betMWaitLabel;

@property (weak) IBOutlet NSButton *stopSoundButton;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation BKMKRTotalsCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self updateUI];
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
    [self betLCurrentCoefficientDidReceive:totalInfo.lCoefficient];
    [self betMCurrentCoefficientDidReceive:totalInfo.mCoefficient];
}

- (void)startSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"fork" ofType: @"mp3"];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:soundPath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];
    
    self.stopSoundButton.hidden = NO;
}

#pragma mark - Actions

- (IBAction)stopSound:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    self.stopSoundButton.hidden = YES;
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
                [self startSound];
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
