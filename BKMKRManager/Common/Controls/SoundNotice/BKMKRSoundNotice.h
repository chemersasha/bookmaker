//
//  BKMKRSoundNotice.h
//  BKMKRManager
//
//  Created by Chemersky on 8/18/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BKMKRSoundNotice : NSViewController

- (instancetype)initWithResourceName:(NSString *)resourceName;

#pragma mark -

- (void)startNotice;
- (void)stopNotice;

@end
