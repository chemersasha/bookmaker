//
//  BKMKRPreferencesManager.h
//  BKMKRManager
//
//  Created by Chemersky on 9/18/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKMKRPreferencesManager : NSObject
- (float)notificationVolumeLevel;
- (void)updateNotificationVolumeLevel:(float)volume;
@end
