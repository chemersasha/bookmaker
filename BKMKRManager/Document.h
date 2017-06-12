//
//  Document.h
//  BKMKRManager
//
//  Created by Chemersky on 4/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Event+CoreDataClass.h"
#import "BKMKREventInfo.h"

@interface Document : NSPersistentDocument
@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) BKMKREventInfo *eventInfo;
@end
