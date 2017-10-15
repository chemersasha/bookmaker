//
//  BKMKRWinAnalyzer.m
//  BKMKRManager
//
//  Created by Chemersky on 10/15/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRWinAnalyzer.h"

@implementation BKMKRWinAnalyzer

+ (BOOL)analyzeWin:(float)winCoefficient withCoefficient:(float)coefficient {
    BOOL result = NO;
    if ((winCoefficient > coefficient)) {
        result = YES;
    }
    return result;
}

@end
