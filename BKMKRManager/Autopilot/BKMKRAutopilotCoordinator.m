//
//  BKMKRAutopilotCoordinator.m
//  BKMKRManager
//
//  Created by Chemersky on 10/26/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRAutopilotCoordinator.h"

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
    return [super init];
}

#pragma mark -

- (void)runBetProcess:(BKMKRAutopilotCoordinatorProcess)process {
    //@TODO Create queue of indexes of processes. Add index
    process(^() {
        //@TODO remove index of process
        NSLog(@"Completion");
    });
}

@end
