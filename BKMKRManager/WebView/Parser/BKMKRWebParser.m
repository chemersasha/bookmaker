//
//  BKMKRWebParser.m
//  BKMKRManager
//
//  Created by Chemersky on 4/23/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "BKMKRWebParser.h"

@interface BKMKRWebParser ()
@property (nonatomic, strong) WebView *webView;
@end


@implementation BKMKRWebParser

- (instancetype)initWithWebView:(WebView *)webView
{
    self = [super init];
    if (self) {
        self.webView = webView;
    }
    return self;
}

#pragma mark -

- (void)parseTotalsWithCompletion:(void (^)(NSDictionary *totals))completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"total" ofType:@"js"];
        NSString *callback = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *page = [self.webView stringByEvaluatingJavaScriptFromString:callback];
            NSArray *totals = [page componentsSeparatedByString:@"\n"];
            NSMutableDictionary *result = [NSMutableDictionary new];
            for (NSString *item in totals) {
                NSArray *total = [item componentsSeparatedByString:@"&"];
                if (total.count > 1) {
                    [result setObject:total[1] forKey:total[0]];
                }
            }
            completionHandler(result.copy);
        });
    });
}

- (void)parseScoreWithCompletion:(void (^)(NSArray *score))completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"js"];
        NSString *callback = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *page = [self.webView stringByEvaluatingJavaScriptFromString:callback];
            NSArray *score = [page componentsSeparatedByString:@"\n"];
            completionHandler(score);
        });
    });
}

- (void)parseTeamNamesWithCompletion:(void (^)(NSArray *score))completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"teamsInfo" ofType:@"js"];
        NSString *callback = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *page = [self.webView stringByEvaluatingJavaScriptFromString:callback];
            NSArray *names = [page componentsSeparatedByString:@"&&"];
            completionHandler(names);
        });
    });
}

- (void)parse1X2WithCompletion:(void (^)(NSArray *data))completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"win1X2" ofType:@"js"];
        NSString *callback = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *page = [self.webView stringByEvaluatingJavaScriptFromString:callback];
            NSArray *result = [page componentsSeparatedByString:@"&&"];
            completionHandler(result);
        });
    });
}

@end
