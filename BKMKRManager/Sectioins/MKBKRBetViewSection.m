//
//  MKBKRBetViewSection.m
//  BKMKRManager
//
//  Created by Chemersky on 5/21/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "MKBKRBetViewSection.h"
#import "BKMKREventInfoViewController.h"
#import "BKMKRWinViewController.h"
#import "BKMKRTotalsViewController.h"
#import "NSView+Layout.h"

@interface MKBKRBetViewSection ()
@property (weak) IBOutlet NSView *infoContainer;
@property (nonatomic, strong) BKMKREventInfoViewController *eventInfoViewController;

@property (weak) IBOutlet NSView *winContainer;
@property (nonatomic, strong) BKMKRWinViewController *winViewController;

@property (weak) IBOutlet NSView *totalsContainer;
@property (nonatomic, strong) BKMKRTotalsViewController *totalsViewController;
@end

@implementation MKBKRBetViewSection

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadEventInfoViewController];
    [self loadWinViewController];
    [self loadTotalsViewController];
}

- (void)loadEventInfoViewController {
    self.eventInfoViewController = [BKMKREventInfoViewController new];
    [self.infoContainer addSubview:self.eventInfoViewController.view layout:BKMKRLayoutAligmentFit];
}

- (void)loadWinViewController {
    self.winViewController = [BKMKRWinViewController new];
    [self.winContainer addSubview:self.winViewController.view layout:BKMKRLayoutAligmentFit];
}

- (void)loadTotalsViewController {
    self.totalsViewController = [BKMKRTotalsViewController new];
    [self.totalsContainer addSubview:self.totalsViewController.view layout:BKMKRLayoutAligmentFit];
}

@end
