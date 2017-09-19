//
//  BKMKRStepperTextField.m
//  BKMKRManager
//
//  Created by Chemersky on 8/22/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRStepperTextField.h"

@interface BKMKRStepperTextField ()
@property (weak, nonatomic) id<BKMKRStepperTextFieldDelegate> delegate;
@property (weak) IBOutlet NSStepper *stepper;
@end


@implementation BKMKRStepperTextField

- (instancetype)initWithDelegate:(id<BKMKRStepperTextFieldDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - Actions

- (IBAction)textFieldValueDidChange:(NSTextField *)sender {
    self.stepper.floatValue = sender.floatValue;
    if ([self.delegate respondsToSelector:@selector(stepperTextFieldValueDidChange:)]) {
        [self.delegate stepperTextFieldValueDidChange:self];
    }
}

- (IBAction)stepperValueDidChange:(NSStepper *)sender {
    if ([self.delegate respondsToSelector:@selector(stepperTextFieldValueDidChange:)]) {
        [self.delegate stepperTextFieldValueDidChange:self];
    }
}

@end
