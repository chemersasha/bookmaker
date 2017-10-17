//
//  Document.h
//  BKMKRManager
//
//  Created by Chemersky on 4/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BKMKREventInfo.h"

@class Event;
@class Total;
@class Win;
@class BKMKRAutopilot;

static NSString * const kBKMKRWin0ColumnKey = @"1";
static NSString * const kBKMKRWin1ColumnKey = @"2";

@interface Document : NSPersistentDocument
@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) BKMKREventInfo *eventInfo;
@property (nonatomic, strong) BKMKRAutopilot *autopilot;

- (void)loadEvent;
- (Event *)createEventWithId:(NSString *)identifier team1Name:(NSString *)teame1Name team2Name:(NSString *)teame2Name;
- (void)removeEvent;

- (Total *)createTotal;
- (void)removeTotals:(NSArray *)totals;

- (Win *)eventWinAtColumnKey:(NSString *)key;

@end
