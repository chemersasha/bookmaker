//
//  Document.m
//  BKMKRManager
//
//  Created by Chemersky on 4/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "Document.h"
#import "BKMKRDataModelManager.h"
#import "Event+CoreDataClass.h"
#import "Total+CoreDataClass.h"
#import "Win+CoreDataClass.h"
#import "BKMKRAutopilot.h"

@interface Document ()
@property (nonatomic, strong) BKMKRDataModelManager *dataModelManager;
@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel
{
    if (self.event) {
        [savePanel setNameFieldStringValue:[NSString stringWithFormat:@"%@ - %@", self.event.team1Name, self.event.team2Name]];
    }
    return [super prepareSavePanel:savePanel];
}

#pragma mark -

- (void)loadEvent {
    NSError *error = nil;
    NSArray *events = [self.dataModelManager fetchEvents:&error];
    if (!error && events.count>0) {
        self.event = events[0];
    }
}

- (Event *)createEventWithId:(NSString *)identifier team1Name:(NSString *)teame1Name team2Name:(NSString *)teame2Name {
    self.event = [self.dataModelManager createEventWithId:identifier team1Name:teame1Name team2Name:teame2Name];
    return self.event;
}

- (void)removeEvent {
    [self.dataModelManager removeEvent:self.event];
    self.event = nil;
}

- (Total *)createTotal {
    Total *total = [self.dataModelManager createTotal];
    
    NSMutableSet *totals = self.event.totals.mutableCopy;
    [totals addObject:total];
    self.event.totals = totals.copy;
    
    return total;
}

- (void)removeTotals:(NSArray *)totals {
    NSMutableSet *eventTotals = self.event.totals.mutableCopy;
    for (Total *total in totals) {
        [eventTotals removeObject:total];
    }
    self.event.totals = eventTotals.copy;
}

- (Win *)eventWinAtColumnKey:(NSString *)key {
    Win *result = nil;
    NSArray *wins = [self.event.wins allObjects];
    for (Win *win in wins) {
        if ([win.column isEqualToString:key]) {
            result = win;
            break;
        }
    }
    return result;
}

#pragma mark - Getters

- (BKMKRDataModelManager *)dataModelManager {
    if(!_dataModelManager) {
        _dataModelManager = [[BKMKRDataModelManager alloc]
            initWithContext:[self managedObjectContext]
        ];
    }
    return _dataModelManager;
}

@end
