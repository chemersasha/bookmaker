//
//  BKMKRSoundNotice.m
//  BKMKRManager
//
//  Created by Chemersky on 8/18/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BKMKRSoundNotice.h"

@interface BKMKRSoundNotice ()
@property (nonatomic, strong) NSString *resourceName;
@property (nonatomic, strong) AVAudioPlayer *player;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:self.resourceName ofType: @"mp3"];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:soundPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    self.player.numberOfLoops = -1;
}

#pragma mark - Actions

- (IBAction)stopNotice:(id)sender {
    [self.player stop];
    
    self.stopNoticeButton.hidden = YES;
}

#pragma mark - Public

- (void)startNotice {
    [self.player play];
    self.stopNoticeButton.hidden = NO;
}

- (void)stopNotice {
    [self stopNotice:nil];
}

@end
