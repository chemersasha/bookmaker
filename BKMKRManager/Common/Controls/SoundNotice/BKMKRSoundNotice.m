//
//  BKMKRSoundNotice.m
//  BKMKRManager
//
//  Created by Chemersky on 8/18/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BKMKRSoundNotice.h"

NSString * const kBKMKRNoticeVolumeLevelDidChange = @"kBKMKRNoticeVolumeLevelDidChange";
NSString * const kBKMKRNoticeVolumeLevelUserInfoDataKey = @"kBKMKRNoticeVolumeLevelUserInfoDataKey";

@interface BKMKRSoundNotice ()
@property (strong, nonatomic) NSString *resourceName;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak) IBOutlet NSButton *stopNoticeButton;
@end

@implementation BKMKRSoundNotice

- (instancetype)initWithResourceName:(NSString *)resourceName {
    self = [super init];
    if (self) {
        self.resourceName = resourceName;
    }
    return self;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:self.resourceName ofType: @"mp3"];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:soundPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    self.player.numberOfLoops = -1;
    
    id notifier;
    if ([self.dataSource conformsToProtocol:@protocol(BKMKRSoundNoticeDataSource)] && [self.dataSource respondsToSelector:@selector(noticeVolumeLevel)]) {
        self.player.volume = [self.dataSource noticeVolumeLevel];
        notifier = self.dataSource;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeVolumeLevelDidChange:) name:kBKMKRNoticeVolumeLevelDidChange object:notifier];
    
}

#pragma mark - Actions

- (IBAction)stopNotice:(id)sender {
    [self.player stop];
    
    self.stopNoticeButton.hidden = YES;
}

#pragma mark - Public

- (void)startNotice {
    if (!self.player.playing) {
        [self.player play];
        self.stopNoticeButton.hidden = NO;
    }
}

- (void)stopNotice {
    [self stopNotice:nil];
}

#pragma mark - Notifications handler

- (void)noticeVolumeLevelDidChange:(NSNotification *)notification {
    self.player.volume = [[notification.userInfo objectForKey:kBKMKRNoticeVolumeLevelUserInfoDataKey] floatValue];
}

@end
