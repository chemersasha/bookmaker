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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];

    return [self.context executeFetchRequest:request error:error];
}

- (void)removeEvent:(Event *)event {
    [self.context deleteObject:event];
}

#pragma mark - Total

- (void)addTotalWithEventId:(NSString *)eventId error:(NSError **)error {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", eventId]];
    
    NSArray *fetchResults = [self.context executeFetchRequest:request error:error];
    for (id event in fetchResults) {
        Total *total = [NSEntityDescription insertNewObjectForEntityForName:@"Total" inManagedObjectContext:self.context];
        total.event = event;
    }
}

@end
