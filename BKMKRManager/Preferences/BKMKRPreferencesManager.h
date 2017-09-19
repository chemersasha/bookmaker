//
//  BKMKRPreferencesManager.h
//  BKMKRManager
//
//  Created by Chemersky on 9/18/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKMKRSoundNotice.h"

@interface BKMKRPreferencesManager : NSObject <BKMKRSoundNoticeDataSource>
+ (instancetype)sharedInstance;

- (float)notificationVolumeLevel;
- (void)updateNotificationVolumeLevel:(float)volume;
@end
