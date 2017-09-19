//
//  BKMKRPreferencesManager.m
//  BKMKRManager
//
//  Created by Chemersky on 9/18/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRPreferencesManager.h"

static NSString * const kBKMKRNotificationVolumeLevelKey = @"BKMKRNotificationVolumeLevelKey";
static const float kBKMKRDefaultNotificationVolumeLevelValue = 0.5;

@implementation BKMKRPreferencesManager

- (float)notificationVolumeLevel {
    float result;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    result = [[userDefaults objectForKey:kBKMKRNotificationVolumeLevelKey] floatValue];
	if (!result) {
        result = kBKMKRDefaultNotificationVolumeLevelValue;
        [self updateNotificationVolumeLevel:kBKMKRDefaultNotificationVolumeLevelValue];
	}
    return result;
}

- (void)updateNotificationVolumeLevel:(float)volume {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithFloat:volume] forKey:kBKMKRNotificationVolumeLevelKey];
    [userDefaults synchronize];
}

@end
