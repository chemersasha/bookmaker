//
//  BKMKRPreferencesController.m
//  BKMKRManager
//
//  Created by Chemersky on 9/15/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRPreferencesController.h"
#import "BKMKRPreferencesManager.h"

static const int kBKMKRVolumeLevelScale = 100;

@interface BKMKRPreferencesController ()
@property (weak) IBOutlet NSSlider *notificationVolumeLevel;
@end

@implementation BKMKRPreferencesController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.notificationVolumeLevel.floatValue = ([[BKMKRPreferencesManager sharedInstance] notificationVolumeLevel]*kBKMKRVolumeLevelScale);
}

#pragma mark - Actions

- (IBAction)slideVolumeLevel:(NSSlider *)sender {
    [[BKMKRPreferencesManager sharedInstance] updateNotificationVolumeLevel:(sender.floatValue/kBKMKRVolumeLevelScale)];
}

@end
