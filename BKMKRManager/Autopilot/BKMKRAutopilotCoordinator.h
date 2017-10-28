//
//  BKMKRAutopilotCoordinator.h
//  BKMKRManager
//
//  Created by Chemersky on 10/26/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BKMKRAutopilotCoordinatorProcessCompletion)();
typedef void(^BKMKRAutopilotCoordinatorProcess)(BKMKRAutopilotCoordinatorProcessCompletion completion);

@interface BKMKRAutopilotCoordinator : NSObject

+(instancetype) sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));
-(instancetype) copy __attribute__((unavailable("copy not available, call sharedInstance instead")));

#pragma mark -

- (void)runBetProcess:(BKMKRAutopilotCoordinatorProcess)process;

@end
