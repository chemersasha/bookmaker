//
//  AppDelegate.m
//  BKMKRManager
//
//  Created by Chemersky on 4/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "AppDelegate.h"
#import "BKMKRPreferencesController.h"

@interface AppDelegate ()
@property (strong, nonatomic) BKMKRPreferencesController *preferencesController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - Menu actions

- (IBAction)openPreferences:(id)sender {
    self.preferencesController = [[BKMKRPreferencesController alloc] initWithWindowNibName:@"BKMKRPreferencesController"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesWindowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:self.preferencesController.window];
    [self.preferencesController showWindow:nil];
}

#pragma mark - Notification handler

- (void)preferencesWindowWillClose:(NSNotification *)notification {
    self.preferencesController = nil;
}

@end
