//
//  ImageDetailAnimator.m
//  ImageViewer
//
//  Created by Chemersky on 2/21/16.
//  Copyright © 2016 Chemer. All rights reserved.
//

#import "BKMKRViewControllerAnimator.h"
#import "NSView+Layout.h"

@implementation BKMKRViewControllerAnimator

- (void)animatePresentationOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController
{
    NSView *fromView = fromViewController.view;
    NSView *view = viewController.view;
    
    fromView.wantsLayer = YES;
    view.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    view.alphaValue = 0;
    
    [fromView.superview addSubview:view layout:BKMKRLayoutAligmentFit];
    fromView.hidden = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context)
                        {
                            context.duration = 0.5;
                            viewController.view.animator.alphaValue = 1;
                        }
                        completionHandler:nil
     ];
}

- (void)animateDismissalOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController
{
    NSView *fromView = fromViewController.view;
    NSView *view = viewController.view;
    
    fromView.hidden = NO;
    view.wantsLayer = YES;
    view.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5;
        viewController.view.animator.alphaValue = 0;
    } completionHandler:^{
        [viewController.view removeFromSuperview];
    }];
}

@end
