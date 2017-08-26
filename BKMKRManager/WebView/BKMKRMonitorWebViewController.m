//
//  BKMKRMonitorWebViewController.m
//  BKMKRManager
//
//  Created by Chemersky on 5/21/17.
//  Copyright © 2017 Chemer. All rights reserved.
//
#import <WebKit/WebKit.h>

#import "BKMKRMonitorWebViewController.h"
#import "Document+notifications.h"
#import "BKMKRWebParser.h"
#import "BKMKRDataModelManager.h"
#import "Event+CoreDataClass.h"
#import "BKMKREventInfo.h"

static NSString * const kBKMKRWebViewUrl = @"https://www.favoritsport.com.ua/ru/live/";

@interface BKMKRMonitorWebViewController ()
@property (nonatomic, strong) BKMKRDataModelManager *dataModelManager;
@property (weak) Document *document;
@property (nonatomic, strong) NSTimer *monitorWebViewTimer;

@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSProgressIndicator *webViewIndicator;
@property (weak) IBOutlet NSButton *listenCheckbox;
@end

@implementation BKMKRMonitorWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self load];
}

- (void)dealloc {
    self.webView.frameLoadDelegate = nil;
    [self stopMonitorTimer];
}

#pragma mark - Actions

- (IBAction)load:(id)sender {
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.stringValue]]];
}

- (IBAction)addEvent:(id)sender {
    NSString *url = self.webView.mainFrameURL;
    NSArray *urlComponents = [url componentsSeparatedByString:@"event="];
    if(urlComponents.count>1) {
        BKMKRWebParser *webParser = [[BKMKRWebParser alloc] initWithWebView:self.webView];
        [webParser parseTeamNamesWithCompletion:^(NSArray *data) {
            Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.dataModelManager.context];
            event.eventId = urlComponents[1];
            event.team1Name = data[0];
            event.team2Name = data[1];
            
            self.document.event = event;
            [self loadEvent:event];
        }];
    }
}

- (IBAction)removeEvent:(id)sender {
    [self.dataModelManager removeEvent:self.document.event];
    [self stopMonitor];
    [self clean];
}

- (IBAction)listen:(NSButton *)sender {
    if (sender.state == NSOnState) {
        [self startMonitor];
    } else {
        [self stopMonitor];
    }
}

#pragma mark -
//@TODO remove dataModelManager property and create event load manager
- (void)load {
    self.document = self.view.window.windowController.document;
    self.dataModelManager = [[BKMKRDataModelManager alloc]
        initWithContext:[self.document managedObjectContext]
    ];
    NSError *error = nil;
    NSArray *events = [self.dataModelManager fetchEvents:&error];
    if (!error && events.count>0) {
        self.document.event = events[0];
    }

    self.document.event ? [self loadEvent:self.document.event] : [self clean];
//    [self load:nil];
}

- (void)loadEvent:(Event *)event {
    self.urlTextField.stringValue = [NSString stringWithFormat:@"%@#event=%@", kBKMKRWebViewUrl, event.eventId];

    [[NSNotificationCenter defaultCenter] postNotificationName:self.document.eventDidLoadNotification
                                                       object:self.document];
}

- (void)startMonitor {
    [self startMonitorTimer];
    
    self.document.eventInfo = [BKMKREventInfo new];
    [self parseWebViewDynamicInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.document.eventListenDidStartNotification object:self.document userInfo:@{self.document.userInfoDataKey:self.document.event.eventId}];
}

- (void)stopMonitor {
    [self stopMonitorTimer];
    self.document.eventInfo = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.document.eventListenDidStopNotification object:self.document userInfo:@{self.document.userInfoDataKey:self.document.event.eventId}];
}

- (void)clean {
    self.document.event = nil;
    self.urlTextField.stringValue = kBKMKRWebViewUrl;
    self.listenCheckbox.state = NSOffState;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.document.eventDidUnloadNotification
                                                       object:self.document];
}

#pragma mark - Monitor timer

- (void)startMonitorTimer {
    __weak BKMKRMonitorWebViewController *wSelf = self;
    self.monitorWebViewTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [wSelf monitorDidSceduleTimer:timer];
    }];
}

- (void)stopMonitorTimer {
    [self.monitorWebViewTimer invalidate];
    self.monitorWebViewTimer = nil;
}

- (void)monitorDidSceduleTimer:(NSTimer *)timer {
    [self parseWebViewDynamicInfo];
}

#pragma mark - Web Parser

- (void)parseWebViewDynamicInfo {
    [self parseScore];
    [self parseTotals];
    [self parse1X2];
}

- (void)parseScore {
    BKMKRWebParser *webParser = [[BKMKRWebParser alloc] initWithWebView:self.webView];
    __weak BKMKRMonitorWebViewController *wSelf = self;
    [webParser parseScoreWithCompletion:^(NSArray *data) {
        if (data.count > 1) {
            NSNumber *team1Score = [NSNumber numberWithInteger:((NSString *)data[0]).integerValue];
            if (wSelf.document.eventInfo.team1Score != team1Score) {
                wSelf.document.eventInfo.team1Score = team1Score;
                [[NSNotificationCenter defaultCenter] postNotificationName:wSelf.document.webViewTeam1ScoreDidChangeNotification
                                                                object:wSelf.document
                                                              userInfo:@{wSelf.document.userInfoDataKey:team1Score}];
            }
            NSNumber *team2Score = [NSNumber numberWithInteger:((NSString *)data[1]).integerValue];
            if (wSelf.document.eventInfo.team2Score != team2Score) {
                wSelf.document.eventInfo.team2Score = team2Score;
                [[NSNotificationCenter defaultCenter] postNotificationName:wSelf.document.webViewTeam2ScoreDidChangeNotification
                                                                object:wSelf.document
                                                              userInfo:@{wSelf.document.userInfoDataKey:team2Score}];
            }
        }
    }];
}

- (void)parseTotals {
    BKMKRWebParser *webParser = [[BKMKRWebParser alloc] initWithWebView:self.webView];
    __weak BKMKRMonitorWebViewController *wSelf = self;
    [webParser parseTotalsWithCompletion:^(NSDictionary *data) {
        self.document.eventInfo.totals = data;
        [[NSNotificationCenter defaultCenter] postNotificationName:wSelf.document.webViewTotalsDidReceiveNotification
                                                        object:wSelf.document
                                                      userInfo:@{wSelf.document.userInfoDataKey:data}];
    }];
}

- (void)parse1X2 {
    BKMKRWebParser *webParser = [[BKMKRWebParser alloc] initWithWebView:self.webView];
    __weak BKMKRMonitorWebViewController *wSelf = self;
    [webParser parse1X2WithCompletion:^(NSArray *data) {
        self.document.eventInfo.win1X2 = data;
        [[NSNotificationCenter defaultCenter] postNotificationName:wSelf.document.webViewWin1X2DidReceiveNotification
                                                        object:wSelf.document
                                                      userInfo:@{wSelf.document.userInfoDataKey:data}];
    }];
}


#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    self.webViewIndicator.hidden = YES;
    [self.webViewIndicator stopAnimation:nil];
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
    self.webViewIndicator.hidden = NO;
    [self.webViewIndicator startAnimation:nil];
}

@end
