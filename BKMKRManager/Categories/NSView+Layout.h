//
//  NSView+Layout.h
//  BKMKRManager
//
//  Created by Chemersky on 5/20/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    BKMKRLayoutAligmentFit
} BKMKRLayoutAligment;

@interface NSView (Layout)
- (void)addSubview:(NSView *)subview layout:(BKMKRLayoutAligment)aligment;
@end
