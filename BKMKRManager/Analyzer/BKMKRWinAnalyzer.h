//
//  BKMKRWinAnalyzer.h
//  BKMKRManager
//
//  Created by Chemersky on 10/15/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKMKRWinAnalyzer : NSObject
+ (BOOL)analyzeWin:(float)winCoefficient withCoefficient:(float)coefficient;
@end
