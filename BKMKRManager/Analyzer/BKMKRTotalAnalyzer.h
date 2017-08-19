//
//  BKMKRTotalAnalyzer.h
//  BKMKRManager
//
//  Created by Chemersky on 6/5/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Total;

@interface BKMKRTotalAnalyzer : NSObject
+ (BOOL)analyzeTotal:(Total *)total withCoefficient:(float)coefficient;
+ (float)betMWaitCoefficientFromTotal:(Total *)total;
+ (float)betMWaitFromTotal:(Total *)total withCoefficient:(float)k;
+ (BOOL)analyzeWin:(float)winCoefficient withCoefficient:(float)coefficient;
@end
