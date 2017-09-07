//
//  BKMKRStepperTextField.h
//  BKMKRManager
//
//  Created by Chemersky on 8/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BKMKRStepperTextField;

@protocol BKMKRStepperTextFieldDelegate <NSObject>
- (void)stepperTextFieldValueDidChange:(BKMKRStepperTextField *)textField;
@end

@interface BKMKRStepperTextField : NSViewController
- (instancetype)initWithDelegate:(id<BKMKRStepperTextFieldDelegate>)delegate;
@property (weak) IBOutlet NSTextField *textField;
@end
