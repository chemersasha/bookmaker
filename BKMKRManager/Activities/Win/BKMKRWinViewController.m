//
//  BKMKRWinViewController.m
//  BKMKRManager
//
//  Created by Chemersky on 8/21/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRWinViewController.h"
#import "BKMKRTotalAnalyzer.h"
#import "BKMKRSoundNotice.h"
#import "BKMKRStepperTextField.h"
#import "NSView+Layout.h"
#import "Document+notifications.h"


@interface BKMKRWinViewController ()
@property (weak) IBOutlet NSTextField *win0Coef;
@property (weak) IBOutlet NSTextField *win1Coef;

@property (strong, nonatomic) BKMKRStepperTextField *win0RingCoefTextField;
@property (weak) IBOutlet NSView *win0RingContainer;

@property (weak) IBOutlet NSView *win0NoticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *win0NoticeControl;

@property (weak) IBOutlet NSTextField *win1RingCoefTextField;
@property (weak) IBOutlet NSView *win1NoticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *win1NoticeControl;

@end

@implementation BKMKRWinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWin1X2NoticeUI];
    [self loadRingFields];
}

- (void)loadWin1X2NoticeUI {
    self.win0NoticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"fork"];
    [self.win0NoticeContainer addSubview:self.win0NoticeControl.view layout:BKMKRLayoutAligmentFit];
    
    self.win1NoticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"fork"];
    [self.win1NoticeContainer addSubview:self.win1NoticeControl.view layout:BKMKRLayoutAligmentFit];
    self.win1RingCoefTextField.floatValue = 100.0;
}

- (void)loadRingFields {
    self.win0RingCoefTextField = [BKMKRStepperTextField new];
    self.win0RingCoefTextField.textField.floatValue = 100.0;
    [self.win0RingContainer addSubview:self.win0RingCoefTextField.view layout:BKMKRLayoutAligmentFit];
}

#pragma mark -

- (void)clearWinsCoef {
    self.win0Coef.stringValue = @"-";
    self.win1Coef.stringValue = @"-";
}

- (void)stopNotices {
    [self.win0NoticeControl stopNotice];
    [self.win1NoticeControl stopNotice];
}

#pragma mark - Overloaded

- (void)eventListenDidStart {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(win1X2DidReceiveNotification:) name:self.document.webViewWin1X2DidReceiveNotification object:self.document];
}

- (void)eventListenDidStop {
    [self clearWinsCoef];
    [self stopNotices];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:self.document.webViewWin1X2DidReceiveNotification object:self.document];
}

#pragma mark - Notifications

- (void)win1X2DidReceiveNotification:(NSNotification *)notification {
    if (self.document.eventInfo.win1X2.count == 3) {
        self.win0Coef.stringValue = self.document.eventInfo.win1X2[0];
        if ([BKMKRTotalAnalyzer analyzeWin:self.win0Coef.floatValue withCoefficient:self.win0RingCoefTextField.textField.floatValue]) {
            [self.win0NoticeControl startNotice];
        }
        self.win1Coef.stringValue = self.document.eventInfo.win1X2[2];
        if ([BKMKRTotalAnalyzer analyzeWin:self.win1Coef.floatValue withCoefficient:self.win1RingCoefTextField.floatValue]) {
            [self.win1NoticeControl startNotice];
        }

    } else {
        [self clearWinsCoef];
    }
}

@end
