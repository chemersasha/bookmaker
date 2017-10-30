//
//  BKMKRAutopilotCoordinator.m
//  BKMKRManager
//
//  Created by Chemersky on 10/26/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRAutopilotCoordinator.h"

@interface BKMKRAutopilotCoordinator ()
@property (strong, atomic) NSMutableArray *processes;
@end

@implementation BKMKRAutopilotCoordinator

+ (id)sharedInstance {
    static BKMKRAutopilotCoordinator *sharedAutopilotCoordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAutopilotCoordinator = [[super alloc] initSharedInstance];
    });
    return sharedAutopilotCoordinator;
}

-(instancetype) initSharedInstance {
    self = [super init];
    if (self) {
        self.processes = [NSMutableArray new];
    }
    return self;
}

#pragma mark -

- (void)addBetProcess:(BKMKRAutopilotCoordinatorProcess)process {
    @synchronized (self) {
        [self.processes addObject:[process copy]];
        if(self.processes.count == 1) {
            [self runProcess:process];
        }
    }
}

- (void)runProcess:(BKMKRAutopilotCoordinatorProcess)process {
    @synchronized (self) {
        BKMKRAutopilotCoordinator * __weak wSelf = self;
        process(^() {
            [wSelf.processes removeObject:[wSelf.processes firstObject]];
            BKMKRAutopilotCoordinatorProcess nextProcess = [wSelf.processes firstObject];
            if(nextProcess) {
                [wSelf runProcess:nextProcess];
            }
        });
    }
}

@end
