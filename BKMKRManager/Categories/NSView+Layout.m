//
//  NSView+Layout.m
//  BKMKRManager
//
//  Created by Chemersky on 5/20/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "NSView+Layout.h"

@implementation NSView (Layout)

- (void)addSubview:(NSView *)subview layout:(BKMKRLayoutAligment)aligment {
    [self addSubview:subview];
    
    switch (aligment) {
        case BKMKRLayoutAligmentFit:
            [self fitToSizeSubview:subview];
            break;

        default:
            break;
    }
}

- (void)fitToSizeSubview:(NSView *)subview {
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:0]];
}

@end
