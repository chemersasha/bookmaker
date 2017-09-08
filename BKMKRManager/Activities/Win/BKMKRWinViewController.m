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
#import "Win+CoreDataClass.h"
#import "NSView+Layout.h"
#import "Document+notifications.h"

@interface BKMKRWinViewController () <BKMKRStepperTextFieldDelegate>
@property (weak) IBOutlet NSTextField *win0Coef;
@property (weak) IBOutlet NSTextField *win1Coef;

@property (strong, nonatomic) Win *win0;
@property (strong, nonatomic) BKMKRStepperTextField *win0RingCoefTextField;
@property (weak) IBOutlet NSView *win0RingContainer;
@property (weak) IBOutlet NSView *win0NoticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *win0NoticeControl;
@property (weak) IBOutlet NSTextField *win0BetTextField;
@property (weak) IBOutlet NSTextField *win0ProfitTextField;

@property (strong, nonatomic) Win *win1;
@property (strong, nonatomic) BKMKRStepperTextField *win1RingCoefTextField;
@property (weak) IBOutlet NSView *win1RingContainer;
@property (weak) IBOutlet NSView *win1NoticeContainer;
@property (strong, nonatomic) BKMKRSoundNotice *win1NoticeControl;
@property (weak) IBOutlet NSTextField *win1BetTextField;
@property (weak) IBOutlet NSTextField *win1ProfitTextField;

@end

@implementation BKMKRWinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadWinModel {
    self.win0 = [self.document eventWinAtColumnKey:kBKMKRWin0ColumnKey];
    self.win1 = [self.document eventWinAtColumnKey:kBKMKRWin1ColumnKey];
}

- (void)loadWin1X2UI {
    [self loadWin0UI];
    [self loadWin1UI];
}

- (void)loadWin0UI {
    if(self.win0) {
        self.win0NoticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"fork"];
        [self.win0NoticeContainer addSubview:self.win0NoticeControl.view layout:BKMKRLayoutAligmentFit];
        
        self.win0RingCoefTextField = [[BKMKRStepperTextField alloc] initWithDelegate:self];
        [self.win0RingContainer addSubview:self.win0RingCoefTextField.view layout:BKMKRLayoutAligmentFit];
        self.win0RingCoefTextField.textField.floatValue = (self.win0) ? self.win0.profitCoef : 100.0;
        
        self.win0BetTextField.floatValue = self.win0.bet;
        self.win0ProfitTextField.floatValue = self.win0.profit;
    }
}

- (void)loadWin1UI {
    if(self.win1) {
        self.win1NoticeControl = [[BKMKRSoundNotice alloc] initWithResourceName:@"fork"];
        [self.win1NoticeContainer addSubview:self.win1NoticeControl.view layout:BKMKRLayoutAligmentFit];

        self.win1RingCoefTextField = [[BKMKRStepperTextField alloc] initWithDelegate:self];
        [self.win1RingContainer addSubview:self.win1RingCoefTextField.view layout:BKMKRLayoutAligmentFit];
        self.win1RingCoefTextField.textField.floatValue = (self.win1) ? self.win1.profitCoef : 100.0;
        
        self.win1BetTextField.floatValue = self.win1.bet;
        self.win1ProfitTextField.floatValue = self.win1.profit;
    }
}

#pragma mark -

- (void)unloadWinModel {
    self.win0 = nil;
    self.win1 = nil;
}

- (void)unloadWin1X2UI {
    [self unloadWin0UI];
    [self unloadWin1UI];
}

- (void)unloadWin0UI {
    [self.win0RingCoefTextField.view removeFromSuperview];
    self.win0RingCoefTextField = nil;
}

- (void)unloadWin1UI {
    [self.win1RingCoefTextField.view removeFromSuperview];
    self.win1RingCoefTextField = nil;
}

#pragma mark - Overloaded

- (void)eventDidLoad {
    [self loadWinModel];
    [self loadWin1X2UI];
}

- (void)eventDidUnload {
    [self unloadWinModel];
    [self unloadWin1X2UI];
}

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

#pragma mark -

- (void)clearWinsCoef {
    self.win0Coef.stringValue = @"-";
    self.win1Coef.stringValue = @"-";
}

- (void)stopNotices {
    [self.win0NoticeControl stopNotice];
    [self.win1NoticeControl stopNotice];
}

- (Win *)addWinAtColumnKey:(NSString *)columnKey {
    Win *win = [NSEntityDescription insertNewObjectForEntityForName:@"Win" inManagedObjectContext:[self.document managedObjectContext]];
    win.column = columnKey;
    win.bet = 0.0;
    win.profit = 0.0;
    win.profitCoef = 100.0;
    
    NSMutableSet *wins = self.document.event.wins.mutableCopy;
    [wins addObject:win];
    self.document.event.wins = wins.copy;
    
    return win;
}

- (void)removeWin:(Win *)win {
    NSMutableSet *wins = self.document.event.wins.mutableCopy;
    [wins removeObject:win];
    self.document.event.wins = wins.copy;
}

#pragma mark - Actions

- (IBAction)addWin0:(id)sender {
    self.win0 = [self addWinAtColumnKey:kBKMKRWin0ColumnKey];
    [self loadWin0UI];
}

- (IBAction)removeWin0:(id)sender {
    [self removeWin:self.win0];
    self.win0 = nil;
    [self unloadWin0UI];
}

- (IBAction)win0BetValueDidChange:(NSTextField *)sender {
    self.win0.bet = sender.floatValue;
}

- (IBAction)win0ProfitValueDidChange:(NSTextField *)sender {
    self.win0.profit = sender.floatValue;
}

- (IBAction)addWin1:(id)sender {
    self.win1 = [self addWinAtColumnKey:kBKMKRWin1ColumnKey];
    [self loadWin1UI];
}

- (IBAction)removeWin1:(id)sender {
    [self removeWin:self.win1];
    self.win1 = nil;
    [self unloadWin1UI];
}

- (IBAction)win1BetValueDidChange:(NSTextField *)sender {
    self.win1.bet = sender.floatValue;
}

- (IBAction)win1ProfitValueDidChange:(NSTextField *)sender {
    self.win1.profit = sender.floatValue;
}

#pragma mark - Stepper text field delegate

- (void)stepperTextFieldValueDidChange:(BKMKRStepperTextField *)stepperTextField {
    if (stepperTextField == self.win0RingCoefTextField) {
        self.win0.profitCoef = stepperTextField.textField.floatValue;
    } else if (stepperTextField == self.win1RingCoefTextField) {
        self.win1.profitCoef = stepperTextField.textField.floatValue;
    }
}

#pragma mark - Notifications

- (void)win1X2DidReceiveNotification:(NSNotification *)notification {
    if (self.document.eventInfo.win1X2.count == 3) {
        self.win0Coef.stringValue = self.document.eventInfo.win1X2[0];
        if ([BKMKRTotalAnalyzer analyzeWin:self.win0Coef.floatValue withCoefficient:self.win0RingCoefTextField.textField.floatValue]) {
            [self.win0NoticeControl startNotice];
        }
        self.win1Coef.stringValue = self.document.eventInfo.win1X2[2];
        if ([BKMKRTotalAnalyzer analyzeWin:self.win1Coef.floatValue withCoefficient:self.win1RingCoefTextField.textField.floatValue]) {
            [self.win1NoticeControl startNotice];
        }

    } else {
        [self clearWinsCoef];
    }
}

@end
