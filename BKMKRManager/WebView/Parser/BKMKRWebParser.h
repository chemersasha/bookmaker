//
//  BKMKRWebParser.h
//  BKMKRManager
//
//  Created by Chemersky on 4/23/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKMKRWebParser : NSObject

- (instancetype)initWithWebView:(WebView *)webView;

- (void)parseTotalsWithCompletion:(void (^)(NSDictionary *totals))completionHandler;
- (void)parseScoreWithCompletion:(void (^)(NSArray *score))completionHandler;
- (void)parseTeamNamesWithCompletion:(void (^)(NSArray *score))completionHandler;
- (void)parse1X2WithCompletion:(void (^)(NSArray *data))completionHandler;
@end
