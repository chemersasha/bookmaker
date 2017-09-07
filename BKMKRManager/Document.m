//
//  Document.m
//  BKMKRManager
//
//  Created by Chemersky on 4/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "Document.h"

@interface Document ()
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

@end
