//
//  BKMKRViewController.m
//  BKMKRManager
//
//  Created by Chemersky on 6/1/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRViewController.h"
#import "Document+notifications.h"

@interface BKMKRViewController ()
@end

@implementation BKMKRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    self.document = self.view.window.windowController.document;
    
    if (self.document.event) {
        [self eventDidLoad];
        [defaultCenter addObserver:self
                          selector:@selector(eventDidUnloadNotification:)
                              name:self.document.eventDidUnloadNotification
                            object:self.document];
    } else {
        [self eventDidUnload];
        [defaultCenter addObserver:self
                          selector:@selector(eventDidLoadNotification:)
                              name:self.document.eventDidLoadNotification
                            object:self.document];
    }

    if (self.document.eventInfo) {
        [defaultCenter addObserver:self
                          selector:@selector(eventListenDidStopNotification:)
                              name:self.document.eventListenDidStopNotification
                            object:self.document];
    } else {
        [defaultCenter addObserver:self
                          selector:@selector(eventListenDidStartNotification:)
                              name:self.document.eventListenDidStartNotification
                            object:self.document];
    }
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    if (self.document.event) {
        [defaultCenter removeObserver:self name:self.document.eventDidUnloadNotification object:self.document];
    } else {
        [defaultCenter removeObserver:self name:self.document.eventDidLoadNotification object:self.document];
    }

    if (self.document.eventInfo) {
        [defaultCenter removeObserver:self name:self.document.eventListenDidStopNotification object:self.document];
    } else {
        [defaultCenter removeObserver:self name:self.document.eventListenDidStartNotification object:self.document];
    }
}

#pragma mark - To overload

- (void)eventDidLoad {}
- (void)eventDidUnload {}
- (void)eventListenDidStop {}
- (void)eventListenDidStart {}

#pragma mark - Notifications handler

- (void)eventDidLoadNotification:(NSNotification *)notification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:self.document.eventDidLoadNotification object:self.document];
    [self eventDidLoad];
    [defaultCenter addObserver:self
                      selector:@selector(eventDidUnloadNotification:)
                          name:self.document.eventDidUnloadNotification
                        object:self.document];
}

- (void)eventDidUnloadNotification:(NSNotification *)notification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:self.document.eventDidUnloadNotification object:notification.object];
    [self eventDidUnload];
    [defaultCenter addObserver:self
                      selector:@selector(eventDidLoadNotification:)
                          name:self.document.eventDidLoadNotification
                        object:self.document];
}

- (void)eventListenDidStartNotification:(NSNotification *)notification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:self.document.eventListenDidStartNotification object:self.document];
    [self eventListenDidStart];
    [defaultCenter addObserver:self
                      selector:@selector(eventListenDidStopNotification:)
                          name:self.document.eventListenDidStopNotification
                        object:self.document];
}

- (void)eventListenDidStopNotification:(NSNotification *)notification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:self.document.eventListenDidStopNotification object:self.document];
    [self eventListenDidStop];
    [defaultCenter addObserver:self
                      selector:@selector(eventListenDidStartNotification:)
                          name:self.document.eventListenDidStartNotification
                        object:self.document];
}

@end
