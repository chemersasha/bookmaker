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

+ (instancetype)sharedInstance {
    static BKMKRPreferencesManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BKMKRPreferencesManager alloc] init];
    });

     return sharedInstance;
}

#pragma mark -

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
    
    NSDictionary *userInfo = @{kBKMKRNoticeVolumeLevelUserInfoDataKey:[NSNumber numberWithFloat:volume]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kBKMKRNoticeVolumeLevelDidChange object:self userInfo:userInfo];
}

#pragma mark - BKMKRSoundNoticeDataSource

- (float)noticeVolumeLevel {
    return [self notificationVolumeLevel];
}

@end
