//
//  BKMKREventHandlerView.m
//  BKMKRManager
//
//  Created by Chemersky on 5/27/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKREventHandlerView.h"

@implementation BKMKREventHandlerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

#pragma mark - Events

-(void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
    
    if (event.clickCount == 2) {
        if ([self.delegate respondsToSelector:@selector(viewDidDoubleClick:)]) {
            [self.delegate viewDidDoubleClick:self];
        }
    }
}

@end
