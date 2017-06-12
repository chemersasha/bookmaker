//
//  BKMKREventHandlerView.h
//  BKMKRManager
//
//  Created by Chemersky on 5/27/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BKMKREventHandlerView;

@protocol BKMKREventHandlerViewDelegate <NSObject>
- (void)viewDidDoubleClick:(BKMKREventHandlerView *)item;
@end


@interface BKMKREventHandlerView : NSView
@property (nonatomic, weak) IBOutlet id<BKMKREventHandlerViewDelegate> delegate;
@end
