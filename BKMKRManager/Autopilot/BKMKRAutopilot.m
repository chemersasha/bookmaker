//
//  BKMKRAutopilot.m
//  BKMKRManager
//
//  Created by Chemersky on 10/16/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "BKMKRAutopilot.h"
#import "BKMKRAutopilotCoordinator.h"
#import "Document.h"
#import "BKMKRTotalAnalyzer.h"
#import "Total+CoreDataClass.h"

@interface BKMKRAutopilot ()
@property (nonatomic, strong) WebView *webView;
@property (nonatomic, weak) Document *document;
@end

@implementation BKMKRAutopilot

- (instancetype)initWithWebView:(WebView *)webView document:(Document *)document;
{
    self = [super init];
    if (self) {
        self.webView = webView;
        self.document = document;
    }
    return self;
}

#pragma mark -

- (void)processBetTotalOver:(Total *)total completion:(void(^)(float bet, float profit))completion{
    BKMKRAutopilotCoordinator *coordinator = [BKMKRAutopilotCoordinator sharedInstance];

    [coordinator addBetProcess:^(BKMKRAutopilotCoordinatorProcessCompletion processCompletion) {
        [NSApp activateIgnoringOtherApps:YES];
        [[self.document.windowControllers[0] window] makeKeyAndOrderFront:nil];

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSString *selectAndFocusPath = [[NSBundle mainBundle] pathForResource:@"selectAndFocus" ofType:@"js"];
            NSString *selectAndFocusScript = [NSString stringWithContentsOfFile:selectAndFocusPath encoding:NSUTF8StringEncoding error:nil];
            
            NSString *clickTotalPath = [[NSBundle mainBundle] pathForResource:@"clickTotal" ofType:@"js"];
            NSString *clickTotalScript = [NSString stringWithContentsOfFile:clickTotalPath encoding:NSUTF8StringEncoding error:nil];
            clickTotalScript = [clickTotalScript stringByReplacingOccurrencesOfString:@"<<<>>>" withString:[NSString stringWithFormat:@"%.1f", total.total]];
            
            BKMKRAutopilot * __weak wSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.webView stringByEvaluatingJavaScriptFromString:clickTotalScript];
                [wSelf.webView stringByEvaluatingJavaScriptFromString:selectAndFocusScript];
                
                float totalOverCoefficient = [wSelf.document.eventInfo totalInfoAtTotalValue:total.total].mCoefficient;
                float betMWait = floor([BKMKRTotalAnalyzer betMWaitFromTotal:total withCoefficient:totalOverCoefficient]);

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [wSelf inputNumber:betMWait];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [wSelf.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('bbet_pl')[0].click();"];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            //@TODO If (Ставка принимается) refresh webview
                            //@TODO Check bet is passed or not.
                            NSString *profit = [wSelf.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('bbet_inp_maxp')[0].innerText;"];
                            [wSelf.webView stringByEvaluatingJavaScriptFromString:clickTotalScript];
                            
                            completion(betMWait, profit.floatValue);
                            processCompletion();
                        });
                    });
                });
            });
        });
    }];
}

#pragma mark -

- (void)inputNumber:(float)number {
    NSArray *inputNumbers = [self splitNumber:number];
    [inputNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGEventRef keydown, keyup;
        CGKeyCode keyCode = [self keyCodeAtNumber:obj];
        keydown = CGEventCreateKeyboardEvent(NULL, keyCode, true);
        keyup = CGEventCreateKeyboardEvent(NULL, keyCode, false);
        CGEventPost(kCGHIDEventTap, keydown);
        CGEventPost(kCGHIDEventTap, keyup);
        CFRelease(keydown);
        CFRelease(keyup);
    }];
}

- (NSArray *)splitNumber:(float)value {
    NSMutableArray *result = [NSMutableArray new];
    while (value >= 1) {
        float num = (value/10) - floor(value/10);
        [result addObject:[NSNumber numberWithInt:(num*10)]];
        value = floor(value/10);
    }
    return [[result reverseObjectEnumerator] allObjects];
}

- (CGKeyCode)keyCodeAtNumber:(NSNumber *)number {
    CGKeyCode result;
    switch ([number intValue]) {
        case 1:
            result = 18;
            break;
        case 2:
            result = 19;
            break;
        case 3:
            result = 20;
            break;
        case 4:
            result = 21;
            break;
        case 5:
            result = 23;
            break;
        case 6:
            result = 22;
            break;
        case 7:
            result = 26;
            break;
        case 8:
            result = 28;
            break;
        case 9:
            result = 25;
            break;
        default:
            result = 29;
            break;
    }
    return result;
}

@end
