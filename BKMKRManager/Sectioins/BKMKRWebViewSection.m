//
//  BKMKRWebViewSection.m
//  BKMKRManager
//
//  Created by Chemersky on 5/21/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRWebViewSection.h"
#import "BKMKRMonitorWebViewController.h"
#import "NSView+Layout.h"


@interface BKMKRWebViewSection ()
@property (nonatomic, strong) BKMKRMonitorWebViewController *monitorWebViewController;
@end

@implementation BKMKRWebViewSection

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMonitorWebView];
}

- (void)loadMonitorWebView {
    self.monitorWebViewController = [BKMKRMonitorWebViewController new];
    [self.view addSubview:self.monitorWebViewController.view layout:BKMKRLayoutAligmentFit];
}

@end
