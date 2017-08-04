//
//  Document+notifications.m
//  BKMKRManager
//
//  Created by Chemersky on 5/23/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "Document+notifications.h"

static NSString * const kBKMKRWebViewTeam1ScoreDidChangeNotification = @"kBKMKRWebViewTeam1ScoreDidChangeNotification";
static NSString * const kBKMKRWebViewTeam2ScoreDidChangeNotification = @"kBKMKRWebViewTeam2ScoreDidChangeNotification";
static NSString * const kBKMKRWebViewTotalsDidReceiveNotification = @"kBKMKRWebViewTotalsDidReceiveNotification";
static NSString * const kBKMKRWebViewWin1X2DidReceiveNotification = @"kBKMKRWebViewWin1X2DidReceiveNotification";
static NSString * const kBKMKREventListenDidStartNotification = @"kBKMKREventListenDidStartNotification";
static NSString * const kBKMKREventListenDidStopNotificationNotification = @"kBKMKREventListenDidStopNotificationNotification";
static NSString * const kBKMKREventDidLoadNotification = @"kBKMKREventDidLoadNotification";
static NSString * const kBKMKREventDidUnloadNotification = @"kBKMKREventDidUnloadNotification";
static NSString * const kBKMKRUserInfoDataKey = @"kBKMKRUserInfoDataKey";


@implementation Document (notifications)

- (NSString *)webViewTeam1ScoreDidChangeNotification {
    return kBKMKRWebViewTeam1ScoreDidChangeNotification;
}

- (NSString *)webViewTeam2ScoreDidChangeNotification {
    return kBKMKRWebViewTeam2ScoreDidChangeNotification;
}

- (NSString *)webViewTotalsDidReceiveNotification {
    return kBKMKRWebViewTotalsDidReceiveNotification;
}

- (NSString *)webViewWin1X2DidReceiveNotification {
    return kBKMKRWebViewWin1X2DidReceiveNotification;
}

- (NSString *)eventDidLoadNotification {
    return kBKMKREventDidLoadNotification;
}

- (NSString *)eventDidUnloadNotification {
    return kBKMKREventDidUnloadNotification;
}

- (NSString *)eventListenDidStartNotification {
    return kBKMKREventListenDidStartNotification;
}

- (NSString *)eventListenDidStopNotification {
    return kBKMKREventListenDidStopNotificationNotification;
}

- (NSString *)userInfoDataKey {
    return kBKMKRUserInfoDataKey;
}

@end
