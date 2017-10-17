//
//  BKMKRDataModelManager.m
//  BKMKRManager
//
//  Created by Chemersky on 5/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRDataModelManager.h"
#import "Event+CoreDataClass.h"
#import "Total+CoreDataClass.h"

static NSString * const kBKMKREventEntityName = @"Event";
static NSString * const kBKMKRTotalEntityName = @"Total";
static const float kBKMKRDefaultTotalValue = 3.5;

@interface BKMKRDataModelManager ()
@end

@implementation BKMKRDataModelManager

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

#pragma mark - Event

- (NSArray *)fetchEvents:(NSError **)error  {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kBKMKREventEntityName];

    return [self.context executeFetchRequest:request error:error];
}

- (Event *)createEventWithId:(NSString *)identifier team1Name:(NSString *)teame1Name team2Name:(NSString *)teame2Name {
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:kBKMKREventEntityName inManagedObjectContext:self.context];
    event.eventId = identifier;
    event.team1Name = teame1Name;
    event.team2Name = teame2Name;
    
    return event;
}

- (void)removeEvent:(Event *)event {
    [self.context deleteObject:event];
}

- (Total *)createTotal {
    Total *total = [NSEntityDescription insertNewObjectForEntityForName:kBKMKRTotalEntityName inManagedObjectContext:self.context];
    total.total = kBKMKRDefaultTotalValue;
    
    return total;
}

@end
