//
//  BKMKREventInfoViewController.m
//  BKMKRManager
//
//  Created by Chemersky on 5/20/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BKMKREventInfoViewController.h"
#import "Document+notifications.h"

@interface BKMKREventInfoViewController ()
@property (weak) IBOutlet NSTextField *team1ScoreLabel;
@property (weak) IBOutlet NSTextField *team2ScoreLabel;
@property (weak) IBOutlet NSTextField *team1NameLabel;
@property (weak) IBOutlet NSTextField *team2NameLabel;

@property (weak) IBOutlet NSButton *stopGoalSoundButton;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation BKMKREventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)startGoalSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"goal" ofType: @"mp3"];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:soundPath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];
    
    self.stopGoalSoundButton.hidden = NO;
}

#pragma mark - Actions

- (IBAction)stopGoalSound:(id)sender {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    self.stopGoalSoundButton.hidden = YES;
}

#pragma mark - Overloaded

- (void)eventDidLoad {
    self.team1NameLabel.stringValue = self.document.event.team1Name;
    self.team2NameLabel.stringValue = self.document.event.team2Name;
}

- (void)eventDidUnload {
    self.team1NameLabel.stringValue = @"---";
    self.team2NameLabel.stringValue = @"---";
}

- (void)eventListenDidStart {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(team1ScoreDidChangeNotification:) name:self.document.webViewTeam1ScoreDidChangeNotification object:self.document];
    [defaultCenter addObserver:self selector:@selector(team2ScoreDidChangeNotification:) name:self.document.webViewTeam2ScoreDidChangeNotification object:self.document];
}

- (void)eventListenDidStop {
    self.team1ScoreLabel.stringValue = @"-";
    self.team2ScoreLabel.stringValue = @"-";
    
    [self stopGoalSound:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:self.document.webViewTeam1ScoreDidChangeNotification object:self.document];
    [defaultCenter removeObserver:self name:self.document.webViewTeam2ScoreDidChangeNotification object:self.document];
}

#pragma mark - Notifications

- (void)team1ScoreDidChangeNotification:(NSNotification *)notification {
    if (![self.team1ScoreLabel.stringValue isEqualToString:@"-"]) {
        [self startGoalSound];
    }
    self.team1ScoreLabel.stringValue = self.document.eventInfo.team1Score.stringValue;
}

- (void)team2ScoreDidChangeNotification:(NSNotification *)notification {
    if (![self.team2ScoreLabel.stringValue isEqualToString:@"-"]) {
        [self startGoalSound];
    }
    self.team2ScoreLabel.stringValue = self.document.eventInfo.team2Score.stringValue;
}

@end
