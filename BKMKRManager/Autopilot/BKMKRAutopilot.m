//
//  BKMKRAutopilot.m
//  BKMKRManager
//
//  Created by Chemersky on 10/16/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "BKMKRAutopilot.h"

@interface BKMKRAutopilot ()
@property (nonatomic, strong) WebView *webview;
@end

@implementation BKMKRAutopilot

- (instancetype)initWithWebView:(WebView *)webview;
{
    self = [super init];
    if (self) {
        self.webview = webview;
    }
    return self;
}

#pragma mark -

- (void)processBetTotalOver:(Total *)total {
    
}

@end
