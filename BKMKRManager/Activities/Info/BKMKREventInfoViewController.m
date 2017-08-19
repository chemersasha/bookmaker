//
//  BKMKREventInfoViewController.m
//  BKMKRManager
//
//  Created by Chemersky on 5/20/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKREventInfoViewController.h"
#import "BKMKRSoundNotice.h"
#import "NSView+Layout.h"
#import "Document+notifications.h"

@interface BKMKREventInfoViewController ()
@property (weak) IBOutlet NSTextField *team1ScoreLabel;
@property (weak) IBOutlet NSTextField *team2ScoreLabel;
@property (weak) IBOutlet NSTextField *team1NameLabel;
@property (weak) IBOutlet NSTextField *team2NameLabel;
@property (weak) IBOutlet NSTextField *win0Coef;
@property (weak) IBOutlet NSTextField *win1Coef;
@property (weak) IBOutlet NSTextField *winXCoef;

@property (weak) IBOutlet NSTextField *win0RingCoefTextField;
@property (weak) IBOutlet NSView *win0NoticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *win0NoticeControl;

@property (weak) IBOutlet NSTextField *win1RingCoefTextField;
@property (weak) IBOutlet NSView *win1NoticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *win1NoticeControl;

@property (weak) IBOutlet NSView *goalNoticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *goalNoticeControl;

@end

@implementation BKMKREventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWin1X2NoticeUI];
    [self loadGoalNoticeUI];
}

- (void)loadWin1X2NoticeUI {
    self.win0NoticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"fork"];
    [self.win0NoticeContainer addSubview:self.win0NoticeControl.view layout:BKMKRLayoutAligmentFit];
    self.win0RingCoefTextField.floatValue = 0.0;

    self.win1NoticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"fork"];
    [self.win1NoticeContainer addSubview:self.win0NoticeControl.view layout:BKMKRLayoutAligmentFit];
    self.win1RingCoefTextField.floatValue = 0.0;
}

- (void)loadGoalNoticeUI {
    self.goalNoticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"goal"];
    [self.goalNoticeContainer addSubview:self.win0NoticeControl.view layout:BKMKRLayoutAligmentFit];
}

#pragma mark -

- (void)clearWinsCoef {
    self.win0Coef.stringValue = @"-";
    self.winXCoef.stringValue = @"-";
    self.win1Coef.stringValue = @"-";
}

- (void)stopNotices {
    [self.win0NoticeControl stopNotice];
    [self.win1NoticeControl stopNotice];
    [self.goalNoticeControl stopNotice];
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
    
    [defaultCenter addObserver:self selector:@selector(win1X2DidReceiveNotification:) name:self.document.webViewWin1X2DidReceiveNotification object:self.document];
}

- (void)eventListenDidStop {
    self.team1ScoreLabel.stringValue = @"-";
    self.team2ScoreLabel.stringValue = @"-";
    
    [self clearWinsCoef];
    
    [self stopNotices];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:self.document.webViewTeam1ScoreDidChangeNotification object:self.document];
    [defaultCenter removeObserver:self name:self.document.webViewTeam2ScoreDidChangeNotification object:self.document];
    [defaultCenter removeObserver:self name:self.document.webViewWin1X2DidReceiveNotification object:self.document];
}

#pragma mark - Notifications

- (void)team1ScoreDidChangeNotification:(NSNotification *)notification {
    if (![self.team1ScoreLabel.stringValue isEqualToString:@"-"]) {
        [self.goalNoticeControl startNotice];
    }
    self.team1ScoreLabel.stringValue = self.document.eventInfo.team1Score.stringValue;
}

- (void)team2ScoreDidChangeNotification:(NSNotification *)notification {
    if (![self.team2ScoreLabel.stringValue isEqualToString:@"-"]) {
        [self.goalNoticeControl startNotice];
    }
    self.team2ScoreLabel.stringValue = self.document.eventInfo.team2Score.stringValue;
}

- (void)win1X2DidReceiveNotification:(NSNotification *)notification {
    if (self.document.eventInfo.win1X2.count == 3) {
        self.win0Coef.stringValue = self.document.eventInfo.win1X2[0];
        self.winXCoef.stringValue = self.document.eventInfo.win1X2[1];
        self.win1Coef.stringValue = self.document.eventInfo.win1X2[2];
    } else {
        [self clearWinsCoef];
    }
}

@end
