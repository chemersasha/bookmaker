//
//  BKMKRSoundNotice.h
//  BKMKRManager
//
//  Created by Chemersky on 8/18/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol BKMKRSoundNoticeDataSource <NSObject>
@optional
- (float)noticeVolumeLevel;
@end


@interface BKMKRSoundNotice : NSViewController
@property (weak, nonatomic) id <BKMKRSoundNoticeDataSource> dataSource;

#pragma mark -

- (instancetype)initWithResourceName:(NSString *)resourceName;

- (void)startNotice;
- (void)stopNotice;

@end

extern NSString * const kBKMKRNoticeVolumeLevelDidChange;
extern NSString * const kBKMKRNoticeVolumeLevelUserInfoDataKey;
