//
//  Document.h
//  BKMKRManager
//
//  Created by Chemersky on 4/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Event+CoreDataClass.h"
#import "Win+CoreDataClass.h"
#import "BKMKREventInfo.h"

static NSString * const kBKMKRWin0ColumnKey = @"1";
static NSString * const kBKMKRWin1ColumnKey = @"2";

@interface Document : NSPersistentDocument
@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) BKMKREventInfo *eventInfo;

- (Win *)eventWinAtColumnKey:(NSString *)key;
@end
