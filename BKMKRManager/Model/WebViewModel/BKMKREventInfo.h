//
//  BKMKREventInfo.h
//  BKMKRManager
//
//  Created by Chemersky on 6/1/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct BKMKRTotalInfo {
    float lCoefficient;
    float mCoefficient;
} BKMKRTotalInfo;

@interface BKMKREventInfo : NSObject
@property (nonatomic, strong) NSNumber *team1Score;
@property (nonatomic, strong) NSNumber *team2Score;
@property (nonatomic, strong) NSDictionary *totals;

- (BKMKRTotalInfo)totalInfoAtTotal:(float)total;
@end
