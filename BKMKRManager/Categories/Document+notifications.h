//
//  Document+notifications.h
//  BKMKRManager
//
//  Created by Chemersky on 5/23/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "Document.h"

@interface Document (notifications)
@property (nonatomic, strong, readonly) NSString *eventListenDidStartNotification;
@property (nonatomic, strong, readonly) NSString *eventListenDidStopNotification;
@property (nonatomic, strong, readonly) NSString *webViewTeam1ScoreDidChangeNotification;
@property (nonatomic, strong, readonly) NSString *webViewTeam2ScoreDidChangeNotification;
@property (nonatomic, strong, readonly) NSString *webViewTotalsDidReceiveNotification;
@property (nonatomic, strong, readonly) NSString *eventDidLoadNotification;
@property (nonatomic, strong, readonly) NSString *eventDidUnloadNotification;
@property (nonatomic, strong, readonly) NSString *userInfoDataKey;
@end
