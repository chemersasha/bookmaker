//
//  BKMKRDataModelManager.h
//  BKMKRManager
//
//  Created by Chemersky on 5/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class Total;
@class Event;

@interface BKMKRDataModelManager : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

- (NSArray *)fetchEvents:(NSError **)error;
- (Event *)createEventWithId:(NSString *)identifier team1Name:(NSString *)teame1Name team2Name:(NSString *)teame2Name;
- (void)removeEvent:(Event *)event;

- (Total *)createTotal;

@end
