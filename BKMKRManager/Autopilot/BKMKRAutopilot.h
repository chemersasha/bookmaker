//
//  BKMKRAutopilot.h
//  BKMKRManager
//
//  Created by Chemersky on 10/16/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebView;
@class Total;
@class Document;

@interface BKMKRAutopilot : NSObject

- (instancetype)initWithWebView:(WebView *)webView document:(Document *)document;

- (void)processBetTotalOver:(Total *)total completion:(void(^)())completion;

@end
