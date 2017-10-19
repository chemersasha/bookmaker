//
//  BKMKREventInfo.m
//  BKMKRManager
//
//  Created by Chemersky on 6/1/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKREventInfo.h"

@implementation BKMKREventInfo

- (BKMKRTotalInfo)totalInfoAtTotalValue:(float)total {
    BKMKRTotalInfo result = {.lCoefficient=0, .mCoefficient=0};
    
    NSString *dataKey = [NSString stringWithFormat:@"Меньше (%.1f)", total];
    NSString *dataValue = self.totals[dataKey];
    if (dataValue) {
        result.lCoefficient = dataValue.floatValue;
    }
    
    dataKey = [NSString stringWithFormat:@"Больше (%.1f)", total];
    dataValue = self.totals[dataKey];
    if (dataValue) {
        result.mCoefficient = dataValue.floatValue;
    }
    
    return result;
}

@end
