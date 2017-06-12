//
//  BKMKRTotalAnalyzer.m
//  BKMKRManager
//
//  Created by Chemersky on 6/5/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRTotalAnalyzer.h"
#import "Total+CoreDataClass.h"

@implementation BKMKRTotalAnalyzer

+ (BOOL)analyzeTotal:(Total *)total withCoefficient:(float)coefficient {
    BOOL result = NO;

    float waitCoefficient = [BKMKRTotalAnalyzer betMWaitCoefficientFromTotal:total];
    if (waitCoefficient!=0 && coefficient>waitCoefficient) {
        result = YES;
    }

    return result;
}

+ (float)betMWaitCoefficientFromTotal:(Total *)total {
    float result = 0;
    
    if (!((total.profitM-total.betM-total.betL)>=total.profit && (total.profitL-total.betM-total.betL)>=total.profit)) {
        result = ((total.betM+total.betL+total.profit-total.profitM)/(total.profitL-total.profit-total.betL-total.betM)+1);
    }
    return result;
}

+ (float)betMWaitFromTotal:(Total *)total withCoefficient:(float)k {
    float result = (total.profit-total.profitM+total.betM+total.betL)/(k-1);
    
    return result;
}

@end
